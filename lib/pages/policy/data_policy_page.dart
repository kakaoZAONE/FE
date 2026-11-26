import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../widgets/app_header.dart';
import '../../widgets/design_width.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';
import 'widgets/policy_widgets.dart';

/// Figma `A5 이용 및 데이터 처리 안내 · 공개` (982:5234)
///
/// Figma는 모든 요소가 절대 좌표라서, 세로 간격은 '다음 요소 top - 이 요소 top'
/// 높이의 칸([PolicySlot])과 Figma 상자 높이로 맞췄다. (1440 기준 y값은 주석 참고)
class DataPolicyPage extends StatelessWidget {
  const DataPolicyPage({super.key});

  static const _summary = [
    '샘플·분석·PDF는 로그인 없이',
    '외부 AI 분석 시작 전 동의',
    'AI 이미지는 안전성 검증이 아님',
  ];

  static const _policyCards = [
    (
      '로그인 전 이용할 수 있는 기능',
      '소재 샘플 둘러보기 · 내 사진 등록 · 소재 정보 입력 · AI 분석 확인 · 탐색/변형/조합 결과 보기 · PDF로 받기',
    ),
    ('로그인이 필요한 기능', '사용자 계정에 결과를 저장하거나, 이전에 저장한 탐색 기록을 다시 보려는 경우 인증이 필요합니다.'),
    (
      'AI 분석과 놀이 제안의 성격',
      '사진 기반 특징은 추정될 수 있습니다. 가상 놀이 장면은 실제 실험·위생·안전성 검증이나 소재 제공 승인을 의미하지 않습니다.',
    ),
    ('자원랩 협의의 범위', '실제 소재 제공과 교육 활용 여부는 자원도감 결과와 별개로 자원랩의 공식 연락·검토 과정을 거칩니다.'),
  ];

  static const _dataRows = [
    ('동의 시점', '외부 AI 분석 시작 전 사용자가 필수 동의 내용을 확인합니다.'),
    ('전송되는 정보', '사용자가 등록한 소재 사진과 입력한 소재 정보입니다.'),
    ('이용 목적', '소재의 형태·특성 해석, 놀이 아이디어 및 장면 이미지 생성입니다.'),
    ('업로드 주의', '회사 기밀, 개인 얼굴·연락처, 제3자의 개인정보는 사진에 포함하지 마세요.'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final isDesktop = size == ScreenSize.desktop;
    final isMobile = size == ScreenSize.mobile;
    final padH = Responsive.value<double>(
      context,
      desktop: 80,
      tablet: 40,
      mobile: 20,
    );
    final sectionTitle = PolicyStyle.noto(
      isMobile ? 26 : 36,
      weight: FontWeight.w700,
    );

    // 152 브레드크럼 → 214 제목 → 349 설명 → 411 구분선
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PolicySlot(
          height: isMobile ? 40 : 62,
          child: Text(
            'SERVICE & DATA  /  이용 안내',
            style: PolicyStyle.noto(17, weight: FontWeight.w700),
          ),
        ),
        PolicySlot(
          height: isMobile ? 0 : 135,
          child: Text(
            '사진과 AI 데이터를\n어떻게 다루나요?',
            style: PolicyStyle.noto(
              isMobile ? 32 : 47,
              weight: FontWeight.w700,
              color: PolicyStyle.ink,
            ),
          ),
        ),
        if (isMobile) const SizedBox(height: 12),
        PolicySlot(
          height: isDesktop ? 62 : 0,
          child: Text(
            '입력할 정보와 AI 결과의 한계를 미리 살펴보세요.\n'
            '분석을 시작하기 전에는 외부 AI 전송에 대한 동의를 받습니다.',
            style: PolicyStyle.noto(
              isMobile ? 16 : 19,
              color: PolicyStyle.subtle,
            ),
          ),
        ),
      ],
    );

    return PageScaffold(
      // CTA 아래 ~ 푸터: 1857 - 1793 = 64
      bottomGap: 64,
      body: DesignWidth(
        child: Padding(
          // 헤더(111) 아래 41 → 브레드크럼 top 152
          padding: EdgeInsets.fromLTRB(padH, 41, padH, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: intro),
                    const SizedBox(width: 24),
                    // 요약 상자 top 158 (= 152 + 6), left 867, 폭 493
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: SizedBox(
                        width: 493,
                        child: PolicySummary(items: _summary),
                      ),
                    ),
                  ],
                )
              else ...[
                intro,
                const SizedBox(height: 24),
                const PolicySummary(items: _summary),
                const SizedBox(height: 30),
              ],
              // 411 구분선 → 454 안내 상자
              const Divider(
                height: 1,
                thickness: 1,
                color: PolicyStyle.summaryRule,
              ),
              const SizedBox(height: 42),
              const PolicyNotice(
                title: '운영 정책 확인 필요',
                body:
                    '현재 화면은 UX 기능 설명입니다. 정식 이용약관·개인정보처리방침과 AI 공급자·보관 기간은 '
                    '운영 주체 검토 후 별도로 확정·게시해야 합니다.',
              ),
              // 573 → 645 섹션 제목 → 721 카드
              const SizedBox(height: 72),
              PolicySlot(
                height: isMobile ? 0 : 76,
                child: Text('01  서비스 이용 기준', style: sectionTitle),
              ),
              if (isMobile) const SizedBox(height: 20),
              ResponsiveGrid(
                columns: isMobile ? 1 : 2,
                gap: 36,
                runGap: 31,
                children: [
                  for (final c in _policyCards)
                    PolicyCard(title: c.$1, body: c.$2),
                ],
              ),
              // 1138 → 1245 섹션 제목 → 1329 표
              const SizedBox(height: 107),
              PolicySlot(
                height: isMobile ? 0 : 84,
                child: Text('02  외부 AI 처리 및 사진 주의사항', style: sectionTitle),
              ),
              if (isMobile) const SizedBox(height: 20),
              PolicyDataTable(rows: _dataRows, stacked: isMobile),
              // 1603 → 1667 안내 → 1735 버튼
              const SizedBox(height: 64),
              PolicySlot(
                height: isMobile ? 0 : 68,
                child: Text(
                  '기능 이용방법과 샘플 결과를 확인한 다음 소재 사진을 등록해 보세요.',
                  style: PolicyStyle.noto(
                    isMobile ? 16 : 19,
                    color: PolicyStyle.muted,
                  ),
                ),
              ),
              if (isMobile) const SizedBox(height: 15),
              Wrap(
                spacing: 21,
                runSpacing: 12,
                children: [
                  PolicyCta(
                    label: '이용방법 보기',
                    width: 238,
                    onTap: () => AppHeader.goTo(context, AppRoutes.guide),
                  ),
                  PolicyCta(
                    label: '내 소재 등록하기',
                    width: 267,
                    onTap: () => AppHeader.goTo(context, AppRoutes.register),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
