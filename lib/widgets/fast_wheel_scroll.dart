import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// 마우스 휠 스크롤을 일반 웹사이트처럼 크게, 부드럽게 만든다.
///
/// 스크롤 뷰의 **child** 쪽에 둔다 (스크롤 뷰보다 안쪽이어야 휠 입력을 먼저 받음).
/// - 휠 한 칸 이동 거리 × [speed]
/// - 매 프레임 목표 위치로 일정 비율씩 다가가서(관성), 연속으로 굴려도 끊기지 않음
/// - 트랙패드처럼 작은 입력(< [wheelThreshold]px)은 원래대로 바로 이동
class FastWheelScroll extends StatefulWidget {
  const FastWheelScroll({
    super.key,
    required this.child,
    this.speed = 2.0,
    this.smoothness = 12,
    this.wheelThreshold = 40,
  });

  final Widget child;
  final double speed;

  /// 클수록 목표 위치에 빨리 도착 (초당 감쇠 계수, 12 ≈ 0.3초 안에 거의 도착)
  final double smoothness;
  final double wheelThreshold;

  @override
  State<FastWheelScroll> createState() => _FastWheelScrollState();
}

class _FastWheelScrollState extends State<FastWheelScroll>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double? _target;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  ScrollPosition? get _position => Scrollable.maybeOf(context)?.position;

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final dy = event.scrollDelta.dy;
    if (dy == 0) return;
    // 바깥 Scrollable보다 먼저 등록해서 이 처리만 실행되게 함
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      final position = _position;
      if (position == null) return;

      if (dy.abs() < widget.wheelThreshold) {
        _stop();
        position.pointerScroll(dy);
        return;
      }

      final base = _target ?? position.pixels;
      _target = (base + dy * widget.speed).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      if (!_ticker.isActive) {
        _lastElapsed = Duration.zero;
        _ticker.start();
      }
    });
  }

  void _tick(Duration elapsed) {
    final position = _position;
    final target = _target;
    if (position == null || target == null || !position.hasPixels) {
      _stop();
      return;
    }
    var dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (dt <= 0) dt = 1 / 60;

    // 프레임 간격과 상관없이 같은 속도로 다가가도록 지수 감쇠
    final k = 1 - math.exp(-dt * widget.smoothness);
    var next = position.pixels + (target - position.pixels) * k;
    if ((target - next).abs() < 0.5) {
      next = target;
      _stop();
    }
    position.jumpTo(next);
  }

  void _stop() {
    _target = null;
    if (_ticker.isActive) _ticker.stop();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // translucent: 섹션 사이 빈 여백 위에서 굴려도 똑같이 동작
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: _onPointerSignal,
      child: widget.child,
    );
  }
}
