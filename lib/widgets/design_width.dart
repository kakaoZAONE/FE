import 'package:flutter/widgets.dart';

/// 피그마 기준 너비(1440). 배경은 화면 끝까지 채우고, 내용은 최대 1440으로 가운데 둔다.
const double kDesignWidth = 1440;

class DesignWidth extends StatelessWidget {
  const DesignWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kDesignWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
