import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const CF_ACCOUNT_ID = Deno.env.get("CF_ACCOUNT_ID");
const CF_API_TOKEN = Deno.env.get("CF_API_TOKEN");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const CF_URL = `https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/ai/run/@cf/black-forest-labs/flux-2-klein-9b`;

const TIER_LIMITS: Record<string, { monthly_images: number }> = {
  free: { monthly_images: 30 },
  silver: { monthly_images: 100 },
  golden: { monthly_images: 300 },
};

const ASPECT_DIMENSIONS: Record<string, { width: number; height: number }> = {
  "1:1 Square (Instagram Post / Profile)": { width: 1024, height: 1024 },
  "4:5 Portrait (Instagram Feed)": { width: 896, height: 1120 },
  "9:16 Story (Instagram / WhatsApp / Reels)": { width: 576, height: 1024 },
  "16:9 Landscape (YouTube / Facebook)": { width: 1216, height: 704 },
  "3:1 Wide Banner (Website / Print)": { width: 1536, height: 512 },
  "A4 Portrait (Print Ready)": { width: 832, height: 1152 },
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

const ASPECT_MAP: Record<string, string> = {
  "1:1 Square (Instagram Post / Profile)": "1:1 square",
  "4:5 Portrait (Instagram Feed)": "4:5 portrait",
  "9:16 Story (Instagram / WhatsApp / Reels)": "9:16 vertical",
  "16:9 Landscape (YouTube / Facebook)": "16:9 landscape",
  "3:1 Wide Banner (Website / Print)": "ultra-wide banner",
  "A4 Portrait (Print Ready)": "A4 portrait",
};

function buildPrompt(body: Record<string, unknown>): string {
  const {
    imageType, topic, institution, aspectRatio, visualStyle,
    colorScheme, includeTextOverlay, headline, subText,
  } = body;

  const topicStr = (topic as string) || "education";
  const institutionStr = (institution as string) || "";
  const aspectStr = ASPECT_MAP[(aspectRatio as string)] || (aspectRatio as string) || "square";
  const styleStr = (visualStyle as string) || "Photorealistic";
  const colorsStr = (colorScheme as string) || "warm tones";

  const studentContext = topicStr.toLowerCase().includes("mbbs")
    ? "Indian medical student wearing a white lab coat, holding books and a stethoscope"
    : topicStr.toLowerCase().includes("neet")
    ? "young Indian student in a study setting, surrounded by competitive exam preparation books"
    : topicStr.toLowerCase().includes("engineering")
    ? "young engineering student holding blueprints, with technical equipment nearby"
    : topicStr.toLowerCase().includes("mba")
    ? "young professional in smart business attire, holding a laptop and portfolio"
    : "young student holding books, looking confident and aspirational";

  const backgroundContext = topicStr.toLowerCase().includes("mbbs")
    ? "modern university campus or hospital with international architecture"
    : topicStr.toLowerCase().includes("abroad")
    ? "prestigious international university campus with iconic architecture"
    : topicStr.toLowerCase().includes("neet")
    ? "modern coaching institute classroom or library"
    : "modern educational campus with contemporary architecture";

  let prompt = `Create a ${imageType || "marketing poster"} for "${topicStr}"${institutionStr ? ` by "${institutionStr}"` : ""}.

Design a ${aspectStr} composition in a ${styleStr} style with a ${colorsStr} color palette.
The design should feel premium, modern, clean, and suitable for high-quality social media marketing.

Main subject:
A confident ${studentContext}, smiling and looking aspirational.

Background:
A ${backgroundContext}, slightly blurred with depth of field.

Lighting:
Soft natural lighting with warm tones matching the ${colorsStr} palette, cinematic glow, high dynamic range.

Composition:
Clear focal subject, balanced whitespace, clean layout, strong visual hierarchy, smooth gradients.

Graphic elements:
Minimal relevant icons subtly integrated (education / medical / global theme).`;

  if (includeTextOverlay && (headline || subText)) {
    prompt += `

Text overlay:
${headline ? `"${headline}"` : ""}
${subText ? `"${subText}"` : ""}
${institutionStr ? `Brand name "${institutionStr}" clearly visible` : ""}
CTA: "Apply Now"

Typography:
Modern sans-serif fonts, bold headline, clean and legible text.`;
  }

  prompt += `

Style constraints:
ultra realistic, highly detailed, 8k, professional photography, studio lighting, commercial advertising, instagram ad style, realistic skin tones, sharp focus, no clutter, no watermark`;

  return prompt.trim();
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const reqStart = Date.now();
  console.log("[generate-image] Request received:", req.method);

  try {
    if (!CF_ACCOUNT_ID || !CF_API_TOKEN) {
      console.error("[generate-image] Missing CF creds. ACCOUNT_ID:", !!CF_ACCOUNT_ID, "TOKEN:", !!CF_API_TOKEN);
      throw new Error("Cloudflare Workers AI credentials are not set");
    }

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return errorResponse("Missing authorization header", 401);
    }

    const body = await req.json();
    const { aspectRatio, variantCount } = body;

    if (!body.topic && !body.headline) {
      return errorResponse("topic or headline is required");
    }

    const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const token = authHeader.replace("Bearer ", "");

    const [authResult, subResult] = await Promise.all([
      supabaseAdmin.auth.getUser(token),
      supabaseAdmin.auth
        .getUser(token)
        .then(({ data }) =>
          data.user
            ? supabaseAdmin
                .from("subscriptions")
                .select("tier")
                .eq("id", data.user.id)
                .single()
            : { data: null }
        ),
    ]);

    const user = authResult.data.user;
    if (authResult.error || !user) {
      return errorResponse("Invalid or expired token", 401);
    }

    const tier = subResult.data?.tier ?? "free";
    const limits = TIER_LIMITS[tier] ?? TIER_LIMITS.free;

    // Check monthly image usage
    const monthStart = new Date();
    monthStart.setDate(1);
    monthStart.setHours(0, 0, 0, 0);

    const { count } = await supabaseAdmin
      .from("usage_logs")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .eq("feature", "image")
      .gte("created_at", monthStart.toISOString());

    const numVariants = Math.min(Math.max(variantCount ?? 1, 1), 3);

    if ((count ?? 0) + numVariants > limits.monthly_images) {
      return errorResponse(
        `Monthly image limit reached (${limits.monthly_images} images/month). Upgrade your plan for more.`,
        429
      );
    }

    const dims = ASPECT_DIMENSIONS[aspectRatio as string] ?? { width: 1024, height: 1024 };
    const prompt = buildPrompt(body);

    console.log("[generate-image] User:", user.id, "Tier:", tier, "Variants:", numVariants);
    console.log("[generate-image] Dims:", dims.width, "x", dims.height);
    console.log("[generate-image] ========== FLUX PROMPT ==========");
    console.log(prompt);
    console.log("[generate-image] ========== END PROMPT ==========");
    console.log("[generate-image] Calling Cloudflare FLUX 2 Klein 9B...");

    const cfStart = Date.now();

    // Generate variants in parallel using multipart/form-data
    const imagePromises = Array.from({ length: numVariants }, (_, i) => {
      const formData = new FormData();
      formData.append("prompt", prompt);
      formData.append("steps", "8");
      formData.append("width", String(dims.width));
      formData.append("height", String(dims.height));
      if (i > 0) {
        formData.append("seed", String(Math.floor(Math.random() * 2147483647)));
      }

      return fetch(CF_URL, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${CF_API_TOKEN}`,
        },
        body: formData,
      }).then(async (res) => {
        console.log("[generate-image] CF response status:", res.status, "variant:", i);
        const data = await res.json();
        if (!res.ok || !data.success) {
          const errMsg = data.errors?.[0]?.message || JSON.stringify(data.errors) || "Unknown error";
          console.error("[generate-image] CF error:", errMsg);
          throw new Error(`Cloudflare AI returned ${res.status}: ${errMsg}`);
        }
        const imgLen = (data.result.image as string)?.length ?? 0;
        console.log("[generate-image] Variant", i, "image base64 length:", imgLen);
        return data.result.image as string;
      });
    });

    const images = await Promise.all(imagePromises);
    console.log("[generate-image] All variants done in", Date.now() - cfStart, "ms");

    // Log usage (fire-and-forget)
    Promise.all(
      Array.from({ length: numVariants }, () =>
        supabaseAdmin.from("usage_logs").insert({
          user_id: user.id,
          feature: "image",
        })
      )
    )
      .then(() =>
        supabaseAdmin.rpc("increment_counter", {
          row_id: user.id,
          column_name: "total_images",
          increment_by: numVariants,
        })
      )
      .catch(() => {});

    console.log("[generate-image] SUCCESS. Total time:", Date.now() - reqStart, "ms. Images:", images.length);

    return new Response(
      JSON.stringify({
        images,
        prompt,
        dimensions: dims,
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("[generate-image] FATAL ERROR after", Date.now() - reqStart, "ms:", error.message);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
