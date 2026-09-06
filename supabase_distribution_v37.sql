-- v37.0: live distribution/payment status + notes + memo settings
-- Run once in Supabase SQL Editor before deploying index.html.

create table if not exists public.clan_distribution_settings (
  clan_id uuid primary key references public.clans(id) on delete cascade,
  diamond integer not null default 0,
  notes text not null default '',
  updated_at timestamptz not null default now(),
  updated_by_user_id uuid,
  updated_by_nickname text
);

create table if not exists public.clan_distribution_payments (
  id uuid primary key default gen_random_uuid(),
  clan_id uuid not null references public.clans(id) on delete cascade,
  member_id uuid references public.clan_members(id) on delete cascade,
  nickname text not null,
  amount integer not null default 0,
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

create index if not exists clan_distribution_payments_clan_idx
  on public.clan_distribution_payments(clan_id);

create index if not exists clan_distribution_payments_member_idx
  on public.clan_distribution_payments(member_id);

grant select, insert, update on public.clan_distribution_settings to authenticated;
grant select, insert, update on public.clan_distribution_payments to authenticated;

alter table public.clan_distribution_settings enable row level security;
alter table public.clan_distribution_payments enable row level security;

drop policy if exists "distribution_settings_select_manage" on public.clan_distribution_settings;
create policy "distribution_settings_select_manage"
on public.clan_distribution_settings for select to authenticated
using (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_settings.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
);

drop policy if exists "distribution_settings_insert_manage" on public.clan_distribution_settings;
create policy "distribution_settings_insert_manage"
on public.clan_distribution_settings for insert to authenticated
with check (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_settings.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
);

drop policy if exists "distribution_settings_update_manage" on public.clan_distribution_settings;
create policy "distribution_settings_update_manage"
on public.clan_distribution_settings for update to authenticated
using (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_settings.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
)
with check (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_settings.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
);

drop policy if exists "distribution_payments_select_manage" on public.clan_distribution_payments;
create policy "distribution_payments_select_manage"
on public.clan_distribution_payments for select to authenticated
using (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_payments.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
);

drop policy if exists "distribution_payments_insert_manage" on public.clan_distribution_payments;
create policy "distribution_payments_insert_manage"
on public.clan_distribution_payments for insert to authenticated
with check (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_payments.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
);

drop policy if exists "distribution_payments_update_manage" on public.clan_distribution_payments;
create policy "distribution_payments_update_manage"
on public.clan_distribution_payments for update to authenticated
using (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_payments.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
)
with check (
  exists (
    select 1 from public.clans c
    where c.id = clan_distribution_payments.clan_id
      and (
        c.owner_user_id = auth.uid()
        or exists (
          select 1 from public.clan_members m
          where m.clan_id = c.id and m.user_id = auth.uid() and m.role = '군주'
        )
      )
  )
);

-- Realtime publication. Safe to run if the tables are not already members.
do $$
begin
  alter publication supabase_realtime add table public.clan_distribution_settings;
exception when duplicate_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.clan_distribution_payments;
exception when duplicate_object then null;
end $$;
