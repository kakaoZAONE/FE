import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/flow_widgets.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/responsive.dart';
import '../result_models.dart';

/// 저장 안내 (Figma 851:1980) — 저장 전: error 테두리·글자 / 저장 후: 파랑
///
/// 1px 테두리, radius 2, 안쪽 10, 글자 15 Medium.
class ResultSaveNotice extends StatelessWidget {
  const ResultSaveNotice({super.key, required this.saved});

  final bool saved;

  /// C1-1 저장 후 안내 색 — Figma 변수 Main/Blue #0070F0 (851:2011)
  static const savedColor = Color(0xFF0070F0);

  @override
  Widget build(BuildContext context) {
    final color = saved ? savedColor : kErrorColor;
    return Container(
      // Figma 상자 높이 40 = 테두리 1 + 10 + 글 18 + 10 + 1 (테두리가 레이아웃에 포함)
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        saved
            ? '내 탐색 기록에 저장된 결과입니다. 같은 소재로 언제든 새 탐색을 시작할 수 있습니다.'
            : '아직 저장되지 않은 결과입니다. 저장하지 않으면 일정 시간이 지난 뒤 삭제됩니다. PDF로는 언제든 받아 둘 수 있습니다.',
        style: AppTextStyles.body15.copyWith(color: color),
      ),
    );
  }
}

/// 결과 머리 (Figma 787:14565) — 좌우 120 · 상하 60, 아래 보더 gray/500, 사이 38
///
/// 왼쪽 565(날짜 → 41 → 이름·발생처 → 41 → 상세보기 → 41 → 버튼),
/// 오른쪽 이미지 626 x 426.8 (1px gray/900 테두리).
class ResultHead extends StatelessWidget {
  const ResultHead({
    super.key,
    required this.result,
    required this.onReExplore,
    required this.onPdf,
    required this.onSave,
    required this.onContact,
    required this.onDetail,
    this.showReExplore = true,
  });

  final MaterialResult result;

  /// false면 '다시 탐색' 버튼을 숨긴다(샘플)
  final bool showReExplore;

  /// null이면 '다시 탐색'이 눌리지 않는다(장면을 다시 만드는 중)
  final VoidCallback? onReExplore;
  final VoidCallback onPdf;

  /// null이면 저장 버튼이 눌리지 않는다(저장 완료 · 저장 중)
  final VoidCallback? onSave;
  final VoidCallback onContact;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final padH = Responsive.value<double>(
      context,
      desktop: 120,
      tablet: 40,
      mobile: 20,
    );
    final sub = AppTextStyles.sectionSub.copyWith(fontSize: isMobile ? 16 : 22);

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          result.createdLabel,
          style: AppTextStyles.body13.copyWith(
            color: AppColors.gray600,
            letterSpacing: -0.65,
          ),
        ),
        const SizedBox(height: 41),
        Text(
          result.name,
          style: AppTextStyles.heroTitle.copyWith(
            color: AppColors.gray900,
            fontSize: isMobile ? 34 : 48,
          ),
        ),
        const SizedBox(height: 10),
        Text(result.source, style: sub),
        const SizedBox(height: 41),
        if (result.analysis != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              button: true,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onDetail,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('상세보기', style: sub),
                      const SizedBox(width: 6),
                      Image.asset(
                        AppIcons.chevronGray600,
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 41),
        ],
        _buttonGroup(isMobile, [
          if (showReExplore)
            IconOutlineButton(
              icon: Icons.refresh,
              iconAsset: AppIcons.redo,
              label: '다시 탐색',
              gap: 5,
              onPressed: onReExplore,
            ),
          IconOutlineButton(icon: null, label: 'PDF로 받기', onPressed: onPdf),
          if (!result.isSample)
            IconOutlineButton(
              icon: Icons.bookmark_border,
              iconAsset: result.saved
                  ? AppIcons.bookmarkFilled
                  : AppIcons.bookmark,
              label: result.saved ? '저장 완료' : '저장하기',
              gap: 5,
              onPressed: onSave,
            ),
        ]),
      ],
    );

    return _layout(context, isDesktop, padH, info);
  }

  /// 버튼 줄 + '자원랩에 문의하기'.
  ///
  /// Figma 999:10132: 문의 버튼 폭 = 버튼 줄 폭(C1 430). 좁은 화면은 줄바꿈하고 꽉 채운다.
  Widget _buttonGroup(bool isMobile, List<Widget> buttons) {
    final contact = AppButton(
      label: '자원랩에 문의하기',
      expand: true,
      onPressed: onContact,
    );
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(spacing: 20, runSpacing: 12, children: buttons),
          const SizedBox(height: 15),
          contact,
        ],
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < buttons.length; i++) ...[
                  if (i > 0) const SizedBox(width: 20),
                  buttons[i],
                ],
              ],
            ),
            const SizedBox(height: 15),
            contact,
          ],
        ),
      ),
    );
  }

  Widget _layout(
    BuildContext context,
    bool isDesktop,
    double padH,
    Widget info,
  ) {
    final cover = Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray900),
        borderRadius: BorderRadius.circular(2),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 626 / 426.818,
        child: result.coverImage != null
            ? Image.memory(result.coverImage!.bytes, fit: BoxFit.cover)
            : result.coverAsset != null
            ? Image.asset(result.coverAsset!, fit: BoxFit.cover)
            : const ColoredBox(color: AppColors.gray100),
      ),
    );

    return Container(
      // Figma: 좌우 120이지만 565 + 38 + 626 = 1229가 안쪽 1200보다 넓어
      // 이미지가 오른쪽 여백으로 29 넘친다(x 723~1349) → 오른쪽 91로 맞춤
      padding: EdgeInsets.fromLTRB(padH, 60, isDesktop ? padH - 29 : padH, 60),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray500)),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 565, child: info),
                const SizedBox(width: 38),
                Flexible(child: SizedBox(width: 626, child: cover)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [cover, const SizedBox(height: 30), info],
            ),
    );
  }
}
