import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/flow_widgets.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/responsive.dart';
import 'result_models.dart';

/// 장면 카드 상태
enum SceneCardState { ready, loading, failed }

/// 놀이 장면 카드 (Figma `list` 775:3901)
///
/// 테두리 gray/600, 안쪽 30. 왼쪽 374(제목 32 · 설명 18 · 특성/확인 14 · 다시 생성 버튼),
/// 오른쪽 이미지 813 x 373. 좁은 화면에서는 이미지가 위로 간다.
class SceneCard extends StatelessWidget {
  const SceneCard({
    super.key,
    this.scene,
    this.state = SceneCardState.ready,
    this.onRegenerate,
    this.onRetry,
    this.regenerateLabel = '이 장면만 다시 생성',
  });

  final PlayScene? scene;
  final SceneCardState state;
  final VoidCallback? onRegenerate;
  final VoidCallback? onRetry;
  final String regenerateLabel;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    final failed = state == SceneCardState.failed;

    return Container(
      constraints: const BoxConstraints(minHeight: 435),
      padding: EdgeInsets.all(isDesktop ? 30 : 20),
      decoration: BoxDecoration(
        color: AppColors.screen,
        border: Border.all(color: failed ? kErrorColor : AppColors.gray600),
      ),
      child: switch (state) {
        SceneCardState.failed => _Failed(onRetry: onRetry),
        SceneCardState.loading => _Skeleton(desktop: isDesktop),
        SceneCardState.ready => _Ready(
          scene: scene!,
          desktop: isDesktop,
          onRegenerate: onRegenerate,
          regenerateLabel: regenerateLabel,
        ),
      },
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({
    required this.scene,
    required this.desktop,
    required this.onRegenerate,
    required this.regenerateLabel,
  });

  final PlayScene scene;
  final bool desktop;
  final VoidCallback? onRegenerate;
  final String regenerateLabel;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    const meta = TextStyle(
      fontFamily: AppFonts.pretendard,
      fontSize: 14,
      height: AppTextStyles.pretendardNormal,
    );
    Widget metaRow(String label, String value) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(label, style: meta.copyWith(color: AppColors.gray500)),
        ),
        Expanded(
          child: Text(value, style: meta.copyWith(color: AppColors.gray900)),
        ),
      ],
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          scene.title,
          style: TextStyle(
            fontFamily: AppFonts.pretendard,
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 24 : 32,
            height: AppTextStyles.pretendardNormal,
            letterSpacing: isMobile ? -0.48 : -0.64,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          scene.description,
          style: AppTextStyles.title18.copyWith(
            color: AppColors.gray900,
            fontSize: isMobile ? 15 : 18,
            height: isMobile ? 22 / 15 : 25 / 18,
          ),
        ),
        const SizedBox(height: 24),
        metaRow('활용한 특성', scene.traits),
        if (scene.checks != null) ...[
          const SizedBox(height: 6),
          metaRow('활용 전 확인', scene.checks!),
        ],
        if (onRegenerate != null) ...[
          const SizedBox(height: 20),
          IconOutlineButton(
            icon: Icons.refresh,
            label: regenerateLabel,
            onPressed: onRegenerate,
          ),
        ],
      ],
    );

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: AspectRatio(
        aspectRatio: 813 / 373,
        child: Image.asset(scene.image, fit: BoxFit.cover),
      ),
    );

    if (!desktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [image, const SizedBox(height: 20), text],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 374, child: text),
        const SizedBox(width: 73),
        Expanded(child: image),
      ],
    );
  }
}

/// 생성 중 자리 표시 — 회색 막대 3개 + 회색 이미지 칸
class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.desktop});

  final bool desktop;

  @override
  Widget build(BuildContext context) {
    Widget bar(double w) => Container(
      width: w,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(4),
      ),
    );
    final lines = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(255),
        const SizedBox(height: 10),
        bar(180),
        const SizedBox(height: 10),
        bar(113),
      ],
    );
    final box = AspectRatio(
      aspectRatio: 813 / 373,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
    return Semantics(
      label: '장면 생성 중',
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 374, child: lines),
                const SizedBox(width: 73),
                Expanded(child: box),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [box, const SizedBox(height: 20), lines],
            ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 373,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '해당 장면 생성에 실패했어요',
              style: AppTextStyles.title18.copyWith(
                color: kErrorColor,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            IconOutlineButton(
              icon: Icons.refresh,
              label: '다시 시도',
              onPressed: onRetry,
              compact: true,
            ),
          ],
        ),
      ),
    );
  }
}
