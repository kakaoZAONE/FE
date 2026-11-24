import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/external_links.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/notch_clipper.dart';
import '../../../widgets/responsive.dart';

/// ZAONE LAB 문의 — 어두운 Contact 배너 (데스크톱 1320 x 314)
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final pad = isMobile ? 20.0 : 32.0;

    return ClipPath(
      // 피그마 마스크 path: M0 0 H248.032 L315.097 47.4068 H1320
      // 좁은 화면에서도 사선이 화면 안에 들어오도록 시작점을 제한
      clipper: NotchClipper(
        notchStart: (s) => math.min(248.032, s.width * 0.45),
        notchEnd: (s) => math.min(248.032, s.width * 0.45) + 67.065,
        notchDepth: 47.4068,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 314),
        color: AppColors.dune,
        // 피그마: Contact 라벨 top 31.5 (absolute), 본문 위 95 / 아래 32
        child: Stack(
          children: [
            Positioned(
              left: pad,
              top: 31.5,
              child: Text(
                'Contact',
                style: AppTextStyles.body13.copyWith(color: AppColors.cararra),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 95, pad, 32),
              child: _body(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '마음에 드는 소재를 발견하셨나요? ZAONE LAB에 문의해 보세요.',
          style: TextStyle(
            fontFamily: AppFonts.pretendard,
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 22 : 28,
            height: AppTextStyles.pretendardNormal,
            letterSpacing: isMobile ? -0.44 : -0.56,
            color: AppColors.screen,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '실제 소재 제공과 교육 활용은 자원랩의 공식 협의 절차로 진행됩니다.\n'
          '탐색 결과를 저장해 두면 내부 검토와 문의에 그대로 활용할 수 있습니다.',
          style: AppTextStyles.title18.copyWith(
            color: AppColors.gray200,
            fontSize: isMobile ? 15 : 18,
            height: isMobile ? 22 / 15 : 25 / 18,
          ),
        ),
        SizedBox(height: isMobile ? 28 : 40),
        AppButton(
          label: 'ZAONE LAB  바로가기',
          variant: AppButtonVariant.light,
          onPressed: () => ExternalLinks.open(ExternalLinks.zaoneLab),
        ),
      ],
    );
  }
}
