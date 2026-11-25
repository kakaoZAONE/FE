import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../features/auth/auth_state.dart';
import '../pages/home/home_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';
import 'design_width.dart';
import 'login_dialog.dart';
import 'responsive.dart';

/// Figma `header` 컴포넌트 (최종 1.1 main 775:1124) — 모든 페이지 공통
///
/// 데스크톱: 높이 110 (상하 30 + 버튼 50), 좌우 60, 하단 보더 gray/400.
///   [로고] 80 [샘플 둘러보기 · 이용 안내 · 자원랩 소개] ······ [Log in] 24 [내 소재 등록하기]
/// 1200 미만: 메뉴를 로고 줄 아래 한 줄로 내린다 (모바일 Figma 없음, docs/FIGMA.md).
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  /// 이 폭 미만에서는 메뉴를 두 번째 줄로 내린다.
  static const singleRowMinWidth = 1200.0;

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    // 한 줄 헤더(로고·메뉴·버튼)는 약 1100px가 필요해서 1200 이상에서만 쓴다.
    final isDesktop = MediaQuery.sizeOf(context).width >= singleRowMinWidth;
    final pad = Responsive.pagePadding(context);

    final logo = _Logo(onTap: () => goHome(context));
    // 로그인 전: [Log in] / 로그인 후: [내 탐색기록] (Figma C1-1 · C2_b-1)
    final actions = ListenableBuilder(
      listenable: AuthState.instance,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthState.instance.isSignedIn
              ? AppButton(
                  label: size == ScreenSize.mobile ? '기록' : '내 탐색기록',
                  variant: AppButtonVariant.outline,
                  onPressed: () => goTo(context, AppRoutes.history),
                )
              : AppButton(
                  label: 'Log in',
                  variant: AppButtonVariant.outline,
                  onPressed: () => showLoginDialog(context),
                ),
          SizedBox(width: size == ScreenSize.mobile ? 8 : 24),
          AppButton(
            label: size == ScreenSize.mobile ? '소재 등록' : '내 소재 등록하기',
            onPressed: () => goTo(context, AppRoutes.register),
          ),
        ],
      ),
    );
    final nav = _NavLinks(compact: !isDesktop);

    // 보더는 foregroundDecoration으로 안쪽에 그려 높이를 110(30+50+30)으로 유지
    return Container(
      color: AppColors.screen,
      foregroundDecoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray400)),
      ),
      child: DesignWidth(
        child: isDesktop
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: pad, vertical: 30),
                child: Row(
                  children: [
                    logo,
                    const SizedBox(width: 80),
                    nav,
                    const Spacer(),
                    const SizedBox(width: 24),
                    actions,
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(pad, 16, pad, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        logo,
                        const SizedBox(width: 16),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            // 아주 좁은 화면에서도 넘치지 않게 축소
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: actions,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 메뉴 첫 글자를 로고와 맞추기 위해 링크 안쪽 여백(10)만큼 당김
                    Transform.translate(
                      offset: const Offset(-10, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: nav,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// 메인 홈으로: 다른 화면이 쌓여 있으면 첫 화면까지 닫고, 메인이면 맨 위로 스크롤
  static void goHome(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }
    if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
      navigator.pushReplacementNamed(AppRoutes.home);
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

  /// 해당 경로 화면으로 이동. 이미 그 화면이면 아무것도 하지 않는다.
  static void goTo(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name == route) return;
    Navigator.of(context).pushNamed(route);
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '자원도감 홈',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          // 피그마: 로고 칸 94 x 36
          child: SizedBox(
            width: 94,
            height: 36,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(HomeAssets.logo, width: 91, height: 24),
            ),
          ),
        ),
      ),
    );
  }
}

/// 메뉴 3개 — 칸마다 안쪽 여백 10, 사이 30
class _NavLinks extends StatelessWidget {
  const _NavLinks({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[
      ('샘플 둘러보기', AppRoutes.samples),
      ('이용 안내', AppRoutes.guide),
      ('자원랩 소개', AppRoutes.about),
    ];
    // 메뉴 화면에 있으면 그 메뉴만 진하게(gray/800), 나머지는 gray/300 (Figma A3·A4)
    final current = ModalRoute.of(context)?.settings.name;
    final onMenuPage = items.any((e) => e.$2 == current);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: compact ? 4 : 30),
          _NavLink(
            label: items[i].$1,
            onTap: () => AppHeader.goTo(context, items[i].$2),
            compact: compact,
            dimmed: onMenuPage && items[i].$2 != current,
          ),
        ],
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    this.onTap,
    this.compact = false,
    this.dimmed = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool compact;
  final bool dimmed;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final style = AppTextStyles.title18.copyWith(
      fontSize: widget.compact ? 15 : 18,
      color: _hovered
          ? AppColors.gray900
          : (widget.dimmed ? AppColors.gray300 : AppColors.gray800),
    );
    return Semantics(
      link: true,
      enabled: enabled,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: enabled ? (_) => setState(() => _hovered = false) : null,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(widget.label, style: style),
          ),
        ),
      ),
    );
  }
}
