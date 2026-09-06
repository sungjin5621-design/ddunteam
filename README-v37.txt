뚠뚠팀 운영 대시보드 v37.0

포함 파일
- index.html : 배포용 단일 페이지
- supabase_distribution_v37.sql : 분배금 상태/특이사항/메모를 Supabase에 저장하기 위한 1회 SQL

v37.0 반영
- 분배금 관리 목록을 혈맹원 정렬 기준에 맞춰 레벨 우선으로 표시
- 지급완료/미지급 상태 표시 및 지급/취소 버튼
- 혈맹원별 분배금 특이사항 메모 버튼
- 지급 여부, 지급 시각, 지급한 사람, 금액, 시간 분류, 특이사항을 DB에 저장
- 혈비/운영 메모도 DB에 저장하고 기존 localStorage 데이터가 있으면 최초 저장 시 함께 반영
- 오늘 일정에서 participants JSON 같은 내부 데이터가 화면에 노출되지 않도록 수정
- 일정 저장 후 실제 DB 반영을 확인하고 cloudRefresh 완료 후 즉시 UI 갱신
- Supabase Realtime으로 일정/분배금 변경을 수신하도록 추가

배포 순서
1. Supabase SQL Editor에서 supabase_distribution_v37.sql 전체 실행
2. index.html을 기존 GitHub 배포 파일과 교체
3. GitHub main 반영 후 Vercel 자동 배포 확인

주의
- SQL을 먼저 실행하지 않아도 기존 기능은 가능한 범위에서 유지되지만, v37 분배금 DB 저장 기능은 SQL 실행 후 정상 동작합니다.
