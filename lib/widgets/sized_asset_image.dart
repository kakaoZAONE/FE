import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 보이는 크기에 맞춰 작게 디코딩하는 에셋 이미지.
///
/// 원본(1536×1024)을 그대로 풀면 메모리를 많이 먹고 스크롤이 끊긴다.
/// 화면에 그려질 크기 × 기기 배율 × 1.5(cover 여유) 정도로만 디코딩한다.
/// 크기 변화마다 다시 디코딩하지 않도록 128px 단위로 올림.
class SizedAssetImage extends StatelessWidget {
  const SizedAssetImage(this.path, {super.key, this.fit = BoxFit.cover});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
        final h = constraints.maxHeight.isFinite ? constraints.maxHeight : 0.0;
        final longest = math.max(w, h);
        if (longest == 0) return Image.asset(path, fit: fit);
        final target = longest * dpr * 1.5;
        final cacheWidth = (target / 128).ceil() * 128;
        return Image.asset(
          path,
          fit: fit,
          width: w == 0 ? null : w,
          height: h == 0 ? null : h,
          cacheWidth: cacheWidth,
        );
      },
    );
  }
}
