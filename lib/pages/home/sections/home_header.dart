import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../home_assets.dart';

/// Figma `header` — 높이 110, 좌우 60, 하단 보더
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const _navItems = ['샘플 결과', '이용 방법', '자원랩 소개'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray400)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 94,
            height: 36,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(HomeAssets.logo, width: 91, height: 24),
            ),
          ),
          const SizedBox(width: 32),
          for (var i = 0; i < _navItems.length; i++) ...[
            if (i > 0) const SizedBox(width: 30),
            _NavLink(label: _navItems[i]),
          ],
          const Spacer(),
          const _NavLink(
            label: '로그인',
            style: TextStyle(
              fontFamily: AppFonts.pretendard,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(width: 24),
          AppButton(label: '내 소재 등록하기', onPressed: () {}),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, this.style});

  final String label;
  final TextStyle? style;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final base =
        widget.style ?? AppTextStyles.title18.copyWith(color: AppColors.gray400);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          widget.label,
          style: base.copyWith(color: _hovered ? AppColors.gray900 : null),
        ),
      ),
    );
  }
}
