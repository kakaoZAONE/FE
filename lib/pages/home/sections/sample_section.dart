import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../home_assets.dart';
import 'section_heading.dart';

/// "소재별 결과를 먼저 확인해 보세요" — 샘플 카드 4개
class SampleSection extends StatelessWidget {
  const SampleSection({super.key});

  static const _samples = [
    (HomeAssets.paperTube, '종이관', '섬유 제조 · 원단 심', 2),
    (HomeAssets.zipper, '지퍼 자투리', '의류 봉제 공정', 1),
    (HomeAssets.bottleCap, '플라스틱 병 뚜껑', '불량 공정', 2),
    (HomeAssets.cushion, '포장 완충재', '가전 제품 포장', 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: SectionHeading(
                title: '소재별 결과를 먼저 확인해 보세요',
                sub: '기업 소재를 가정해 미리 만든 결과입니다. 해외 기관의 실제 활용 사례도 함께 볼 수 있어요',
              ),
            ),
            const SizedBox(width: 40),
            AppButton(label: '전체보기', onPressed: () {}),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _samples.length; i++) ...[
              if (i > 0) const SizedBox(width: 20),
              SampleCard(
                images: _samples[i].$1,
                name: _samples[i].$2,
                source: _samples[i].$3,
                caseCount: _samples[i].$4,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Figma `샘플 카드` 컴포넌트
class SampleCard extends StatefulWidget {
  const SampleCard({
    super.key,
    required this.images,
    required this.name,
    required this.source,
    required this.caseCount,
    this.onTap,
  });

  final List<String> images;
  final String name;
  final String source;
  final int caseCount;
  final VoidCallback? onTap;

  @override
  State<SampleCard> createState() => _SampleCardState();
}

class _SampleCardState extends State<SampleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
          decoration: BoxDecoration(
            color: const Color(0x99FFFFFF),
            border: Border.all(
              color: _hovered ? AppColors.gray900 : AppColors.gray300,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: SizedBox(
            width: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoundedImage(widget.images[0], height: 188),
                const SizedBox(height: 4),
                Row(
                  children: [
                    for (var i = 1; i < widget.images.length; i++) ...[
                      if (i > 1) const SizedBox(width: 4),
                      Expanded(child: _RoundedImage(widget.images[i], height: 64)),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                Text(widget.name, style: AppTextStyles.title24),
                const SizedBox(height: 10),
                Text(widget.source, style: AppTextStyles.title16),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.screen,
                    border: Border.all(color: AppColors.gray900),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '해외 실제 사례 ${widget.caseCount}건',
                    style: AppTextStyles.body13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundedImage extends StatelessWidget {
  const _RoundedImage(this.path, {required this.height});

  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image.asset(
        path,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
