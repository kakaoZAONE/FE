import 'dart:async';

import 'package:flutter/widgets.dart';

/// 이미지 여러 장을 [interval]마다 부드럽게(페이드) 바꿔 보여준다.
class FadeSlideshow extends StatefulWidget {
  const FadeSlideshow({
    super.key,
    required this.images,
    this.interval = const Duration(seconds: 5),
    this.fadeDuration = const Duration(milliseconds: 900),
  });

  final List<String> images;
  final Duration interval;
  final Duration fadeDuration;

  @override
  State<FadeSlideshow> createState() => _FadeSlideshowState();
}

class _FadeSlideshowState extends State<FadeSlideshow> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.images.length > 1) {
      _timer = Timer.periodic(widget.interval, (_) {
        setState(() => _index = (_index + 1) % widget.images.length);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 다음 장이 바뀔 때 깜빡이지 않도록 미리 불러두기
    for (final path in widget.images) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.fadeDuration,
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.expand,
        children: [...previous, if (current != null) current],
      ),
      child: Image.asset(
        widget.images[_index],
        key: ValueKey(_index),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
