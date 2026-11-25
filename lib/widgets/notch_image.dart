import 'package:flutter/material.dart';

import 'notch_clipper.dart';
import 'number_tag.dart';

/// 우측 상단이 사선으로 잘린 이미지 + 왼쪽 위 검정 태그 (Figma process 카드 머리)
///
/// 마스크 비율은 메인 과정 카드(폭 427 · M0 0 H294.938 L347.763 67.1748)를 따른다.
class NotchImage extends StatelessWidget {
  const NotchImage({
    super.key,
    required this.image,
    required this.tag,
    required this.aspectRatio,
    this.shade,
    this.alignment = Alignment.center,
    this.tagFontFamily,
  });

  final String image;
  final String tag;
  final double aspectRatio;
  final Gradient? shade;
  final Alignment alignment;
  final String? tagFontFamily;

  /// 메인 과정 카드와 같은 위쪽 어둡게 그라데이션
  static const topShade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x99000000),
      Color(0x80000000),
      Color(0x38000000),
      Color(0x00000000),
    ],
    stops: [0, 0.133, 0.333, 0.613],
  );

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: NotchClipper(
        notchStart: (s) => s.width * 294.938 / 427,
        notchEnd: (s) => s.width * 347.763 / 427,
        notchDepth: 67.1748,
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover, alignment: alignment),
            if (shade != null)
              DecoratedBox(decoration: BoxDecoration(gradient: shade)),
            Positioned(
              left: 25,
              top: 25,
              child: NumberTag(tag, fontFamily: tagFontFamily),
            ),
          ],
        ),
      ),
    );
  }
}
