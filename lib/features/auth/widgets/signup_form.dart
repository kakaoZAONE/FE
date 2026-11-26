import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/form_widgets.dart';
import '../auth_state.dart';

/// Figma `D2 회원가입` 카드 내용 (1100:8485)
///
/// 제목 24 → 40 → [기업명 · 이메일 · 비밀번호(사이 10) → 30 → 필수 동의] → 40
/// → [카카오 57 · 15 · 가입하고 시작하기 57] → 40 → '이미 계정이 있나요? 로그인'
///
/// 가입에 성공하면 [onSignedUp]에 이메일을 넘긴다(D2-2: 로그인 창에 이메일을 채워 연다).
class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.onSignedUp,
    required this.onLogin,
  });

  final ValueChanged<String> onSignedUp;
  final VoidCallback onLogin;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _company = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _agreed = false;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _company.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _ready =>
      _agreed &&
      _company.text.trim().isNotEmpty &&
      _email.text.trim().isNotEmpty &&
      _password.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_ready || _busy) return;
    setState(() => _busy = true);
    final error = await AuthState.instance.signUp(
      name: _company.text,
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
    if (error == null) widget.onSignedUp(_email.text.trim());
  }

  void _clearError(String _) => setState(() => _error = null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '계정 만들기',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.pretendard,
            fontWeight: FontWeight.w600,
            fontSize: 24,
            height: AppTextStyles.pretendardNormal,
            letterSpacing: -0.48,
            color: Color(0xFF040404),
          ),
        ),
        const SizedBox(height: 40),
        LabeledInput(
          label: '기업명',
          hint: '예) 자원',
          controller: _company,
          error: _error != null && _error!.contains('기업명'),
          onChanged: _clearError,
        ),
        const SizedBox(height: 10),
        LabeledInput(
          label: '이메일',
          hint: 'zaone@company.com',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          error: _error != null && _error!.contains('이메일'),
          onChanged: _clearError,
        ),
        const SizedBox(height: 10),
        LabeledInput(
          label: '비밀번호',
          hint: '8자 이상 숫자 입력',
          controller: _password,
          obscure: true,
          error: _error != null && _error!.contains('비밀번호'),
          onChanged: _clearError,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 30),
        AgreeRow(
          value: _agreed,
          onChanged: (v) => setState(() => _agreed = v),
          onDetail: () =>
              Navigator.of(context).pushNamed(AppRoutes.serviceInfo),
        ),
        const SizedBox(height: 40),
        KakaoButton(
          // TODO(API): 카카오 OAuth 연동 전 — 안내만 표시 (docs/API.md)
          onPressed: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('카카오 로그인은 준비 중이에요'))),
        ),
        const SizedBox(height: 15),
        FillButton(
          label: '가입하고 시작하기',
          height: 57,
          onPressed: _ready ? _submit : null,
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.pretendard,
              fontSize: 13,
              letterSpacing: -0.26,
              color: kErrorColor,
            ),
          ),
        ],
        const SizedBox(height: 40),
        Center(
          child: InlineLinkRow(
            text: '이미 계정이 있나요?',
            link: '로그인',
            onTap: widget.onLogin,
          ),
        ),
      ],
    );
  }
}

/// 필수 동의 줄 (Figma 1100:8582) — 위 5, 체크 상자 22(검정 1px, radius 5, 안쪽 2) · 5 ·
/// 동의 문구 14 Noto Medium + 5 + 서비스안내 링크 10 gray/400
class AgreeRow extends StatelessWidget {
  const AgreeRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onDetail,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            checked: value,
            label: '서비스 이용 안내와 AI·데이터 처리 안내 동의',
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: value ? AppColors.gray900 : AppColors.screen,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: value
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => onChanged(!value),
                  child: const Text(
                    '서비스 이용 안내와 AI·데이터 처리 안내에 동의합니다.(필수)',
                    style: TextStyle(
                      fontFamily: AppFonts.notoSansKr,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.4,
                      letterSpacing: -0.21,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onDetail,
                    child: Text(
                      '자세한 내용은 서비스안내 페이지에서 확인할 수 있습니다.>',
                      style: AppTextStyles.body13.copyWith(
                        fontSize: 10,
                        letterSpacing: 0,
                        color: AppColors.gray400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
