import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/design_width.dart';
import '../../../widgets/login_dialog.dart';
import '../../../widgets/responsive.dart';
import '../home_assets.dart';

/// Figma `header` — 높이 110, 좌우 60, 하단 보더 (보더는 화면 끝까지)
/// 태블릿·모바일에서는 메뉴 링크를 숨긴다.
/// 로고 → 메인 홈(맨 위로), 로그인 → 로그인 작은 창
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const _navItems = ['샘플 결과', '이용 방법', '자원랩 소개'];

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final showNav = size == ScreenSize.desktop;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray400)),
      ),
      child: DesignWidth(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.pagePadding(context),
            vertical: Responsive.value<double>(context, desktop: 30, mobile: 16),
          ),
          child: Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _goHome(context),
                  child: SizedBox(
                    width: 94,
                    height: 36,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Semantics(
                        label: '자원도감 홈',
                        button: true,
                        child: Image.asset(HomeAssets.logo, width: 91, height: 24),
                      ),
                    ),
                  ),
                ),
              ),
              if (showNav) ...[
                const SizedBox(width: 32),
                for (var i = 0; i < _navItems.length; i++) ...[
                  if (i > 0) const SizedBox(width: 30),
                  _NavLink(label: _navItems[i]),
                ],
              ],
              const Spacer(),
              _NavLink(
                label: '로그인',
                onTap: () => showLoginDialog(context),
                style: const TextStyle(
                  fontFamily: AppFonts.pretendard,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.gray600,
                ),
              ),
              SizedBox(width: size == ScreenSize.mobile ? 16 : 24),
              AppButton(
                label: size == ScreenSize.mobile ? '소재 등록' : '내 소재 등록하기',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 메인 홈으로: 다른 화면이 쌓여 있으면 첫 화면까지 닫고, 맨 위로 스크롤
  static void _goHome(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }
    final scroll = PrimaryScrollController.maybeOf(context);
    if (scroll != null && scroll.hasClients) {
      scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, this.style, this.onTap});

  final String label;
  final TextStyle? style;
  final VoidCallback? onTap;

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
        onTap: widget.onTap ?? () {},
        child: Text(
          widget.label,
          style: base.copyWith(color: _hovered ? AppColors.gray900 : null),
        ),
      ),
    );
  }
}
