-- 뚠뚠팀 v36.32
-- 혈맹원 삭제 시 RLS DELETE 권한 오류 수정
-- 로그인은 Supabase Anonymous Auth를 사용하므로 authenticated 세션을 기준으로 합니다.

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

-- 기존 DELETE 정책이 있으면 교체
 drop policy if exists "clan_members_delete_manager" on public.clan_members;
drop policy if exists "clan_members_delete_authenticated" on public.clan_members;

create policy "clan_members_delete_manager"
on public.clan_members
for delete
to authenticated
using (public.ddunteam_can_manage_clan(clan_id));

-- DELETE 권한 부여
 grant delete on table public.clan_members to authenticated;

-- v36.31의 delete().select('id')가 삭제 결과를 반환하려면 SELECT 권한도 필요합니다.
grant select on table public.clan_members to authenticated;
