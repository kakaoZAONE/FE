import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// - dark    : 검정 배경 + 흰 글자 (예: 내 소재 등록하기)
/// - light   : 흰 배경 + 검정 글자 (예: 샘플로 미리보기)
/// - outline : 흰 배경 + 검정 1px 테두리 (예: 헤더 Log in)
enum AppButtonVariant { dark, light, outline }

/// Figma `btn` 컴포넌트 — 높이 50, 좌우 20, radius 2
///
/// [expand]가 true면 부모 너비만큼 늘어나고 글자는 가운데 정렬.
/// [foregroundColor]로 글자색만 바꿀 수 있음 (예: 로그인 창 '나가기' 회색).
/// [onPressed]가 null이면 아직 연결된 기능이 없는 상태로 보고
/// 모양은 그대로 두되 클릭 커서·hover 반응을 주지 않는다.
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

  bool get _enabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.variant == AppButtonVariant.dark;
    final bg = isDark ? AppColors.gray900 : AppColors.screen;
    final fg =
        widget.foregroundColor ?? (isDark ? Colors.white : AppColors.gray900);
    // 폭이 모자란 아주 좁은 화면에서만 글자를 줄여 넘치지 않게 (넉넉하면 원래 크기)
    final label = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        widget.label,
        maxLines: 1,
        style: AppTextStyles.title18.copyWith(color: fg),
      ),
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: _enabled ? (_) => setState(() => _hovered = false) : null,
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
                border: widget.variant == AppButtonVariant.outline
                    ? Border.all(color: AppColors.gray900)
                    : null,
                borderRadius: BorderRadius.circular(2),
              ),
              // expand가 아니면 내용 너비만큼만 차지
              child: widget.expand
                  ? label
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Flexible(child: label)],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
