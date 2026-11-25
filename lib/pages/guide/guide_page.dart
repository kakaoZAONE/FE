import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/design_width.dart';
import '../../widgets/login_dialog.dart';
import '../../widgets/notch_banner.dart';
import '../../widgets/number_tag.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';
import '../home/sections/section_heading.dart';

/// Figma `A3 이용안내` (989:6733)
///
/// 이용 단계 6개 → AI 안내 → 자주 묻는 질문 → 로그인 배너
class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  static const _steps = [
    (
      '01',
      '샘플로 자원도감 이해하기',
      '이미 확인된 소재 4종의 놀이 결과를 탐색하며\n자원도감을 통해 내 소재의 놀이가능성을 확인해보세요.',
    ),
    ('02', '내 소재 사진 등록하기', '소재의 전체와 표면이 보이는 사진부터 등록하여\nAI가 추정할 수 있도록 합니다.'),
    (
      '03',
      '알고 있는 정보만 입력하기',
      '재질·형태·발생 공정 등 확인된 정보만 선택적으로 적어주세요.\n그 후 자유롭게 수정하며 재탐색할 수 있어요!',
    ),
    ('04', 'AI 해석 확인하고 수정하기', '사진에서 파악한 외형 특징을 검토하고\n\n'),
    ('05', '놀이 제안 3가지 살펴보기', '내 소재의 탐색·변형·조합 장면을 \n자원도감을 통해 확인해보세요! '),
    ('06', '필요한 결과만 활용하기', 'PDF로 받거나 저장하고 \n자원랩에 바로 문의해보세요.'),
  ];

  static const _faqs = [
    (
      'Q. 로그인은 언제 필요한가요?',
      'A. 샘플 탐색과 결과 열람, PDF 확인은 로그인 없이 가능합니다.\n마음에 든 결과를 계정에 저장할 때만 로그인하세요.',
    ),
    (
      'Q. 소재 정보를 모두 알아야 하나요?',
      'A. 사진을 올리고 알고 있는 재질·형태·발생 정보를 추가하세요.\n확실하지 않은 물성이나 성분은 임의로 쓰지 않아도 됩니다.',
    ),
    (
      'Q. AI 놀이 장면은 실제 사용법인가요?',
      'A. 탐색·변형·조합은 AI가 제안한 가상의 놀이 예시입니다.\n안전성·위생·교육 적합성을 검증한 결과는 아닙니다.',
    ),
    (
      'Q. 실제 소재 제공은 어떻게 하나요?',
      'A. 자원도감에서 소재를 먼저 살펴보고,\n실제 제공 및 활용 협의는 자원랩을 통해 진행해 주세요.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final sectionPad = Responsive.value<double>(
      context,
      desktop: 60,
      tablet: 40,
      mobile: 20,
    );
    final columns = Responsive.value<int>(
      context,
      desktop: 3,
      tablet: 2,
      mobile: 1,
    );

    return PageScaffold(
      // 로그인 배너 아래 ~ 푸터: 2725 - 2448 = 277
      bottomGap: Responsive.value<double>(
        context,
        desktop: 277,
        tablet: 160,
        mobile: 80,
      ),
      body: DesignWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1) 이용 단계
            Padding(
              padding: EdgeInsets.all(sectionPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeading(
                    eyebrow: '자원도감은 어떻게 이용하나요?',
                    title: '부담없이 시작해보세요!',
                  ),
                  const SizedBox(height: 40),
                  _StepGrid(columns: columns, steps: _steps),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // 2) AI 장면 안내
            Padding(
              padding: EdgeInsets.all(sectionPad),
              child: const _AiNotice(),
            ),
            const SizedBox(height: 40),
            // 3) 자주 묻는 질문
            Padding(
              padding: EdgeInsets.all(sectionPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeading(eyebrow: 'Q&A', title: '자주 묻는 질문'),
                  for (final faq in _faqs) ...[
                    const SizedBox(height: 40),
                    _FaqRow(question: faq.$1, answer: faq.$2),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),
            // 4) 로그인 배너 (1320)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: pad),
              child: NotchBanner(
                eyebrow: 'Login',
                title: '결과는 저장할 때만 로그인하면 돼요',
                body:
                    '샘플 탐색, 소재 등록, AI 분석과 결과 열람은 로그인 없이 할 수 있습니다.\n'
                    '보관하고 싶은 결과가 생기면 로그인한 뒤 내 탐색 기록에 저장해 주세요.',
                action: AppButton(
                  label: '로그인 하러가기',
                  onPressed: () => showLoginDialog(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3개씩 한 줄, 줄마다 아래 보더 gray/500, 카드 사이 20
class _StepGrid extends StatelessWidget {
  const _StepGrid({required this.columns, required this.steps});

  final int columns;
  final List<(String, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < steps.length; start += columns) {
      final cells = <Widget>[];
      for (var i = 0; i < columns; i++) {
        if (i > 0) cells.add(const SizedBox(width: 20));
        final index = start + i;
        cells.add(
          Expanded(
            child: index < steps.length
                ? _StepCard(step: steps[index])
                : const SizedBox(),
          ),
        );
      }
      rows.add(
        DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.gray500)),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: cells,
            ),
          ),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step});

  final (String, String, String) step;

  @override
  Widget build(BuildContext context) {
    return LeftRuleCard(
      children: [
        NumberTag(step.$1),
        Text(step.$2, style: CardText.title24),
        Text(step.$3, style: CardText.body15),
      ],
    );
  }
}

/// 검정 안내 상자 — 좌우 30, 상하 60, radius 2, 간격 10
class _AiNotice extends StatelessWidget {
  const _AiNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      decoration: BoxDecoration(
        color: AppColors.gray900,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI가 만든 장면은 새로운 가능성을 상상하는 예시입니다.',
            style: AppTextStyles.title24.copyWith(color: AppColors.screen),
          ),
          const SizedBox(height: 10),
          Text(
            '생성 이미지로 소재의 강도·위생·안전성·교육 현장 적합성을 판단하지 않습니다. '
            '실제 제공과 활용은 자원랩과 별도로 협의합니다.',
            style: AppTextStyles.body15.copyWith(color: AppColors.screen),
          ),
        ],
      ),
    );
  }
}

/// 질문(흰 칸) + 답(검정 칸 639.5). 좁은 화면에서는 위아래로 쌓는다.
class _FaqRow extends StatelessWidget {
  const _FaqRow({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final stacked = Responsive.of(context) != ScreenSize.desktop;
    const border = BorderSide(color: AppColors.gray300);
    final q = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: AppColors.screen,
        border: Border(top: border, left: border, bottom: border),
      ),
      child: Text(question, style: AppTextStyles.title24),
    );
    final a = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: AppColors.gray900,
        border: Border(top: border, left: border),
      ),
      child: Text(
        answer,
        style: AppTextStyles.title24.copyWith(color: AppColors.screen),
      ),
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [q, a],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 6805, child: q),
          // 피그마 1320 중 639.5 — 비율로 유지
          Expanded(flex: 6395, child: a),
        ],
      ),
    );
  }
}
