import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/design_width.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/login_dialog.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';
import 'widgets/signup_form.dart';

/// Figma `D2 회원가입` (1100:8369) — 주소(/signup)로 바로 들어왔을 때 쓰는 페이지형
///
/// Figma 프로토타입에서는 결과 화면 위 창으로 뜬다 → [showSignupDialog].
/// 카드 562(테두리 gray/100), 내용은 [SignupForm]과 같다.
/// 가입하면 `D2-2 회원가입 후 로그인`처럼 이메일을 채운 로그인 창을 띄우고,
/// 로그인하면 이전 화면으로 돌아간다.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;

    Future<void> login({String? email}) async {
      final navigator = Navigator.of(context);
      final ok = await showLoginDialog(context, initialEmail: email);
      if (!ok) return;
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        navigator.pushReplacementNamed(AppRoutes.home);
      }
    }

    final card = Container(
      constraints: const BoxConstraints(maxWidth: 562),
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 40 : 20,
        40,
        isDesktop ? 40 : 20,
        20,
      ),
      decoration: BoxDecoration(
        color: AppColors.screen,
        border: Border.all(color: AppColors.gray100),
        borderRadius: BorderRadius.circular(2),
      ),
      child: SignupForm(
        onSignedUp: (email) => login(email: email),
        onLogin: login,
      ),
    );

    return PageScaffold(
      bottomGap: 45,
      body: DesignWidth(
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, 15, pad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackBox(),
              // 피그마: 카드 top 153 = 헤더 111 + 15 + 42 - 15
              Transform.translate(
                offset: const Offset(0, -15),
                child: Center(child: card),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 회원가입 창의 결과
sealed class SignupOutcome {
  const SignupOutcome();
}

/// 가입 완료 — 이 이메일로 로그인 창(D2-2)을 연다
final class SignedUp extends SignupOutcome {
  const SignedUp(this.email);
  final String email;
}

/// '이미 계정이 있나요? 로그인'
final class BackToLogin extends SignupOutcome {
  const BackToLogin();
}

/// Figma `D2 회원가입` 창 (1100:8485) — 562, 테두리 gray/100, 안쪽 40 · 40 · 20
///
/// 창 밖을 누르면 닫히고 null을 돌려준다.
Future<SignupOutcome?> showSignupDialog(BuildContext context) =>
    showDialog<SignupOutcome>(
      context: context,
      barrierColor: const Color(0x8C0F1115),
      builder: (dialogContext) {
        final isMobile = Responsive.of(dialogContext) == ScreenSize.mobile;
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 562),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.screen,
                border: Border.all(color: AppColors.gray100),
                borderRadius: BorderRadius.circular(2),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 19 : 39,
                  39,
                  isMobile ? 19 : 39,
                  19,
                ),
                child: SignupForm(
                  onSignedUp: (email) =>
                      Navigator.of(dialogContext).pop(SignedUp(email)),
                  onLogin: () =>
                      Navigator.of(dialogContext).pop(const BackToLogin()),
                ),
              ),
            ),
          ),
        );
      },
    );
