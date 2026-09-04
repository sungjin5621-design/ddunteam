-- 뚠뚠팀 일정 저장 권한 수정
-- Supabase SQL Editor에서 1회 실행하세요.
-- 현재 앱은 로그인된 authenticated 세션을 사용하며, 화면에서 일정 관리 권한을 검사합니다.

grant insert, update on table public.clan_schedules to authenticated;

drop policy if exists "clan_schedules_insert_authenticated" on public.clan_schedules;
drop policy if exists "clan_schedules_update_authenticated" on public.clan_schedules;

create policy "clan_schedules_insert_authenticated"
on public.clan_schedules
for insert
to authenticated
with check (true);

create policy "clan_schedules_update_authenticated"
on public.clan_schedules
for update
to authenticated
using (true)
with check (true);
