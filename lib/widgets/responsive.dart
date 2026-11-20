import 'package:flutter/widgets.dart';

/// 화면 구간
/// - mobile  : 640 미만
/// - tablet  : 640 ~ 1023
/// - desktop : 1024 이상 (피그마 1440 기준 디자인)
enum ScreenSize { mobile, tablet, desktop }

abstract final class Responsive {
  static const mobileMax = 640.0;
  static const tabletMax = 1024.0;

  static ScreenSize of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < mobileMax) return ScreenSize.mobile;
    if (w < tabletMax) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  /// 구간별 값 고르기. tablet 생략 시 desktop 값 사용.
  static T value<T>(
    BuildContext context, {
    required T desktop,
    T? tablet,
    required T mobile,
  }) {
    return switch (of(context)) {
      ScreenSize.desktop => desktop,
      ScreenSize.tablet => tablet ?? desktop,
      ScreenSize.mobile => mobile,
    };
  }

  /// 페이지 좌우 여백 (피그마 데스크톱 60)
  static double pagePadding(BuildContext context) =>
      value(context, desktop: 60, tablet: 40, mobile: 20);
}

/// 한 줄에 [columns]개씩 같은 너비로 배치하는 간단한 그리드
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.columns,
    required this.children,
    this.gap = 20,
    this.runGap = 20,
  });

  final int columns;
  final double gap;
  final double runGap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += columns) {
      final cells = <Widget>[];
      for (var i = 0; i < columns; i++) {
        if (i > 0) cells.add(SizedBox(width: gap));
        final index = start + i;
        cells.add(
          Expanded(
            child: index < children.length ? children[index] : const SizedBox(),
          ),
        );
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: runGap));
      rows.add(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
