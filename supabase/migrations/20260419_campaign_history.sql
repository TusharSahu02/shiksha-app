-- Campaign history table (auto-deleted after 7 days)
CREATE TABLE IF NOT EXISTS public.campaign_history (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('text', 'image', 'video', 'print')),
  topic text NOT NULL,
  country text NOT NULL DEFAULT '',
  language text NOT NULL DEFAULT '',
  output jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_campaign_history_user_date
  ON public.campaign_history (user_id, created_at DESC);

ALTER TABLE public.campaign_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own history"
  ON public.campaign_history FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own history"
  ON public.campaign_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own history"
  ON public.campaign_history FOR DELETE
  USING (auth.uid() = user_id);

GRANT SELECT, INSERT, DELETE ON public.campaign_history TO authenticated;

-- Auto-cleanup: delete rows older than 7 days
-- Run this via pg_cron (enable the extension in Supabase Dashboard > Database > Extensions)
-- SELECT cron.schedule('cleanup-campaign-history', '0 3 * * *', $$DELETE FROM public.campaign_history WHERE created_at < now() - interval '7 days'$$);
