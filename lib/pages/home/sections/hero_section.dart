import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/design_width.dart';
import '../../../widgets/responsive.dart';
import '../home_assets.dart';

/// Figma `hero` — 높이 680, 이미지는 화면 끝까지, 글자는 1440 안에서 좌우 80·상하 100
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final isMobile = r == ScreenSize.mobile;

    final height = Responsive.value<double>(
      context,
      desktop: 680,
      tablet: 560,
      mobile: 480,
    );
    final padH = Responsive.value<double>(
      context,
      desktop: 80,
      tablet: 48,
      mobile: 20,
    );
    final padV = Responsive.value<double>(
      context,
      desktop: 100,
      tablet: 72,
      mobile: 40,
    );
    final titleSize = Responsive.value<double>(
      context,
      desktop: 48,
      tablet: 40,
      mobile: 30,
    );
    final bodyStyle = AppTextStyles.title18.copyWith(
      fontSize: isMobile ? 15 : 18,
      height: isMobile ? 22 / 15 : 25 / 18,
    );

    // 높이는 최소값(데스크톱 680). 글자가 길어 넘치면 그만큼 늘어나고, 글자는 아래에 붙는다.
    return Stack(
      children: [
        // Figma 최종: 정지 이미지 1장
        Positioned.fill(
          child: Image.asset(
            HomeAssets.hero,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00FFF37C), Color(0x520A0A0A)],
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DesignWidth(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '기업 소재의 놀이 가능성 탐색',
                      style: bodyStyle.copyWith(color: AppColors.screen),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '우리 회사의 소재로\n어떤 놀이가 가능할까요?',
                      style: AppTextStyles.heroTitle.copyWith(
                        fontSize: titleSize,
                        letterSpacing: titleSize * -0.03,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '소재 사진을 등록하면 AI가 특징을 분석하고 원래 쓰임을 넘어서는 놀이 확장 3가지를 제안합니다.',
                      style: bodyStyle.copyWith(color: AppColors.gray50),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: isMobile ? 12 : 30,
                      runSpacing: 12,
                      children: [
                        AppButton(
                          label: '내 소재 등록하기',
                          onPressed: () =>
                              AppHeader.goTo(context, AppRoutes.register),
                        ),
                        AppButton(
                          label: '샘플로 미리보기',
                          variant: AppButtonVariant.light,
                          onPressed: () =>
                              AppHeader.goTo(context, AppRoutes.samples),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
