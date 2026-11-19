import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/notch_clipper.dart';

/// "결과가 마음에 드신다면" — 어두운 Contact 배너 (1320 x 314)
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: NotchClipper(
        notchStart: (_) => 248,
        notchEnd: (_) => 314,
        notchDepth: 47,
      ),
      child: Container(
        height: 314,
        color: AppColors.dune,
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 31.5,
              child: Text(
                'Contact',
                style: AppTextStyles.body13.copyWith(color: AppColors.cararra),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '결과가 마음에 드신다면',
                    style: TextStyle(
                      fontFamily: AppFonts.pretendard,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      letterSpacing: -0.56,
                      color: AppColors.screen,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '실제 소재 제공과 교육 활용은 자원랩의 공식 협의 절차로 진행됩니다.\n'
                    '탐색 결과를 저장해 두면 내부 검토와 문의에 그대로 활용할 수 있습니다.',
                    style: AppTextStyles.title18.copyWith(color: AppColors.gray200),
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    label: 'ZAONE LAB  바로가기',
                    variant: AppButtonVariant.light,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
