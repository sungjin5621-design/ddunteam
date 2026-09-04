# 뚠뚠팀 v36.27

혈맹원 정보 저장 시 Supabase `UPDATE` RLS 권한 오류를 해결한 버전입니다.

## 중요
`supabase_permission_fix.sql`은 GitHub에 올리는 것만으로 실행되지 않습니다.
Supabase Dashboard → SQL Editor에서 파일 내용을 한 번 실행해야 합니다.

이 SQL은 `authenticated`(Supabase Anonymous Auth 포함) 세션의 `clan_members` UPDATE를 허용합니다.
