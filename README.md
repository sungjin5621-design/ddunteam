# 뚠뚠팀 v36.26 — Supabase 혈맹원 저장 권한 수정

이번 문제는 프론트엔드가 아니라 Supabase `clan_members` 테이블의 UPDATE RLS 정책이 없는/부족한 상태에서 발생했습니다.

## 반드시 1회 실행
Supabase Dashboard → SQL Editor에서 `supabase_permission_fix.sql` 전체를 실행하세요.

실행 후 새로고침하면 페이지 소유자/군주/관리자/수호가 혈맹원 레벨·웨폰·등급 등을 저장할 수 있습니다.

닉네임은 프론트엔드에서 페이지 소유자(베키)만 수정할 수 있도록 유지됩니다.
