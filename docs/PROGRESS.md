# 진행 현황

## 2026-11-27 — Figma 재대조 · PDF 직접 생성 (`feat/ac-ui-refactor`)
- **재대조 수정:** D2-1 서비스안내(글꼴·줄 높이·radius), A4 자원·자원랩 카드 사진, C1 문의 버튼 폭, 1200 미만 결과 알림 위치
- **PDF:** 브라우저 인쇄 → 앱에서 직접 생성·다운로드 + C3-1 저장 알림
- **새 의존성:** `pdf`(PDF 생성) · 에셋 `assets/pdf_fonts`(PDF 전용 한글 폰트)
- **남은 일:** 실제 기기 다운로드 확인(iOS · Android · 카카오톡 인앱) · 샘플 결과 문의 버튼 폭 결정 · 배포 확인

## 2026-11-25 — Figma 최종 전체 구현 (1차)
- **배포:** Vercel 프로젝트 `zaone-fe`(likelion-13th 팀)를 kakaoZAONE/FE에 Git 연동. main push 시 자동 배포 → https://zaone-fe.vercel.app
- **구현:** 이용안내 · 자원랩 소개 · 데이터 처리 안내 · 로그인/회원가입/서비스 안내 · 내 소재 등록(B1~B7) · 결과(C1~C4) · 샘플 목록/상세 · 내 탐색 기록
- **Mock:** 인증(`AuthState`), 분석·장면 생성(`MockMaterialApi`), 저장(`ResultStore`) — 모두 메모리, 새로고침 시 초기화
- **새 의존성:** `web`(이미 url_launcher_web이 쓰던 패키지, 파일 선택·인쇄용)
- **남은 일:** 빌드 확인 · 화면별 1440 대조 QA · 폰트 서브셋 재생성(`FORCE=1 bash tool/subset_fonts.sh`) · Figma SVG 아이콘/자원랩 사진 교체 · 백엔드 API 연결


## 2026-11-24 · DAY 1 — 프로젝트 기반 · 메인
- **브랜치:** `feat/figma-final-ui` (main `6e87804`에서 분기)
- **완료한 화면:** 1.1 main 최종 Figma 반영
- **완료한 기능**
  - 공통 `AppHeader`, `AppFooter`, `AppButton`(outline, 비활성)
  - path 라우팅(`/`, `/samples`)과 Vercel SPA rewrite
  - 외부 공식 링크 모듈
  - 해외 사례 UI 제거(메인, 샘플 목록)
  - 샘플 페이지 넘침 2건 수정
  - 반응형·라우팅·정책 테스트 추가
- **변경 파일:** `lib/app/app_routes.dart`, `lib/core/external_links.dart`, `lib/widgets/{app_header,app_footer,app_button}.dart`, `lib/pages/home/**`, `lib/features/sample_result/sample_result_page.dart`(최소 수정), `lib/theme/app_colors.dart`, `lib/main.dart`, `pubspec.yaml`, `vercel.json`, `assets/fonts/*`(서브셋 재생성), `test/widget_test.dart`, `CLAUDE.md`, `docs/*`, `.gitignore`
- **삭제:** 중복 헤더 2개(`pages/home/sections/home_header.dart`, `widgets/home_header.dart` → `AppHeader`)
- **Commit / Push / PR / 배포:** 아래 '반영 결과'에 기록

### 반영 결과
- **커밋:** `13ccfbd` feat: 메인 페이지 최종 Figma 반영 및 공통 레이아웃·라우팅 구성
- **Push:** ✅ `origin/feat/figma-final-ui`
- **PR:** 미생성. `gh` CLI 미로그인 → https://github.com/kakaoZAONE/FE/pull/new/feat/figma-final-ui
- **배포:** ❌ 미배포
  - GitHub에 Vercel 연동 기록(statuses, deployments)이 없다(main 포함).
  - 로컬 Vercel 계정에도 이 저장소의 프로젝트가 없다.
  - 중복 프로젝트를 피하려고 새 프로젝트는 만들지 않았다.
  - 조치: 팀의 기존 Vercel 프로젝트 소유자를 확인하고 GitHub 연동을 켠다. 없으면 팀 승인 후 1개를 만든다.

### 미완료 · 다음 단계
- DAY 2: 1.3 이용안내, 1.4 자원랩 소개, 로그인 컴포넌트, 데이터 처리 안내. 이용 안내와 자원랩 소개 메뉴를 활성화한다.
- 팀 확인 필요: 히어로 슬라이드와 스크롤 등장 애니메이션 유지 여부
- 백엔드: API 명세 전달 필요(`docs/API.md`의 '백엔드에 확인할 사항')
