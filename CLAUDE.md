# 자원도감 FE — 개발 지침

## 프로젝트
- 자원도감 (팀 ZAONE · 2026 카카오 테크포임팩트 · 협력: 자원랩).
- 기업의 휴면자원 사진과 정보를 입력하면 AI가 소재 특성을 분석하고 **탐색·변형·조합** 세 방향의 놀이 활용 가능성을 제안한다.
- 결과는 탐색용 제안일 뿐이며, 안전성이나 실제 활용 가능성을 검증했다는 뜻이 아니다.

## 기술 스택
- Flutter Web 우선. 다른 프레임워크로 전환하지 않는다. Android/iOS 설정은 필요할 때만 수정한다.
- 패키지: `url_launcher`, `flutter_web_plugins`(SDK). 새 패키지는 꼭 필요할 때만 추가한다.
- 폰트: Pretendard, SUITE, NotoSansKR. `lib/`에 쓰인 글자만 남긴 **서브셋**이므로, 새 문구를 추가하면 `FORCE=1 bash tool/subset_fonts.sh`를 실행한다.
- 라우팅: `lib/app/app_routes.dart`(path URL, `usePathUrlStrategy`). 새 화면을 만들면 경로를 여기에 추가한다.

## 구조
- `lib/app` 라우팅 · `lib/core` 외부 링크 등 공통 로직 · `lib/theme` 색상/글꼴 토큰
- `lib/widgets` 공통 위젯: `AppHeader`, `AppFooter`, `AppButton`, `Responsive`, `DesignWidth`
- `lib/pages/home` 메인 · `lib/features/<기능>` 기능별 화면

## Figma 구현 원칙
- 최종 디자인은 UI 페이지의 '최종' 프레임 아래 화면이다. Node ID는 `docs/FIGMA.md`에 있다.
- 1440 데스크톱 디자인을 정확히 재현하고, 390~1920 폭까지 넘침 없이 표시한다.
- 임의의 그라데이션, 그림자, 라운드, 애니메이션, 이모지, 문구, 배지를 추가하지 않는다.
- 에셋은 먼저 `assets/images`에서 찾는다. Figma 임시 URL은 런타임에 쓰지 않는다.
- 기능이 아직 없는 버튼과 링크는 `onPressed/onTap: null`로 둔다. 모양은 유지하되 클릭할 수 없게 한다.

## 확정 정책
- **해외 실제 활용 사례 UI, 문구, 데이터를 제공하지 않는다.** 내부 수집 데이터도 번들과 저장소에 넣지 않는다.
- 공개 페이지와 샘플은 로그인 없이 이용할 수 있다. 게스트 세션은 내부 기능이라 관리 화면을 만들지 않는다.
- PDF는 프론트엔드에서 생성한다. 문의는 공식 경로(`ExternalLinks`)로만 하고, 완료를 허위로 표시하지 않는다.
- 사용자가 입력한 정보와 AI가 추정한 정보를 구분해서 표시한다.

## API
- 명세와 ERD를 기준으로 한다. 확정되지 않은 API를 실제 API처럼 구현하지 않는다.
- Mock과 실제 연동 계층을 분리하고 `docs/API.md`에 기록한다. Base URL은 `--dart-define`으로 환경별로 관리한다.

## Git / 배포
- 작업 브랜치는 `feat/figma-final-ui`이다. main에 직접 push, force push, reset --hard, 브랜치 삭제는 승인 없이 하지 않는다.
- 커밋은 Conventional Commits(한국어)로 작성한다. **AI 도구 서명, Co-Authored-By, "Generated with" 문구는 넣지 않는다.**
- 작업 종료 전 순서: `dart format lib test` → `flutter analyze` → `flutter test` → `flutter build web` → commit → push → 배포 확인 → `docs/PROGRESS.md` 갱신.
- Vercel: `vercel.json` + `tool/vercel_build.sh`, 출력은 `build/web`이다. SPA rewrite로 새로고침을 지원한다. 별도 프로젝트를 새로 만들지 않는다.

## 비공개
- 내부 링크(Figma/ERD URL 등)는 `docs/internal/`(git 제외)에 둔다. 토큰과 `.env`는 커밋하지 않는다.
