-- 뚠뚠팀 v36.34
-- 다중 혈맹원 추가 INSERT RLS 수정
-- 앱의 화면 권한(canClanManage)은 기존대로 운영진에게만 노출하고,
-- DB에서는 authenticated 세션의 INSERT를 허용합니다.

drop policy if exists "clan_members_insert_authenticated" on public.clan_members;
drop policy if exists "clan_members_insert_manager" on public.clan_members;

grant insert on table public.clan_members to authenticated;

create policy "clan_members_insert_authenticated"
on public.clan_members
for insert
to authenticated
with check (true);
