import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 검정 사각 번호/이름 표시 — 패딩 10, 글자 24 Regular, 줄 높이 25
/// 예: 01 · 02 · ZAONE
class NumberTag extends StatelessWidget {
  const NumberTag(this.label, {super.key, this.fontFamily});

  final String label;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.gray900,
        border: Border.all(color: AppColors.gray900),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: fontFamily ?? AppFonts.pretendard,
          fontWeight: FontWeight.w400,
          fontSize: 24,
          height: 25 / 24,
          color: AppColors.screen,
        ),
      ),
    );
  }
}

/// 왼쪽 1px 세로선(gray/300)이 있는 설명 카드 본문
/// 기본: 위 20, 아래 50, 좌우 10, 요소 간격 15
class LeftRuleCard extends StatelessWidget {
  const LeftRuleCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(10, 20, 10, 50),
    this.gap = 15,
    this.height,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double gap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: padding,
      decoration: const BoxDecoration(
        color: AppColors.screen,
        border: Border(left: BorderSide(color: AppColors.gray300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// title/24_semibold + body/15_med(줄 높이 20) 조합에서 쓰는 본문 스타일
abstract final class CardText {
  static const title24 = AppTextStyles.title24;
  static const body15 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 20 / 15,
    color: AppColors.gray900,
  );
}
