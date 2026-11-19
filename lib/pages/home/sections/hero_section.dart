import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../home_assets.dart';

/// Figma `hero` — 높이 680, 좌우 80, 상하 100, 하단 정렬
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 680,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(HomeAssets.hero, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00FFF37C), Color(0x520A0A0A)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '기업 소재의 놀이 가능성 탐색',
                  style: AppTextStyles.title18.copyWith(color: AppColors.screen),
                ),
                const SizedBox(height: 10),
                const Text(
                  '우리 회사의 소재로\n어떤 놀이가 가능할까요?',
                  style: AppTextStyles.heroTitle,
                ),
                const SizedBox(height: 20),
                Text(
                  '소재 사진을 등록하면 AI가 특징을 분석하고 원래 쓰임을 넘어서는 놀이 확장 3가지를 제안합니다.',
                  style: AppTextStyles.title18.copyWith(color: AppColors.gray50),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    AppButton(label: '내 소재 등록하기', onPressed: () {}),
                    const SizedBox(width: 30),
                    AppButton(
                      label: '샘플로 미리보기',
                      variant: AppButtonVariant.light,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
