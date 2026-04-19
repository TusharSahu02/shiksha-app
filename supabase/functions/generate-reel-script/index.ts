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
      prompt: userPrompt,
      reelDuration,
      reelStyle,
      musicGenre,
      targetPlatform,
      videoQuality,
      scriptLanguage,
      includeCaptions,
      includeVoiceoverScript,
    } = body;

    if (!userPrompt) {
      return errorResponse("prompt is required");
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

    const geminiPrompt = `You are a professional social media video script writer specializing in short-form content for education marketing.

Generate a complete, production-ready reel/short video script based on the following:

USER IDEA: "${userPrompt}"

SPECIFICATIONS:
- Duration: ${reelDuration || "30 seconds"}
- Style: ${reelStyle || "Cinematic & Emotional"}
- Background Music Genre: ${musicGenre || "Inspirational / Motivational"}
- Target Platform: ${targetPlatform || "Instagram Reels"}
- Video Quality/Resolution: ${videoQuality || "1080p HD (1080x1920)"}
- Script Language: ${scriptLanguage || "English"}
- Include Captions: ${includeCaptions !== false ? "Yes" : "No"}
- Include Voiceover Script: ${includeVoiceoverScript ? "Yes" : "No"}

Return a JSON object with this exact structure:
{
  "title": "Short catchy title for the reel",
  "hook": "Opening 2-3 second hook text that grabs attention",
  "scenes": [
    {
      "scene_number": 1,
      "duration": "0:00 - 0:03",
      "visual": "Detailed description of what appears on screen",
      "text_overlay": "Text shown on screen (if captions enabled)",
      "transition": "Cut / Zoom / Fade / Swipe etc.",
      "audio_cue": "Music beat drop / Soft intro / Sound effect description"
    }
  ],
  "voiceover_script": "Full voiceover narration (if requested, otherwise empty string)",
  "caption_sequence": ["Array of on-screen caption texts in order (if captions enabled, otherwise empty array)"],
  "music_recommendation": "Specific music style/mood suggestion with tempo",
  "hashtags": ["5-8 relevant hashtags"],
  "posting_tips": "Brief platform-specific tips for maximum reach",
  "estimated_engagement": "Brief note on expected performance"
}

IMPORTANT:
- Make scenes detailed enough for a video editor to produce without further input
- Keep total duration realistic for ${reelDuration || "30 seconds"}
- Use ${scriptLanguage || "English"} for all text content
- Make it engaging, viral-worthy, and specific to education marketing
- Only return valid JSON, no markdown or extra text`;

    const geminiRes = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts: [{ text: geminiPrompt }] }],
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

    let script;
    try {
      script = JSON.parse(text);
    } catch {
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        try {
          script = JSON.parse(jsonMatch[0]);
        } catch {
          script = { raw_text: text };
        }
      } else {
        script = { raw_text: text };
      }
    }

    supabaseAdmin.from("usage_logs").insert({
      user_id: user.id,
      feature: "text",
    }).then(() =>
      supabaseAdmin.rpc("increment_counter", {
        row_id: user.id,
        column_name: "total_videos",
      })
    ).catch(() => {});

    return new Response(JSON.stringify({ script }), {
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
