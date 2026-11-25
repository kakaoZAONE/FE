import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'notch_clipper.dart';
import 'responsive.dart';

/// 우측 상단이 사선으로 꺾인 배너 (Figma Contact / Login 배너, 1320 x 314)
///
/// - [dark]   : Dune 배경 + 밝은 글자 (메인 Contact)
/// - 기본     : gray/50 배경 + 진한 글자 (이용안내 Login, 자원랩 소개 Contact)
class NotchBanner extends StatelessWidget {
  const NotchBanner({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.action,
    this.dark = false,
  });

  final String eyebrow;
  final String title;
  final String body;
  final Widget action;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final pad = isMobile ? 20.0 : 32.0;
    final fg = dark ? AppColors.screen : AppColors.gray900;

    return ClipPath(
      // 피그마 마스크 path: M0 0 H248.032 L315.097 47.4068 H1320
      clipper: NotchClipper(
        notchStart: (s) => math.min(248.032, s.width * 0.45),
        notchEnd: (s) => math.min(248.032, s.width * 0.45) + 67.065,
        notchDepth: 47.4068,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 314),
        color: dark ? AppColors.dune : AppColors.gray50,
        child: Stack(
          children: [
            Positioned(
              left: pad,
              top: 31.5,
              child: Text(
                eyebrow,
                style: AppTextStyles.body13.copyWith(
                  color: dark ? AppColors.cararra : AppColors.gray900,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 95, pad, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.pretendard,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 22 : 28,
                      height: AppTextStyles.pretendardNormal,
                      letterSpacing: isMobile ? -0.44 : -0.56,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    body,
                    style: AppTextStyles.title18.copyWith(
                      color: dark ? AppColors.gray200 : AppColors.gray900,
                      fontSize: isMobile ? 15 : 18,
                      height: isMobile ? 22 / 15 : 25 / 18,
                    ),
                  ),
                  SizedBox(height: isMobile ? 28 : 40),
                  action,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
