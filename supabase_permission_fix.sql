-- 뚠뚠팀 v36.26
-- 혈맹원 수정(레벨/웨폰/등급 등)을 막고 있던 clan_members UPDATE RLS 정책 수정
-- 로그인은 Supabase Anonymous Auth를 사용하므로 authenticated 세션 기준으로 검사합니다.

create or replace function public.ddunteam_can_manage_clan(p_clan_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.clan_members cm
    where cm.clan_id = p_clan_id
      and cm.user_id = auth.uid()
      and cm.role in ('군주','관리자','수호')
  )
  or exists (
    select 1
    from public.clans c
    where c.id = p_clan_id
      and c.owner_user_id = auth.uid()
  );
$$;

revoke all on function public.ddunteam_can_manage_clan(uuid) from public;
grant execute on function public.ddunteam_can_manage_clan(uuid) to authenticated;

-- 기존 정책과 이름이 충돌해도 실행할 수 있도록 제거 후 재생성
 drop policy if exists "clan_members_update_manager" on public.clan_members;

create policy "clan_members_update_manager"
on public.clan_members
for update
to authenticated
using (public.ddunteam_can_manage_clan(clan_id))
with check (public.ddunteam_can_manage_clan(clan_id));

-- SELECT 정책이 이미 있다면 그대로 사용합니다.
-- v36.25의 .update(...).select('*')가 정상 동작하려면 UPDATE 후 SELECT가 허용되어 있어야 합니다.
-- 기존 SELECT 정책이 없다면 아래 정책을 추가하세요.
-- (일반적으로 현재 대시보드에서 목록 조회가 되고 있으므로 중복 생성은 하지 않습니다.)
