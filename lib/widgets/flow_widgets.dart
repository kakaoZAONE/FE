import 'package:flutter/material.dart';

import '../pages/home/home_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';
import 'app_header.dart';
import 'design_width.dart';
import 'form_widgets.dart';
import 'responsive.dart';

/// 등록 흐름 헤더 (Figma 999:9782) — 로고 ······ [나가기]
class FlowHeader extends StatelessWidget {
  const FlowHeader({super.key, required this.onExit});

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    return Container(
      color: AppColors.screen,
      foregroundDecoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray400)),
      ),
      child: DesignWidth(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad, vertical: 30),
          child: Row(
            children: [
              Semantics(
                label: '자원도감 홈',
                button: true,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onExit,
                    child: SizedBox(
                      width: 94,
                      height: 36,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          HomeAssets.logo,
                          width: 91,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AppButton(
                label: '나가기',
                variant: AppButtonVariant.outline,
                onPressed: onExit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 단계 표시: 지난·현재 단계는 Bold gray/900, 남은 단계는 Medium gray/400
/// 단계 사이 > 아이콘 24, 간격 10
class StepTrail extends StatelessWidget {
  const StepTrail({
    super.key,
    required this.steps,
    required this.current,
    this.boldPast = true,
  });

  final List<String> steps;

  /// 0부터. 이 값 이하 단계가 진하게 표시된다.
  final int current;

  /// false면 지난 단계도 흐리게(gray/400 Medium) — C1 결과 화면 `flow`(787:14559)
  final bool boldPast;

  bool _on(int i) => boldPast ? i <= current : i == current;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final size = isMobile ? 16.0 : 22.0;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Icon(
              Icons.chevron_right,
              size: isMobile ? 18 : 24,
              color: AppColors.gray600,
            ),
          Text(
            steps[i],
            style: TextStyle(
              fontFamily: AppFonts.pretendard,
              fontWeight: _on(i) ? FontWeight.w700 : FontWeight.w500,
              fontSize: size,
              height: AppTextStyles.pretendardNormal,
              color: _on(i) ? AppColors.gray900 : AppColors.gray400,
            ),
          ),
        ],
      ],
    );
  }
}

/// 화면 제목 36 Bold + 설명 15 Medium gray/700, 간격 14
class FlowTitle extends StatelessWidget {
  const FlowTitle({super.key, required this.title, this.sub, this.subColor});

  final String title;
  final String? sub;
  final Color? subColor;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.pretendard,
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 26 : 36,
            height: AppTextStyles.pretendardNormal,
            letterSpacing: isMobile ? -0.52 : -0.72,
            color: AppColors.gray900,
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 14),
          Text(
            sub!,
            style: AppTextStyles.body15.copyWith(
              color: subColor ?? AppColors.gray700,
            ),
          ),
        ],
      ],
    );
  }
}

/// 화면 아래 고정 막대 — 높이 84, 위 보더 gray/200, 좌우 120
/// [이전](글자 버튼) ······ [다음](검정)
class FlowBottomBar extends StatelessWidget {
  const FlowBottomBar({
    super.key,
    this.onPrev,
    this.showPrev = true,
    required this.nextLabel,
    this.onNext,
  });

  final VoidCallback? onPrev;
  final bool showPrev;
  final String nextLabel;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final padH = Responsive.value<double>(
      context,
      desktop: 120,
      tablet: 40,
      mobile: 20,
    );
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.gray200)),
      ),
      child: DesignWidth(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padH),
          child: Row(
            children: [
              Opacity(
                opacity: showPrev ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !showPrev,
                  child: AppButton(
                    label: '이전',
                    variant: AppButtonVariant.light,
                    onPressed: onPrev,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: null,
                child: FillButton(label: nextLabel, onPressed: onNext),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 확인 창 (Figma B2 나가기 · B6-1) — 폭 ~506, 제목 + 설명 + [왼쪽 글자 버튼][오른쪽 검정]
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String leftLabel,
  required String rightLabel,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: const Color(0x8C0F1115),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 506),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          decoration: BoxDecoration(
            color: AppColors.screen,
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1742475B),
                offset: Offset(0, 18),
                blurRadius: 22.5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: AppTextStyles.title16.copyWith(
                  color: AppColors.gray900,
                  letterSpacing: -0.32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.body13.copyWith(color: AppColors.gray600),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: leftLabel,
                      variant: AppButtonVariant.light,
                      foregroundColor: AppColors.gray400,
                      expand: true,
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      label: rightLabel,
                      expand: true,
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// 탐색 · 변형 · 조합 메뉴 3칸 (폭 427, 높이 50, 보더 gray/500, 글자 24 SemiBold)
class ModeTabs extends StatelessWidget {
  const ModeTabs({super.key, required this.onTap, this.labels});

  final ValueChanged<int> onTap;
  final List<String>? labels;

  @override
  Widget build(BuildContext context) {
    final items = labels ?? const ['탐색', '변형', '조합'];
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: isMobile ? 8 : 19.5),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.screen,
                    border: Border.all(color: AppColors.gray500),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    items[i],
                    style: AppTextStyles.title24.copyWith(
                      fontSize: isMobile ? 18 : 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 아이콘 + 글자 outline 버튼 (다시 탐색 · 이 장면만 다시 생성 · 저장하기)
class IconOutlineButton extends StatelessWidget {
  const IconOutlineButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.gap = 8,
    this.compact = false,
    this.iconAsset,
  });

  final IconData? icon;

  /// Figma 아이콘 에셋([AppIcons]). 있으면 [icon] 대신 쓴다.
  final String? iconAsset;
  final String label;
  final VoidCallback? onPressed;
  final double gap;

  /// 작은 버튼(다시 시도 · 수정 등)
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: compact ? 32 : 50,
            padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 20),
            decoration: BoxDecoration(
              color: AppColors.screen,
              border: Border.all(color: AppColors.gray900),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconAsset != null) ...[
                  Image.asset(
                    iconAsset!,
                    width: compact ? 18 : 24,
                    height: compact ? 18 : 24,
                  ),
                  SizedBox(width: compact ? 6 : gap),
                ] else if (icon != null) ...[
                  Icon(icon, size: compact ? 18 : 24, color: AppColors.gray900),
                  SizedBox(width: compact ? 6 : gap),
                ],
                Text(
                  label,
                  style: AppTextStyles.title18.copyWith(
                    color: AppColors.gray900,
                    fontSize: compact ? 15 : 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 화면 오른쪽 위 뒤로가기 + 단계 표시 줄 (Figma: back 60,126 / flow 149,134)
class FlowTopRow extends StatelessWidget {
  const FlowTopRow({
    super.key,
    required this.steps,
    required this.current,
    this.onBack,
  });

  final List<String> steps;
  final int current;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 15, pad, 0),
      child: Row(
        children: [
          if (onBack != null)
            BackBox(onTap: onBack)
          else
            const SizedBox(width: 42, height: 42),
          SizedBox(
            width: Responsive.value<double>(context, desktop: 47, mobile: 16),
          ),
          Expanded(
            child: StepTrail(steps: steps, current: current),
          ),
        ],
      ),
    );
  }
}

/// 검정 '자원도감' 로고 위젯을 다른 곳에서 홈으로 가는 데 쓰기 위한 편의 함수
void goHomeFromFlow(BuildContext context) => AppHeader.goHome(context);
