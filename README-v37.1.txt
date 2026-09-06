뚠뚠팀 v37.1 배포 안내

1) Supabase SQL Editor에서 supabase_distribution_v37_1_fix.sql 전체 실행
   - 분배금 설정/지급/특이사항 테이블 생성
   - authenticated 권한/RLS 설정
   - Realtime 등록
   - PostgREST schema cache reload

2) index.html을 GitHub main의 기존 index.html과 교체
3) Vercel 자동 배포 확인
4) 배포 후 Ctrl+F5

이번 수정:
- 분배금 특이사항 저장 시 'clan_distribution_payments schema cache' 오류 방지
- 기존 v37 SQL의 UUID FK 의존성을 제거하고 실제 앱의 text clan_id 구조에 맞춤
- 분배금 지급/메모 저장 오류 메시지 개선
- 상단 카테고리 순서를 한 번 canonical 순서로 교정:
  메인 → 마음의 편지 → 인원 관리 → 뚠뚠 메모장 → 보유 혈맹 리스트 → 아이템 분배 관리 → 잡지식 → 적 리스트
