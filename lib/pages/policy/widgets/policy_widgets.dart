import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// A5 데이터 처리 안내 전용 색 · 글꼴.
///
/// 이 화면만 Noto Sans KR 와 별도 색(보라 번호, 연노랑 안내)을 쓴다. Figma(982:5234) 그대로.
abstract final class PolicyStyle {
  static const ink = Color(0xFF1A1C1F);
  static const muted = Color(0xFF636B73);
  static const subtle = Color(0xFF697078);
  static const purple = Color(0xFF633DC7);
  static const cardBg = Color(0xFFF4F6F7);
  static const summaryBg = Color(0xFFF5F6F7);
  static const noticeBg = Color(0xFFF9F5E9);
  static const rule = Color(0xFFDEE0E3);
  static const summaryRule = Color(0xFFDEE3E5);

  static TextStyle noto(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.gray900,
  }) => TextStyle(
    fontFamily: AppFonts.notoSansKr,
    fontWeight: weight,
    fontSize: size,
    // Figma의 Noto Sans KR 'normal' 줄 높이 ≈ 1.2 (47px 제목 줄 간격 56).
    // Flutter 기본(폰트 지표 1.448)으로 두면 여러 줄 글이 Figma보다 길어진다.
    height: 1.2,
    color: color,
  );
}

/// Figma 글상자처럼 고정 높이 칸을 잡는다(글이 길어지면 늘어남).
///
/// A5는 모든 요소가 절대 좌표로 놓여 있어서, 칸 높이 = 다음 요소 top - 이 요소 top.
class PolicySlot extends StatelessWidget {
  const PolicySlot({super.key, required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Align(alignment: Alignment.topLeft, child: child),
    );
  }
}

/// 이용 원칙 요약 (982:5277) — 493 x 223, #F5F6F7, radius 14
///
/// 줄 top: 32 · 97 · 162, 구분선: 75 · 140 (left 31, 폭 420), 번호 left 32 · 글 left 86
class PolicySummary extends StatelessWidget {
  const PolicySummary({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 223),
      padding: const EdgeInsets.fromLTRB(31, 32, 42, 18),
      decoration: BoxDecoration(
        color: PolicyStyle.summaryBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) ...[
              const Divider(
                height: 1,
                thickness: 1,
                color: PolicyStyle.summaryRule,
              ),
              const SizedBox(height: 21),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 43),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: SizedBox(
                      width: 53,
                      child: Text(
                        (i + 1).toString().padLeft(2, '0'),
                        style: PolicyStyle.noto(
                          18,
                          weight: FontWeight.w700,
                          color: PolicyStyle.purple,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      items[i],
                      style: PolicyStyle.noto(
                        17,
                        weight: FontWeight.w500,
                        color: PolicyStyle.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 운영 정책 확인 필요 (982:5236) — 높이 119, #F9F5E9, radius 12, 제목 top 22 · 본문 top 62
class PolicyNotice extends StatelessWidget {
  const PolicyNotice({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 119),
      padding: const EdgeInsets.fromLTRB(25, 22, 25, 14),
      decoration: BoxDecoration(
        color: PolicyStyle.noticeBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PolicySlot(
            height: 40,
            child: Text(
              title,
              style: PolicyStyle.noto(20, weight: FontWeight.w700),
            ),
          ),
          Text(body, style: PolicyStyle.noto(17, color: PolicyStyle.muted)),
        ],
      ),
    );
  }
}

/// 정책 안내 카드 (982:5240) — 622 x 193, #F4F6F7, radius 12, 제목 top 22 · 본문 top 87
class PolicyCard extends StatelessWidget {
  const PolicyCard({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 193),
      padding: const EdgeInsets.fromLTRB(24, 22, 33, 22),
      decoration: BoxDecoration(
        color: PolicyStyle.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PolicySlot(
            height: 65,
            child: Text(
              title,
              style: PolicyStyle.noto(22, weight: FontWeight.w700),
            ),
          ),
          Text(body, style: PolicyStyle.noto(17, color: PolicyStyle.muted)),
        ],
      ),
    );
  }
}

/// 데이터 흐름 안내 (982:5253) — 1280 x 274, radius 14
///
/// 줄 top 27부터 56 간격, 구분선은 줄 top + 45 (left 25, 오른쪽 30). 이름 left 26 · 값 left 262.
class PolicyDataTable extends StatelessWidget {
  const PolicyDataTable({super.key, required this.rows, this.stacked = false});

  final List<(String, String)> rows;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 274),
      padding: const EdgeInsets.fromLTRB(25, 27, 30, 34),
      decoration: BoxDecoration(
        color: PolicyStyle.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) ...[
              const Divider(height: 1, thickness: 1, color: PolicyStyle.rule),
              const SizedBox(height: 10),
            ],
            _row(rows[i]),
          ],
        ],
      ),
    );
  }

  Widget _row((String, String) row) {
    final label = Text(
      row.$1,
      style: PolicyStyle.noto(17, weight: FontWeight.w700),
    );
    final value = Text(
      row.$2,
      style: PolicyStyle.noto(17, color: PolicyStyle.muted),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 45),
      child: Padding(
        padding: const EdgeInsets.only(left: 1, bottom: 6),
        child: stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [label, const SizedBox(height: 4), value],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 236, child: label),
                  Expanded(child: value),
                ],
              ),
      ),
    );
  }
}

/// 검정 CTA (982:5266) — 높이 58, radius 9, 글자 17 Bold 왼쪽 21
class PolicyCta extends StatelessWidget {
  const PolicyCta({
    super.key,
    required this.label,
    required this.width,
    this.onTap,
  });

  final String label;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: 58,
            padding: const EdgeInsets.only(left: 21),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.gray900,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              label,
              style: PolicyStyle.noto(
                17,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
