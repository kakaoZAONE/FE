import 'package:flutter/material.dart';

import 'app_footer.dart';
import 'app_header.dart';
import 'fast_wheel_scroll.dart';

/// 공통 페이지 틀 — 헤더 · 본문 · 푸터를 한 번에 스크롤한다.
///
/// [body]는 헤더 바로 아래부터 푸터 위까지의 내용이다.
/// [bottomGap]은 본문 마지막 요소와 푸터 사이 여백.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.body,
    this.bottomGap = 0,
    this.showFooter = true,
    this.backgroundColor = Colors.white,
  });

  final Widget body;
  final double bottomGap;
  final bool showFooter;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        primary: true,
        child: FastWheelScroll(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeader(),
              body,
              if (bottomGap > 0) SizedBox(height: bottomGap),
              if (showFooter) const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
