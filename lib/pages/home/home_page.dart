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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(),
            const HeroSection(),
            DesignWidth(
              child: Padding(
                // 데스크톱: 위 110(10+40+60), 아래 50(10+40) — 피그마 값
                padding: EdgeInsets.fromLTRB(
                  pad,
                  Responsive.value<double>(
                    context,
                    desktop: 110,
                    tablet: 80,
                    mobile: 50,
                  ),
                  pad,
                  Responsive.value<double>(context, desktop: 50, mobile: 0),
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
            // Figma 프레임에서 Contact 아래 ~ Footer 사이 여백
            SizedBox(
              height: Responsive.value<double>(
                context,
                desktop: 288,
                tablet: 160,
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
