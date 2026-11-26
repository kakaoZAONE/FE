import 'package:flutter/material.dart';

import '../features/auth/auth_state.dart';
import '../features/auth/signup_page.dart';
import '../theme/app_colors.dart';
import 'form_widgets.dart';

/// Figma `D1 로그인` 창 (1100:8026 · D1-1 입력 · D1-2 오류 · D1-3 완료)
///
/// 폭 562, 안쪽 위 40 · 좌우 40 · 아래 20, 요소 간격 40, dim rgba(15,17,21,0.55).
/// 이메일·비밀번호를 다 입력해야 [로그인]이 켜진다(그 전에는 30% 불투명).
/// 로그인에 성공하면 true를 돌려준다.
///
/// - [title]: 결과 저장에서 열 때 '결과를 저장하려면 로그인해 주세요' (1100:8260)
/// - '계정 만들기' → 회원가입 창(D2) → 가입하면 이메일을 채운 로그인 창(D2-2)으로 돌아온다.
///   그 로그인까지 성공해야 true — 저장하기처럼 로그인 뒤 이어지는 동작이 끊기지 않는다.
Future<bool> showLoginDialog(
  BuildContext context, {
  String title = '로그인',
  String? initialEmail,
}) async {
  var email = initialEmail;
  var heading = title;
  while (true) {
    if (!context.mounted) return false;
    final result = await showDialog<_LoginOutcome>(
      context: context,
      barrierColor: const Color(0x8C0F1115),
      builder: (_) => _LoginDialog(title: heading, initialEmail: email),
    );
    if (result != _LoginOutcome.signup || !context.mounted) {
      return result == _LoginOutcome.signedIn;
    }
    final signup = await showSignupDialog(context);
    switch (signup) {
      case SignedUp(email: final created):
        // D2-2 회원가입 후 로그인: 제목 '로그인', 이메일 채움
        email = created;
        heading = '로그인';
      case BackToLogin():
        break;
      case null:
        return false;
    }
  }
}

enum _LoginOutcome { signedIn, signup }

class _LoginDialog extends StatefulWidget {
  const _LoginDialog({required this.title, this.initialEmail});

  final String title;
  final String? initialEmail;

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  late final _email = TextEditingController(text: widget.initialEmail);
  final _password = TextEditingController();
  String? _error;
  bool _busy = false;

  bool get _filled =>
      _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_filled || _busy) return;
    setState(() => _busy = true);
    final error = await AuthState.instance.signIn(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _busy = false;
        _error = error;
      });
      return;
    }
    Navigator.of(context).pop(_LoginOutcome.signedIn);
  }

  void _kakao() {
    // TODO(API): 카카오 OAuth 연동 전 — 안내만 표시 (docs/API.md)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('카카오 로그인은 준비 중이에요')));
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _error != null;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 562),
        child: Container(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
          decoration: BoxDecoration(
            color: AppColors.screen,
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1742475B),
                offset: Offset(0, 18),
                blurRadius: 22.5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    letterSpacing: -0.48,
                    color: Color(0xFF040404),
                  ),
                ),
                const SizedBox(height: 40),
                LabeledInput(
                  label: '이메일',
                  hint: 'zaone@company.com',
                  controller: _email,
                  autofocus: widget.initialEmail == null,
                  error: hasError,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() => _error = null),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 10),
                LabeledInput(
                  label: '비밀번호',
                  hint: '8자 이상 숫자 입력',
                  controller: _password,
                  autofocus: widget.initialEmail != null,
                  obscure: true,
                  error: hasError,
                  onChanged: (_) => setState(() => _error = null),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 30),
                KakaoButton(onPressed: _kakao),
                if (hasError) ...[
                  const SizedBox(height: 20),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      letterSpacing: -0.26,
                      color: kErrorColor,
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                // 버튼 줄: 위 24 (Figma pt-24), 사이 8
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: FillButton(
                          label: '취소',
                          muted: true,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FillButton(
                          label: '로그인',
                          onPressed: _filled && !hasError ? _submit : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: InlineLinkRow(
                    text: '처음이신가요?',
                    link: '계정 만들기',
                    onTap: () =>
                        Navigator.of(context).pop(_LoginOutcome.signup),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
