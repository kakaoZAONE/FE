import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { dark, light }

/// Figma `btn` 컴포넌트 — 높이 50, 좌우 20, radius 2
///
/// [expand]가 true면 부모 너비만큼 늘어나고 글자는 가운데 정렬.
/// [foregroundColor]로 글자색만 바꿀 수 있음 (예: 로그인 창 '나가기' 회색).
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.dark,
    this.onPressed,
    this.expand = false,
    this.foregroundColor,
  });

  final String label;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;
  final bool expand;
  final Color? foregroundColor;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.variant == AppButtonVariant.dark;
    final bg = isDark ? AppColors.gray900 : AppColors.screen;
    final fg =
        widget.foregroundColor ?? (isDark ? Colors.white : AppColors.gray900);
    final label = Text(
      widget.label,
      style: AppTextStyles.title18.copyWith(color: fg),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: _hovered ? 0.85 : 1,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: widget.expand ? Alignment.center : null,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(2),
            ),
            // expand가 아니면 내용 너비만큼만 차지
            child: widget.expand
                ? label
                : Row(mainAxisSize: MainAxisSize.min, children: [label]),
          ),
        ),
      ),
    );
  }
}
