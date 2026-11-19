import 'package:flutter/material.dart';

import '../../../theme/app_text_styles.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eyebrow != null) ...[
          Text(eyebrow!, style: AppTextStyles.sectionSub),
          const SizedBox(height: 14),
        ],
        Text(title, style: AppTextStyles.sectionTitle),
        if (sub != null) ...[
          const SizedBox(height: 14),
          Text(sub!, style: AppTextStyles.sectionSub),
        ],
      ],
    );
  }
}
