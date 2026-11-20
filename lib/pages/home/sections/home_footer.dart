import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/design_width.dart';
import '../../../widgets/responsive.dart';

/// Figma `Footer` — 모바일에서는 좌우 블록을 세로로 쌓는다.
class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  static const _base = TextStyle(fontFamily: AppFonts.notoSansKr);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.footerBorder)),
      ),
      child: DesignWidth(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.value<double>(
              context,
              desktop: 120,
              tablet: 40,
              mobile: 20,
            ),
            48,
            Responsive.value<double>(
              context,
              desktop: 120,
              tablet: 40,
              mobile: 20,
            ),
            56,
          ),
          child: Responsive.of(context) == ScreenSize.mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _brand(),
                    const SizedBox(height: 24),
                    _links(CrossAxisAlignment.start),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 폭이 모자라면 양쪽 블록 모두 줄바꿈 (넉넉하면 원래 크기)
                    Flexible(child: _brand()),
                    const SizedBox(width: 24),
                    Flexible(child: _links(CrossAxisAlignment.end)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _brand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ZAONE',
              style: _base.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 17,
                height: 1.1,
                letterSpacing: 0.51,
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.gray900,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'LAB',
                style: _base.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 1, height: 14, color: AppColors.footerDivider),
            const SizedBox(width: 10),
            Text(
              '열린 설명서',
              style: _base.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1.2,
                letterSpacing: -0.225,
                color: AppColors.gray900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          '자원(ZAONE) × Re:play· 카카오임팩트 Tech for Impact',
          style: _base.copyWith(
            fontSize: 13,
            height: 1.5,
            letterSpacing: -0.195,
            color: AppColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _links(CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            for (final label in const ['이용약관', '개인정보처리방침', '자원랩 공식 문의'])
              _FooterLink(label: label, style: _base),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'AI가 생성한 장면은 가상의 예시이며 실제 사용 적합성은 별도 검토가 필요합니다.',
          textAlign: align == CrossAxisAlignment.end
              ? TextAlign.right
              : TextAlign.left,
          style: _base.copyWith(
            fontSize: 12,
            height: 1.5,
            letterSpacing: -0.18,
            color: AppColors.gray400,
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.style});

  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          label,
          style: style.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            height: 1.5,
            letterSpacing: -0.195,
            color: AppColors.gray700,
          ),
        ),
      ),
    );
  }
}
