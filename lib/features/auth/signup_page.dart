import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/design_width.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/login_dialog.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';
import 'auth_state.dart';

/// Figma `D2 회원가입` (1100:8369)
///
/// 가운데 카드 562(테두리 gray/100) — 이름 · 이메일 · 비밀번호 · 필수 동의 → 카카오 / 가입.
/// 가입하면 `D2-2 회원가입 후 로그인` 처럼 로그인된 상태로 이전 화면에 돌아간다.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _agreed = false;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _ready =>
      _agreed &&
      _name.text.trim().isNotEmpty &&
      _email.text.trim().isNotEmpty &&
      _password.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_ready || _busy) return;
    setState(() => _busy = true);
    final error = await AuthState.instance.signUp(
      name: _name.text,
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
    if (error == null) {
      final navigator = Navigator.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가입이 완료되어 로그인되었어요')),
      );
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        navigator.pushReplacementNamed(AppRoutes.home);
      }
    }
  }

  void _clearError(String _) {
    setState(() => _error = null);
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '계정 만들기',
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
          LabeledInput(
            label: '성함 또는 담당자명',
            hint: '예) 김자원',
            controller: _name,
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
          _AgreeRow(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v),
            onDetail: () =>
                Navigator.of(context).pushNamed(AppRoutes.serviceInfo),
          ),
          const SizedBox(height: 30),
          KakaoButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('카카오 로그인은 준비 중이에요')),
            ),
          ),
          const SizedBox(height: 10),
          FillButton(label: '가입하고 시작하기', onPressed: _ready ? _submit : null),
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
          const SizedBox(height: 24),
          Center(
            child: InlineLinkRow(
              text: '이미 계정이 있나요?',
              link: '로그인',
              onTap: () async {
                final navigator = Navigator.of(context);
                final ok = await showLoginDialog(context);
                if (ok && navigator.canPop()) navigator.pop();
              },
            ),
          ),
        ],
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

/// 체크박스 + '(필수)' 동의 문구 + 서비스안내 링크
class _AgreeRow extends StatelessWidget {
  const _AgreeRow({
    required this.value,
    required this.onChanged,
    required this.onDetail,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  border: Border.all(color: AppColors.gray900),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: value
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => onChanged(!value),
                child: Text(
                  '서비스 이용 안내와 AI·데이터 처리 안내에 동의합니다.(필수)',
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray900,
                    height: 22 / 14,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onDetail,
                  child: Text(
                    '자세한 내용은 서비스안내 페이지에서 확인할 수 있습니다. >',
                    style: AppTextStyles.body13.copyWith(
                      fontSize: 10,
                      color: AppColors.gray400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
