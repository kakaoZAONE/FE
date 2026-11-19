import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/responsive.dart';
import '../home_assets.dart';
import 'section_heading.dart';

/// "소재별 결과를 먼저 확인해 보세요" — 샘플 카드 4개
/// 데스크톱 4열 / 태블릿 2열 / 모바일 1열
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
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final columns = Responsive.value(context, desktop: 4, tablet: 2, mobile: 1);

    const heading = SectionHeading(
      title: '소재별 결과를 먼저 확인해 보세요',
      sub: '기업 소재를 가정해 미리 만든 결과입니다. 해외 기관의 실제 활용 사례도 함께 볼 수 있어요',
    );
    final button = AppButton(label: '전체보기', onPressed: () {});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile) ...[
          heading,
          const SizedBox(height: 20),
          button,
        ] else
          Row(
            children: [
              const Expanded(child: heading),
              const SizedBox(width: 40),
              button,
            ],
          ),
        SizedBox(height: isMobile ? 24 : 40),
        ResponsiveGrid(
          columns: columns,
          children: [
            for (final s in _samples)
              SampleCard(images: s.$1, name: s.$2, source: s.$3, caseCount: s.$4),
          ],
        ),
      ],
    );
  }
}

/// Figma `샘플 카드` 컴포넌트 (데스크톱 기준 이미지 폭 280)
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 피그마 280 x 188
              _RoundedImage(widget.images[0], aspectRatio: 280 / 188),
              const SizedBox(height: 4),
              Row(
                children: [
                  for (var i = 1; i < widget.images.length; i++) ...[
                    if (i > 1) const SizedBox(width: 4),
                    // 피그마 약 91 x 64
                    Expanded(
                      child: _RoundedImage(widget.images[i], aspectRatio: 91 / 64),
                    ),
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
    );
  }
}

class _RoundedImage extends StatelessWidget {
  const _RoundedImage(this.path, {required this.aspectRatio});

  final String path;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}
