import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../home_assets.dart';
import 'section_heading.dart';

/// "원래 쓰임에서는 떠올리기 어려운 활용을 제안합니다" — 탐색/변형/조합 카드
class SceneSection extends StatelessWidget {
  const SceneSection({super.key});

  static const _scenes = [
    (
      HomeAssets.sceneExplore,
      '탐색',
      '원단을 감던 심을 소리를 전하는 통로로\n관을 이어 서로 말하고 들어 봅니다.',
    ),
    (
      HomeAssets.sceneTransform,
      '변형',
      '심을 짧게 잘라 빛 테이블 위에 늘어놓습니다.\n자른 심에 따라 빛이 다르게 보입니다',
    ),
    (
      HomeAssets.sceneCombine,
      '조합',
      '포장 부자재와 조합하여 \n벽을 따라 구슬이 흐르는 길을 만듭니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          title: '원래 쓰임에서는 떠올리기 어려운 활용을 제안합니다',
          sub: '결과는 탐색·변형·조합 세 방향으로 나뉘며 장면마다 소재가 어떤 새로운 쓰임으로 바뀌는지 함께 보여줍니다.',
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _scenes.length; i++) ...[
              if (i > 0) const SizedBox(width: 30),
              _SceneCard(
                image: _scenes[i].$1,
                title: _scenes[i].$2,
                body: _scenes[i].$3,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
  final String title;
  final String body;

  static const _radius = Radius.circular(16);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      height: 491,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: _radius),
            child: Image.asset(image, height: 362, fit: BoxFit.cover),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              border: Border.all(color: const Color(0xC2FFFFFF)),
              borderRadius: const BorderRadius.vertical(bottom: _radius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title24),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: AppTextStyles.title18.copyWith(color: AppColors.gray600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
