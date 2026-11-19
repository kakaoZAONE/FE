import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Figma 1.1 main 타이포그래피 토큰
abstract final class AppFonts {
  static const pretendard = 'Pretendard';
  static const suite = 'SUITE';
  static const notoSansKr = 'NotoSansKR';
}

abstract final class AppTextStyles {
  // title/40_bold — 섹션 제목
  static const sectionTitle = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w700,
    fontSize: 40,
    letterSpacing: -0.8,
    color: AppColors.gray900,
  );

  // body/22_med — 섹션 부제
  static const sectionSub = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w500,
    fontSize: 22,
    color: AppColors.gray600,
  );

  // title/24_semibold
  static const title24 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    letterSpacing: -0.48,
    color: AppColors.gray900,
  );

  // title/18_semibold
  static const title18 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 25 / 18,
    letterSpacing: -0.72,
  );

  // title/16_semibold
  static const title16 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.32,
    color: AppColors.gray800,
  );

  // title/15_med
  static const body15 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: AppColors.gray900,
  );

  // body/13_reg
  static const body13 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    letterSpacing: -0.26,
    color: AppColors.gray800,
  );

  // hero 제목 — SUITE Bold 48
  static const heroTitle = TextStyle(
    fontFamily: AppFonts.suite,
    fontWeight: FontWeight.w700,
    fontSize: 48,
    height: 1.25,
    letterSpacing: -1.44,
    color: AppColors.screen,
  );
}
