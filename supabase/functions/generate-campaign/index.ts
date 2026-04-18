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

    // ── 1. Authenticate user ──
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return errorResponse("Missing authorization header", 401);
    }

    // Parse body early (before async work)
    const { topic, country, language, phone } = await req.json();
    if (!topic || !country || !language) {
      return errorResponse("topic, country, and language are required");
    }

    const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const token = authHeader.replace("Bearer ", "");

    // Run auth + tier check in parallel
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

    // ── 2. Check daily text usage ──
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
          `Daily limit reached (${limits.daily_texts} text campaigns/day). Upgrade your plan for unlimited access.`,
          429
        );
      }
    }

    // ── 3. Call Gemini (thinking disabled for speed) ──
    const prompt = `You are an expert education marketing copywriter. Generate a complete high-converting marketing campaign for the education sector.

Topic: ${topic}
Target Country: ${country}
Language/Style: ${language}
Contact Number: ${phone || "N/A"}

Generate the following in valid JSON:
{
  "headline": "attention-grabbing headline",
  "subheadline": "supporting line with urgency",
  "body": "2-3 paragraphs of persuasive marketing copy in ${language} style",
  "cta": "strong call-to-action",
  "whatsapp_message": "ready-to-send WhatsApp message (under 300 chars)",
  "sms_text": "SMS version (under 160 chars)",
  "hashtags": ["5-8 relevant hashtags"],
  "target_audience": "who this targets",
  "key_benefits": ["3-5 selling points"]
}

Rules:
- Write in ${language} style
- Culturally relevant for ${country}
- Include contact number ${phone || ""} in CTA/WhatsApp if provided
- Persuasive and action-oriented
- Output ONLY valid JSON`;

    const geminiRes = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.8,
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

    let campaign;
    try {
      campaign = JSON.parse(text);
    } catch {
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        try {
          campaign = JSON.parse(jsonMatch[0]);
        } catch {
          campaign = { raw_text: text };
        }
      } else {
        campaign = { raw_text: text };
      }
    }

    // ── 4. Log usage (fire-and-forget) ──
    supabaseAdmin.from("usage_logs").insert({
      user_id: user.id,
      feature: "text",
    }).then(() =>
      supabaseAdmin.rpc("increment_counter", {
        row_id: user.id,
        column_name: "total_campaigns",
      })
    ).catch(() => {});

    return new Response(JSON.stringify({ campaign }), {
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
