import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Figma `4.2 로그인` — 로그인 작은 창
///
/// 배경 dim rgba(15,17,21,0.55), 창 폭 418, 아래에 [나가기] [로그인] 버튼.
/// 아직 서버 연동 전이라 로그인을 누르면 입력 확인 후 안내만 띄운다.
Future<void> showLoginDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0x8C0F1115),
    builder: (_) => const _LoginDialog(),
  );
}

class _LoginDialog extends StatefulWidget {
  const _LoginDialog();

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  final _company = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _company.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_company.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = '기업명과 비밀번호를 모두 입력해 주세요');
      return;
    }
    // TODO: 로그인 API 연결
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(const SnackBar(content: Text('로그인 기능은 준비 중이에요')));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 418),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: AppColors.screen,
                border: Border.all(color: AppColors.gray900),
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2E000000),
                    offset: Offset(0, 20),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '로그인',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.pretendard,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      letterSpacing: -0.48,
                      color: Color(0xFF040404),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _LabeledField(
                    label: '기업명',
                    hint: '기업명을 입력해 주세요',
                    controller: _company,
                    autofocus: true,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 30),
                  _LabeledField(
                    label: '비밀번호',
                    hint: '비밀번호를 입력해 주세요',
                    controller: _password,
                    obscure: true,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _error ?? '샘플 탐색은 로그인 없이 이용할 수 있어요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.pretendard,
                      fontSize: 13,
                      letterSpacing: -0.65,
                      color: _error != null
                          ? const Color(0xFFE00052)
                          : const Color(0xFF62656D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: '나가기',
                    variant: AppButtonVariant.light,
                    foregroundColor: AppColors.gray400,
                    expand: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: '로그인',
                    expand: true,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma `input` — 라벨 13 + 입력칸 높이 45, 보더 #D9DCE1, radius 4
class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.autofocus = false,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: Color(0xFFD9DCE1)),
  );

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: AppFonts.pretendard,
      fontSize: 15,
      letterSpacing: -0.3,
      color: AppColors.gray900,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body13.copyWith(color: AppColors.gray900),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            obscureText: obscure,
            autofocus: autofocus,
            onSubmitted: onSubmitted,
            style: textStyle,
            cursorColor: AppColors.gray900,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: textStyle.copyWith(color: AppColors.gray400),
              filled: true,
              fillColor: const Color(0x7AFFFFFF),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              border: _border,
              enabledBorder: _border,
              focusedBorder: _border.copyWith(
                borderSide: const BorderSide(color: AppColors.gray900),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
