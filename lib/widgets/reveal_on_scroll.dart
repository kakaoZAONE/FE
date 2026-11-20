import 'package:flutter/widgets.dart';

/// 스크롤해서 화면에 들어오면 한 번만 아래에서 떠오르며 나타난다.
///
/// - 위치 이동은 Transform이라 레이아웃(피그마 수치)에는 영향 없음
/// - 시스템 '애니메이션 줄이기'가 켜져 있으면 바로 보여 줌
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.distance = 40,
    this.duration = const Duration(milliseconds: 700),
    this.triggerFraction = 0.88,
  });

  final Widget child;

  /// 처음에 아래로 내려가 있는 거리(px)
  final double distance;
  final Duration duration;

  /// 위젯 윗변이 화면 높이의 이 비율보다 위로 오면 시작
  final double triggerFraction;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  ScrollPosition? _position;
  bool _shown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _show(animate: false);
      return;
    }
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position;
      if (!_shown) _position?.addListener(_check);
    }
    // 첫 화면에 이미 보이는 경우
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (top < screenHeight * widget.triggerFraction) _show();
  }

  void _show({bool animate = true}) {
    if (_shown) return;
    _shown = true;
    _position?.removeListener(_check);
    if (animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FadeTransition은 위젯을 다시 만들지 않고 투명도만 바꿔서 가볍다.
    return FadeTransition(
      opacity: _curve,
      child: AnimatedBuilder(
        animation: _curve,
        child: widget.child,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, (1 - _curve.value) * widget.distance),
          child: child,
        ),
      ),
    );
  }
}
