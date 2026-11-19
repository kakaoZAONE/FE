import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { dark, light }

/// Figma `btn` 컴포넌트 — 높이 50, 좌우 20, radius 2
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.dark,
    this.onPressed,
  });

  final String label;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.variant == AppButtonVariant.dark;
    final bg = isDark ? AppColors.gray900 : AppColors.screen;
    final fg = isDark ? Colors.white : AppColors.gray900;

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
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(2),
            ),
            // 내용 너비만큼만 차지 (부모가 넓어도 늘어나지 않음)
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: AppTextStyles.title18.copyWith(color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
