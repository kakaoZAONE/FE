import 'package:flutter/material.dart';

import '../pages/home/home_assets.dart';
import 'design_width.dart';
import 'responsive.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const _navItems = ['샘플 결과', '이용 방법', '자원랩 소개'];
  static const _ink = Color(0xFF1B1D21);
  static const _muted = Color(0xFF6B7078);

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final showNav = size == ScreenSize.desktop;

    return Container(
      color: Colors.white,
      foregroundDecoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE3E5E8))),
      ),
      child: DesignWidth(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.pagePadding(context),
            vertical: size == ScreenSize.desktop ? 30 : 16,
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
                        child: Image.asset(
                          HomeAssets.logo,
                          width: 91,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (showNav) ...[
                const SizedBox(width: 32),
                for (var i = 0; i < _navItems.length; i++) ...[
                  if (i > 0) const SizedBox(width: 30),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 64),
                    child: _NavLink(label: _navItems[i]),
                  ),
                ],
              ],
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavLink(
                          label: '로그인',
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: size == ScreenSize.mobile ? 16 : 24),
                        _RegisterButton(
                          label: size == ScreenSize.mobile
                              ? '소재 등록'
                              : '내 소재 등록하기',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        widget.style ??
        const TextStyle(
          color: HomeHeader._muted,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Text(
        widget.label,
        style: base.copyWith(color: _hovered ? HomeHeader._ink : base.color),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      color: HomeHeader._ink,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
