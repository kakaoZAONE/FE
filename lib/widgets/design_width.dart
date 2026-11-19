import 'package:flutter/widgets.dart';

/// 피그마 기준 너비(1440). 배경은 화면 끝까지 채우고, 내용만 가운데 1440 안에 둔다.
const double kDesignWidth = 1440;

class DesignWidth extends StatelessWidget {
  const DesignWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(width: kDesignWidth, child: child),
    );
  }
}
