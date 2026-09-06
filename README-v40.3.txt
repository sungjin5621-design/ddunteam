뚠뚠팀 v40.3 FINAL

핵심 수정
- 뚠뚠 메모장 분배금 UI가 기존 showPage 라우팅에서 새 렌더러를 직접 호출하도록 수정.
- 랭킹순/기본순/레벨순/가나다순 정렬
- 전체/미지급/지급완료 필터
- 지급완료/미지급 상태
- 개인 특이사항 메모
- 기존 분배금 DB 구조 유지
- 오늘 일정의 participants JSON 표시 제거(기존 renderToday 유지)

배포
1. index.html을 GitHub의 기존 index.html과 통째로 교체
2. main 커밋
3. Vercel 배포 완료 확인
4. Ctrl+F5

주의: Supabase SQL 재실행 불필요. 기존 데이터 삭제/초기화 없음.
배포 후 뚠뚠 메모장 제목 옆에 v40.3 표시가 보여야 이 파일이 실제 서비스에 반영된 것이다.
