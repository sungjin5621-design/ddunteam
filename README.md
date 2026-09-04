# 뚠뚠팀 v36.28 역할 저장 수정

관리자로 역할을 변경할 때 발생하는 `clan_members_role_check` 오류를 수정합니다.

## 반드시 실행
Supabase SQL Editor에서 `supabase_role_constraint_fix.sql`을 한 번 실행하세요.

이 SQL은 `clan_members.role`에 `관리자`를 허용하도록 기존 CHECK 제약조건을 교체합니다.

`페이지 소유자`는 DB role 값으로 저장하지 않고 앱에서 닉네임 `베키`를 기준으로 표시합니다.
