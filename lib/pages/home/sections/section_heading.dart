import 'package:flutter/material.dart';

import '../../../theme/app_text_styles.dart';
import '../../../widgets/responsive.dart';

/// 섹션 제목 묶음 — eyebrow / title / sub, 간격 14
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.eyebrow,
    this.sub,
  });

  final String? eyebrow;
  final String title;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    final titleSize = Responsive.value<double>(
      context,
      desktop: 40,
      tablet: 32,
      mobile: 24,
    );
    final subSize = Responsive.value<double>(
      context,
      desktop: 22,
      tablet: 18,
      mobile: 15,
    );
    final titleStyle = AppTextStyles.sectionTitle.copyWith(
      fontSize: titleSize,
      letterSpacing: titleSize * -0.02,
    );
    final subStyle = AppTextStyles.sectionSub.copyWith(fontSize: subSize);
    final gap = Responsive.value<double>(context, desktop: 14, mobile: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eyebrow != null) ...[
          Text(eyebrow!, style: subStyle),
          SizedBox(height: gap),
        ],
        Text(title, style: titleStyle),
        if (sub != null) ...[
          SizedBox(height: gap),
          Text(sub!, style: subStyle),
        ],
      ],
    );
  }
}
