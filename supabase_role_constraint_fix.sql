-- v36.28: clan_members.role 에 '관리자'를 허용
-- 현재 앱에서 사용하는 실제 저장값: 군주 / 관리자 / 수호 / 일반

ALTER TABLE public.clan_members
  DROP CONSTRAINT IF EXISTS clan_members_role_check;

ALTER TABLE public.clan_members
  ADD CONSTRAINT clan_members_role_check
  CHECK (role IN ('군주', '관리자', '수호', '일반'));

-- 이미 로그인된 사용자(anonymous 포함)가 혈맹원 역할을 변경할 수 있도록 유지
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.clan_members TO authenticated;
