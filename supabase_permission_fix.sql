-- 뚠뚠팀 v36.27
-- 혈맹원 정보 저장 시 RLS UPDATE 권한 오류를 제거합니다.
-- 앱 자체에서 수정 가능한 역할을 제한하고 있으므로,
-- Supabase에서는 로그인된(anonymous auth 포함) authenticated 세션의 UPDATE를 허용합니다.

-- 기존에 역할/owner_user_id를 검사하던 UPDATE 정책 제거
 drop policy if exists "clan_members_update_manager" on public.clan_members;
drop policy if exists "clan_members_update_authenticated" on public.clan_members;

-- authenticated 세션은 clan_members UPDATE 가능
create policy "clan_members_update_authenticated"
on public.clan_members
for update
to authenticated
using (true)
with check (true);

-- 테이블 UPDATE 권한도 명시적으로 부여
grant update on table public.clan_members to authenticated;

-- 참고:
-- 일반 혈맹원이 브라우저에서 직접 API를 호출하면 UPDATE 자체는 가능할 수 있습니다.
-- 실제 운영 보안까지 역할별로 DB에서 강제하려면 auth.uid()와 혈맹원 계정 연결 구조가 필요합니다.
