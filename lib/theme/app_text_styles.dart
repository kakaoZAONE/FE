import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Figma 1.1 main 타이포그래피 토큰
abstract final class AppFonts {
  static const pretendard = 'Pretendard';
  static const suite = 'SUITE';
  static const notoSansKr = 'NotoSansKR';
}

abstract final class AppTextStyles {
  /// Figma 줄 높이 'normal'(자동) = Pretendard 폰트 메트릭 (1950 + 494) / 2048.
  /// 지정하지 않으면 Flutter가 대체 폰트 높이를 섞어 Figma보다 커질 수 있다.
  static const pretendardNormal = 2444 / 2048;

  // title/40_bold — 섹션 제목
  static const sectionTitle = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w700,
    fontSize: 40,
    height: pretendardNormal,
    letterSpacing: -0.8,
    color: AppColors.gray900,
  );

  // body/22_med — 섹션 부제
  static const sectionSub = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w500,
    fontSize: 22,
    height: pretendardNormal,
    color: AppColors.gray600,
  );

  // title/24_semibold
  static const title24 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: pretendardNormal,
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
    height: pretendardNormal,
    letterSpacing: 0.32,
    color: AppColors.gray800,
  );

  // title/15_med
  static const body15 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: pretendardNormal,
    color: AppColors.gray900,
  );

  // body/13_reg
  static const body13 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: pretendardNormal,
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
