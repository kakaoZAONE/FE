import 'package:flutter/material.dart';

import '../../widgets/design_width.dart';
import '../../widgets/responsive.dart';
import 'sections/contact_section.dart';
import 'sections/hero_section.dart';
import 'sections/home_footer.dart';
import 'sections/home_header.dart';
import 'sections/process_section.dart';
import 'sections/sample_section.dart';
import 'sections/scene_section.dart';

/// Figma `1.1 main`
///
/// 배경(헤더·히어로·푸터)은 화면 끝까지, 내용은 최대 1440 가운데.
/// 구간별 레이아웃은 [Responsive] 참고.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    // 섹션 사이: 데스크톱 160 = 패딩 60 + 간격 40 + 패딩 60 (피그마)
    final sectionGap = Responsive.value<double>(
      context,
      desktop: 160,
      tablet: 120,
      mobile: 80,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // 로고 누르면 맨 위로 올라가도록 PrimaryScrollController 사용
        primary: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(),
            const HeroSection(),
            DesignWidth(
              child: Padding(
                // 데스크톱 위 105 = 5(세로 가운데 정렬 여백) + 40 + 60 — 피그마 y 895
                padding: EdgeInsets.fromLTRB(
                  pad,
                  Responsive.value<double>(
                    context,
                    desktop: 105,
                    tablet: 80,
                    mobile: 50,
                  ),
                  pad,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ProcessSection(),
                    SizedBox(height: sectionGap),
                    const SampleSection(),
                    SizedBox(height: sectionGap),
                    const SceneSection(),
                    SizedBox(height: sectionGap / 1.6),
                    const ContactSection(),
                  ],
                ),
              ),
            ),
            // Contact 아래 ~ Footer 위 여백: 피그마 3836 - (2402 + 314 + 795) = 325
            SizedBox(
              height: Responsive.value<double>(
                context,
                desktop: 325,
                tablet: 210,
                mobile: 80,
              ),
            ),
            const HomeFooter(),
          ],
        ),
      ),
    );
  }
}
