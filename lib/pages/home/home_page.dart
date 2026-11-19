import 'package:flutter/material.dart';

import 'sections/contact_section.dart';
import 'sections/hero_section.dart';
import 'sections/home_footer.dart';
import 'sections/home_header.dart';
import 'sections/process_section.dart';
import 'sections/sample_section.dart';
import 'sections/scene_section.dart';

/// Figma `1.1 main` (1440 x 3994)
///
/// 1440px 기준 디자인. 창이 1440보다 좁으면 비율 그대로 축소해서 보여준다.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const designWidth = 1440.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = constraints.maxWidth;
          final page = SizedBox(width: designWidth, child: const _HomeContent());

          return SingleChildScrollView(
            child: viewport >= designWidth
                ? Center(child: page)
                : SizedBox(
                    width: viewport,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      child: page,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeHeader(),
        HeroSection(),
        // Figma `Frame 114` — 바깥 10 + 위아래 40
        Padding(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Section(child: ProcessSection()),
              SizedBox(height: 40),
              _Section(child: SampleSection()),
              SizedBox(height: 40),
              _Section(child: SceneSection()),
              SizedBox(height: 40),
              Center(
                child: SizedBox(width: 1320, child: ContactSection()),
              ),
            ],
          ),
        ),
        // Figma 프레임에서 Contact 아래 ~ Footer 사이 여백
        SizedBox(height: 288),
        HomeFooter(),
      ],
    );
  }
}

/// 섹션 공통 패딩 60
class _Section extends StatelessWidget {
  const _Section({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
      child: child,
    );
  }
}
