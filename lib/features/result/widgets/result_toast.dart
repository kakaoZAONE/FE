import 'dart:async';

import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_header.dart';

/// 결과 화면 위 알림 (Figma `toast` 862:1988 · 1100:9836 · 1100:10286)
///
/// 화면 위 92에 가운데 정렬, gray/900 배경, radius 2, 좌우 20 · 상하 14,
/// 파란 체크 18 + 8 + 글자 18 SemiBold 흰색, 16 뒤 오른쪽 링크 15 Regular gray/200.
/// 그림자 0 10 30 rgba(0,0,0,.2). [duration] 뒤에 사라진다.
///
/// [success]가 false면 체크 없이 글자만 보인다(실패 안내).
void showResultToast(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
  bool success = true,
  Duration duration = const Duration(seconds: 4),
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  _ResultToastHost.current?.remove();
  late final _ResultToastHost host;
  final entry = OverlayEntry(
    builder: (_) => _ResultToastLayer(
      message: message,
      actionLabel: actionLabel,
      success: success,
      onAction: onAction == null
          ? null
          : () {
              host.remove();
              onAction();
            },
    ),
  );
  host = _ResultToastHost(entry);
  overlay.insert(entry);
  host.timer = Timer(duration, host.remove);
}

class _ResultToastHost {
  _ResultToastHost(this.entry) {
    current = this;
  }

  static _ResultToastHost? current;

  final OverlayEntry entry;
  Timer? timer;
  bool _removed = false;

  void remove() {
    if (_removed) return;
    _removed = true;
    timer?.cancel();
    entry.remove();
    if (current == this) current = null;
  }
}

class _ResultToastLayer extends StatelessWidget {
  const _ResultToastLayer({
    required this.message,
    required this.actionLabel,
    required this.success,
    required this.onAction,
  });

  final String message;
  final String? actionLabel;
  final bool success;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // 한 줄 헤더(110)에서는 Figma처럼 위 92(헤더에 살짝 걸침).
    // 1200 미만은 헤더가 두 줄(약 122)이라 메뉴를 가리지 않게 그 아래 134.
    final singleRowHeader =
        MediaQuery.sizeOf(context).width >= AppHeader.singleRowMinWidth;
    return Positioned(
      top: singleRowHeader ? 92 : 134,
      left: 16,
      right: 16,
      child: Center(
        child: ResultToast(
          message: message,
          actionLabel: actionLabel,
          success: success,
          onAction: onAction,
        ),
      ),
    );
  }
}

/// 알림 한 줄 (배치와 상관없이 모양만)
class ResultToast extends StatelessWidget {
  const ResultToast({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.success = true,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 640;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.gray900,
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (success) ...[
              Image.asset(AppIcons.checkBlue, width: 18, height: 18),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: AppFonts.pretendard,
                  fontWeight: FontWeight.w600,
                  fontSize: isNarrow ? 15 : 18,
                  height: 25 / 18,
                  letterSpacing: isNarrow ? -0.6 : -0.72,
                  color: Colors.white,
                ),
              ),
            ),
            if (actionLabel != null) ...[
              const SizedBox(width: 16),
              Semantics(
                button: true,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontFamily: AppFonts.pretendard,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: AppTextStyles.pretendardNormal,
                        letterSpacing: -0.3,
                        color: AppColors.gray200,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
