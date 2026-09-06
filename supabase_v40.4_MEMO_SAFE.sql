-- ddunteam v40.4 memo add-on
-- Safe to run more than once. It never deletes existing distribution data.

create table if not exists public.clan_distribution_settings (
  clan_id text primary key,
  diamond numeric not null default 0,
  notes text not null default '',
  updated_at timestamptz not null default now(),
  updated_by_user_id uuid,
  updated_by_nickname text
);

create table if not exists public.clan_distribution_payments (
  id uuid primary key default gen_random_uuid(),
  clan_id text not null,
  member_id text not null,
  nickname text not null,
  amount numeric not null default 0,
  paid boolean not null default false,
  paid_at timestamptz,
  paid_by_user_id uuid,
  paid_by_nickname text,
  note text not null default '',
  time_class text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (clan_id, member_id)
);

alter table public.clan_distribution_settings
  add column if not exists diamond numeric not null default 0,
  add column if not exists notes text not null default '',
  add column if not exists updated_at timestamptz not null default now(),
  add column if not exists updated_by_user_id uuid,
  add column if not exists updated_by_nickname text;

alter table public.clan_distribution_payments
  add column if not exists amount numeric not null default 0,
  add column if not exists paid boolean not null default false,
  add column if not exists paid_at timestamptz,
  add column if not exists paid_by_user_id uuid,
  add column if not exists paid_by_nickname text,
  add column if not exists note text not null default '',
  add column if not exists time_class text not null default '',
  add column if not exists updated_at timestamptz not null default now();

alter table public.clan_distribution_settings enable row level security;
alter table public.clan_distribution_payments enable row level security;

do $$
begin
  create policy "ddunteam_distribution_settings_read" on public.clan_distribution_settings
    for select to anon, authenticated using (true);
exception when duplicate_object then null;
end $$;

do $$
begin
  create policy "ddunteam_distribution_settings_write" on public.clan_distribution_settings
    for all to anon, authenticated using (true) with check (true);
exception when duplicate_object then null;
end $$;

do $$
begin
  create policy "ddunteam_distribution_payments_read" on public.clan_distribution_payments
    for select to anon, authenticated using (true);
exception when duplicate_object then null;
end $$;

do $$
begin
  create policy "ddunteam_distribution_payments_write" on public.clan_distribution_payments
    for all to anon, authenticated using (true) with check (true);
exception when duplicate_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.clan_distribution_settings;
exception when duplicate_object then null; when undefined_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.clan_distribution_payments;
exception when duplicate_object then null; when undefined_object then null;
end $$;
