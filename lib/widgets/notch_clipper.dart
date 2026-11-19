import 'package:flutter/widgets.dart';

/// 우측 상단이 사선으로 꺾여 내려가는 탭 모양 (Figma mask).
///
/// [notchStart]  : 윗변이 끝나고 사선이 시작되는 x (비율 또는 px)
/// [notchEnd]    : 사선이 끝나는 x
/// [notchDepth]  : 사선이 내려오는 깊이(px)
class NotchClipper extends CustomClipper<Path> {
  const NotchClipper({
    required this.notchStart,
    required this.notchEnd,
    required this.notchDepth,
  });

  final double Function(Size size) notchStart;
  final double Function(Size size) notchEnd;
  final double notchDepth;

  @override
  Path getClip(Size size) {
    final x1 = notchStart(size);
    final x2 = notchEnd(size);
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x1, 0)
      ..lineTo(x2, notchDepth)
      ..lineTo(size.width, notchDepth)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant NotchClipper old) =>
      old.notchDepth != notchDepth;
}
