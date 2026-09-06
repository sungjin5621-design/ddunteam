뚠뚠팀 운영 대시보드 v40.8 MEMO DIST FIX

배포:
1. 기존 index.html을 이 폴더의 index.html로 교체
2. Vercel 재배포
3. 브라우저에서 Ctrl+Shift+R

핵심 수정:
- 뚠뚠 메모장 클릭 시 분배금 관리 화면을 직접 렌더링
- 기존 showPage 중첩 래퍼를 거치지 않아 빈 화면 방지
- legacy items 경로도 뚠뚠 메모장으로 연결
