-- 혈맹원별 현재 서버 저장
alter table public.clan_members
  add column if not exists current_server text;

-- 기존 혈맹원은 현재 메인 서버를 기본값으로 채움
update public.clan_members cm
set current_server = c.current_server
from public.clans c
where cm.clan_id = c.id::text
  and (cm.current_server is null or trim(cm.current_server) = '');

-- 신규 혈맹원 추가 시 메인 서버를 자동 기본값으로 사용
create or replace function public.set_clan_member_default_server()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.current_server is null or trim(new.current_server) = '' then
    select c.current_server into new.current_server
    from public.clans c
    where c.id::text = new.clan_id
    limit 1;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_clan_member_default_server on public.clan_members;
create trigger trg_clan_member_default_server
before insert on public.clan_members
for each row
execute function public.set_clan_member_default_server();
