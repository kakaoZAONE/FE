import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../features/sample_result/sample_result_page.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/sized_asset_image.dart';
import '../home_assets.dart';
import 'section_heading.dart';

/// "소재별 결과를 먼저 확인해 보세요" — 샘플 카드 4개
/// 데스크톱 4열 / 태블릿 2열 / 모바일 1열
class SampleSection extends StatelessWidget {
  const SampleSection({super.key});

  static const _samples = [
    // 순서는 샘플 결과 페이지의 소재 순서와 같다 (카드 → 해당 상세)
    (HomeAssets.paperTube, '종이관', '섬유 제조 · 원단 심'),
    (HomeAssets.zipper, '지퍼 자투리', '의류 봉제 공정'),
    (HomeAssets.bottleCap, '플라스틱 병 뚜껑', '불량 공정'),
    (HomeAssets.cushion, '포장 완충재', '가전 제품 포장'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final columns = Responsive.value(context, desktop: 4, tablet: 2, mobile: 1);

    const heading = SectionHeading(
      title: '소재별 결과를 먼저 확인해 보세요',
      // 해외 실제 사례 안내 문구는 서비스 정책으로 제거 (docs/REQUIREMENTS.md)
      sub: '기업 소재를 가정해 미리 만든 결과입니다.',
    );
    final button = AppButton(
      label: '전체보기',
      onPressed: () => AppHeader.goTo(context, AppRoutes.samples),
    );

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
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              for (var i = 0; i < _samples.length; i++)
                SampleCard(
                  images: _samples[i].$1,
                  name: _samples[i].$2,
                  source: _samples[i].$3,
                  onTap: () => SampleResultPage.openSample(context, i),
                ),
            ];
            // 피그마: 카드 폭 312 고정(이미지 280 + 좌우 15 + 보더), 간격 20, 왼쪽 정렬
            const cardWidth = 312.0;
            const gap = 20.0;
            final fixedRowWidth =
                cardWidth * cards.length + gap * (cards.length - 1);
            if (columns == 4 && constraints.maxWidth >= fixedRowWidth) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: gap),
                    SizedBox(width: cardWidth, child: cards[i]),
                  ],
                ],
              );
            }
            return ResponsiveGrid(columns: columns, children: cards);
          },
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
    this.onTap,
  });

  final List<String> images;
  final String name;
  final String source;
  final VoidCallback? onTap;

  @override
  State<SampleCard> createState() => _SampleCardState();
}

class _SampleCardState extends State<SampleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
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
                    // 피그마 (280 - 4*2) / 3 = 90.67 x 64
                    Expanded(
                      child: _RoundedImage(
                        widget.images[i],
                        aspectRatio: (280 - 8) / 3 / 64,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              Text(widget.name, style: AppTextStyles.title24),
              const SizedBox(height: 10),
              Text(widget.source, style: AppTextStyles.title16),
              // Figma의 '해외 실제 사례 N건' 배지는 서비스 정책으로 제거
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
        child: SizedAssetImage(path),
      ),
    );
  }
}
