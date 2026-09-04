# 뚠뚠팀 v36.34 다중 추가 수정

## 수정 내용
- 다중 추가에서 닉네임/레벨 입력 후 웨폰 선택 시 입력값이 초기화되는 문제 수정
- 웨폰 선택 후 `＋ 행 추가` 버튼이 먹통이 되는 문제 수정
- 여러 행의 입력값을 유지하면서 웨폰 선택 가능
- 다중 추가 저장 후 최신 혈맹원 목록을 즉시 다시 불러옴
- 기존 권한/정렬/삭제 기능은 유지

## Supabase
`supabase_bulk_insert_policy_fix.sql`을 Supabase SQL Editor에서 1회 실행하세요.
현재 로그인 구조가 Supabase Anonymous Auth를 사용하므로 authenticated 세션에 INSERT 권한이 필요합니다.
앱 화면에서는 기존 `canClanManage()`로 운영진만 다중 추가 UI를 사용할 수 있습니다.
