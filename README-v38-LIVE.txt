뚠뚠팀 v38 LIVE 배포 안내

이번 버전의 핵심은 '브라우저 localStorage만 믿던 데이터'를 Supabase에 영구 저장하는 것입니다.
기존 데이터는 삭제하지 않습니다.

1. Supabase SQL Editor
- supabase_v38_LIVE_ALL.sql 전체를 붙여넣고 Run
- Results가 Success. No rows returned이면 정상
- 이 SQL은 기존 테이블을 DROP하지 않습니다.

2. GitHub
- ZIP 안의 index.html로 기존 index.html 교체
- main 브랜치에 커밋

3. Vercel
- 자동 배포 완료 후 production에서 확인
- 브라우저 Ctrl+F5

4. 첫 접속 시 자동 마이그레이션
- 기존 localStorage에 남아 있는 마음의 편지 / 보유 혈맹 / 인원 관리 / 아이템 / 메모 데이터를 발견하면 Supabase로 자동 이관합니다.
- Supabase에 이미 데이터가 있으면 그것을 우선하며 덮어쓰지 않습니다.

5. 이번 버전 수정
- 캘린더 메인 화면 일정 미리보기 제거, 공휴일만 표시
- 관리자 옆 ✎ 수정 버튼과 관리자 버튼 동시 표시 복구(베키)
- 마음의 편지 서버 영구 저장. 본문은 운영진만 조회하도록 DB RLS 분리
- 보유 혈맹 리스트 서버 영구 저장
- 뚠뚠 메모장 운영 메모/혈비/시간 분류 영구 저장
- 분배금 지급 상태는 기존 clan_distribution_payments에 유지
- 인원 관리/아이템 데이터도 서버 상태 테이블로 저장
- 혈맹원 목록/인원 관리 정렬 기준 통일: 등급 → 레벨 내림차순 → 랭킹 → 닉네임
- 상단 메뉴 canonical order 복구
- 분배금 UI overflow 방지

주의
- SQL 실행 전에 기존 데이터를 삭제하는 SQL을 추가로 실행하지 마세요.
- 배포 후에도 문제가 있으면 화면의 정확한 오류 문구를 보내주세요. 이번 버전은 데이터 삭제/초기화가 없도록 설계했습니다.
