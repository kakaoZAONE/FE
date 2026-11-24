# 진행 현황

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
- (커밋 후 갱신)

### 미완료 · 다음 단계
- DAY 2: 1.3 이용안내, 1.4 자원랩 소개, 로그인 컴포넌트, 데이터 처리 안내. 이용 안내와 자원랩 소개 메뉴를 활성화한다.
- 팀 확인 필요: 히어로 슬라이드와 스크롤 등장 애니메이션 유지 여부
- 백엔드: API 명세 전달 필요(`docs/API.md`의 '백엔드에 확인할 사항')
