import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const GEMINI_URL =
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

const TIER_LIMITS: Record<string, { daily_texts: number }> = {
  free: { daily_texts: 5 },
  silver: { daily_texts: -1 },
  golden: { daily_texts: -1 },
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function errorResponse(message: string, status = 400) {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    if (!GEMINI_API_KEY) {
      throw new Error("GEMINI_API_KEY is not set");
    }

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return errorResponse("Missing authorization header", 401);
    }

    const body = await req.json();
    const {
      materialType, outputLanguage, outputSize, designStyle, targetAudience,
      topic, institution, tagline, phone, email, website, address,
      keyOfferings, usp,
    } = body;

    if (!topic) {
      return errorResponse("topic is required");
    }

    const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const token = authHeader.replace("Bearer ", "");

    const [authResult, subResult] = await Promise.all([
      supabaseAdmin.auth.getUser(token),
      supabaseAdmin.auth.getUser(token).then(({ data }) =>
        data.user
          ? supabaseAdmin.from("subscriptions").select("tier").eq("id", data.user.id).single()
          : { data: null }
      ),
    ]);

    const user = authResult.data.user;
    if (authResult.error || !user) {
      return errorResponse("Invalid or expired token", 401);
    }

    const tier = subResult.data?.tier ?? "free";
    const limits = TIER_LIMITS[tier] ?? TIER_LIMITS.free;

    if (limits.daily_texts !== -1) {
      const todayStart = new Date();
      todayStart.setHours(0, 0, 0, 0);

      const { count } = await supabaseAdmin
        .from("usage_logs")
        .select("id", { count: "exact", head: true })
        .eq("user_id", user.id)
        .eq("feature", "text")
        .gte("created_at", todayStart.toISOString());

      if ((count ?? 0) >= limits.daily_texts) {
        return errorResponse(
          `Daily limit reached (${limits.daily_texts}/day). Upgrade for unlimited access.`,
          429
        );
      }
    }

    const prompt = `Generate ${materialType || "Brochure"} content for "${topic}" in ${outputLanguage || "English"}.
Style: ${designStyle || "Professional"}. Audience: ${targetAudience || "Students"}.${institution ? ` Institution: ${institution}.` : ""}${tagline ? ` Tagline: ${tagline}.` : ""}${phone ? ` Phone: ${phone}.` : ""}${email ? ` Email: ${email}.` : ""}${website ? ` Web: ${website}.` : ""}${address ? ` Address: ${address}.` : ""}${keyOfferings ? ` Offerings: ${keyOfferings}.` : ""}${usp ? ` USP: ${usp}.` : ""}

Return JSON: {"title":"...","subtitle":"...","sections":[{"heading":"...","content":"1-2 sentences"}],"key_highlights":["3-4 items"],"call_to_action":"...","contact_block":"...","whatsapp_message":"under 200 chars"}
Brochures: 4-5 sections. Flyers/posters: 2-3 sections. Banners: 1-2 sections. Only valid JSON.`;

    const geminiRes = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.7,
          responseMimeType: "application/json",
          thinkingConfig: { thinkingBudget: 0 },
        },
      }),
    });

    if (!geminiRes.ok) {
      const err = await geminiRes.text();
      throw new Error(`Gemini API returned ${geminiRes.status}: ${err.substring(0, 200)}`);
    }

    const geminiData = await geminiRes.json();
    const parts = geminiData?.candidates?.[0]?.content?.parts ?? [];

    let text = "";
    for (const part of parts) {
      if (part.text && !part.thought) {
        text += part.text;
      }
    }
    if (!text && parts.length > 0) {
      text = parts[parts.length - 1].text ?? "";
    }

    text = text.replace(/```json\s*/gi, "").replace(/```\s*/gi, "").trim();

    let material;
    try {
      material = JSON.parse(text);
    } catch {
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        try {
          material = JSON.parse(jsonMatch[0]);
        } catch {
          material = { raw_text: text };
        }
      } else {
        material = { raw_text: text };
      }
    }

    supabaseAdmin.from("usage_logs").insert({
      user_id: user.id,
      feature: "text",
    }).then(() =>
      supabaseAdmin.rpc("increment_counter", {
        row_id: user.id,
        column_name: "total_print_materials",
      })
    ).catch(() => {});

    return new Response(JSON.stringify({ material }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
