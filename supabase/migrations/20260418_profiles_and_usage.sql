-- ============================================
-- Service-role access for Edge Functions
-- (profiles & subscriptions already have user-facing RLS)
-- ============================================
-- Allow Edge Functions (service_role) to read subscriptions for tier checks
grant select on public.subscriptions to service_role;
grant update on public.subscriptions to service_role;

-- Atomic counter increment for subscriptions stats
create or replace function public.increment_counter(row_id uuid, column_name text)
returns void as $$
begin
  execute format(
    'update public.subscriptions set %I = %I + 1, updated_at = now() where id = $1',
    column_name, column_name
  ) using row_id;
end;
$$ language plpgsql security definer;

-- ============================================
-- usage_logs table (profiles & subscriptions already exist)
-- ============================================
create table if not exists public.usage_logs (
  id         bigint generated always as identity primary key,
  user_id    uuid not null references auth.users(id) on delete cascade,
  feature    text not null check (feature in ('text', 'image', 'video')),
  created_at timestamptz not null default now()
);

create index idx_usage_logs_user_feature_date
  on public.usage_logs (user_id, feature, created_at);

alter table public.usage_logs enable row level security;

create policy "Users can read own usage"
  on public.usage_logs for select
  using (auth.uid() = user_id);

create policy "Service role can insert usage"
  on public.usage_logs for insert
  with check (true);

grant insert on public.usage_logs to service_role;
