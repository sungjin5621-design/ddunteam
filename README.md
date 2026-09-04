# 뚠뚠팀 혈맹 운영 — 공유 웹앱 v1

기존 뚠뚠팀 UI를 유지하면서 **Supabase Auth + Postgres + Storage + Realtime**을 연결한 공유형 웹앱 배포 패키지입니다.

## 폴더
- `index.html` — 기존 UI + 공유 백엔드 어댑터
- `config.js` — Supabase URL / Publishable Key 입력
- `supabase/schema.sql` — DB 테이블, RLS, Storage, 초기 혈맹 데이터
- `vercel.json` — 정적 배포 설정
- `seed.json` — 현재 UI의 초기 혈맹원/공지/일정 데이터 참고용

## 1. Supabase 프로젝트 만들기
Supabase에서 새 프로젝트를 만든 후 SQL Editor에 `supabase/schema.sql` 전체를 붙여넣어 실행합니다.

그 다음 Authentication 설정에서 **Anonymous Sign-Ins**를 켭니다.

## 2. 소유자 등록 코드 변경
`schema.sql`의 다음 값은 반드시 원하는 1회용 코드로 바꾸세요.

`CHANGE-ME-BEFORE-DEPLOY`

실행을 이미 했다면 SQL Editor에서:

```sql
update private.clan_secrets
set owner_code = '원하는-긴-랜덤-코드'
where clan_id = 'ddunteam';
```

## 3. 프론트 연결
`config.js`에 Supabase Project URL과 Publishable Key를 입력합니다.

Publishable key는 브라우저에 노출해도 되지만, **service_role/secret key는 절대 넣으면 안 됩니다.** 데이터 보호는 RLS로 처리합니다.

## 4. 최초 소유자 등록
배포한 페이지를 베키가 처음 열면 익명 계정이 자동 생성됩니다.

좌측 현재 접속 닉네임 영역의 **소유자 등록** 버튼을 누르고 2번에서 설정한 소유자 코드를 입력합니다.

성공하면 해당 브라우저 계정이 페이지 소유자가 되고 `베키` 혈맹원과 연결됩니다.

## 5. 혈맹원 사용
다른 혈맹원은 같은 URL을 열면 별도의 익명 계정을 받습니다.

좌측에서 본인 닉네임을 설정하면 DB에서 해당 혈맹원 닉네임을 점유합니다. 이미 다른 사용자가 점유한 닉네임은 사용할 수 없습니다.

## 6. Vercel 배포
이 폴더 전체를 GitHub 저장소에 올린 뒤 Vercel에서 해당 저장소를 Import하면 됩니다. 별도 빌드 명령은 필요 없습니다.

또는 Vercel CLI를 사용한다면 프로젝트 폴더에서:

```bash
npx vercel
```

## 중요한 제한
현재 기본 로그인은 Supabase Anonymous Sign-In입니다. 이 방식은 이메일/비밀번호 없이 사용자별 ID를 만들기 때문에 공유 링크를 쓰기 편하지만, 브라우저 데이터를 지우거나 다른 기기로 바꾸면 같은 익명 계정을 되찾을 수 없습니다.

장기적으로 운영할 경우 Google 로그인이나 이메일 로그인으로 계정을 연결하는 것을 권장합니다.

## 동기화
공지, 일정, 혈맹원, 서버, 혈맹 남긴말, 카테고리 순서 등은 Supabase DB에 저장됩니다. Realtime 구독도 연결되어 다른 운영진의 변경이 다른 브라우저에 반영되도록 구성했습니다.
