import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';

const kErrorColor = Color(0xFFE00052);

/// Figma `input` 테두리 (507:3287)
const kInputBorderColor = Color(0xFFD9DCE1);

/// Figma `input` 컴포넌트(506:3233 · 507:3287) — 라벨 13 / 간격 10 / 입력칸 높이 45, radius 4
///
/// 글자·힌트 15 Regular(자간 -2%). 테두리: 기본 #D9DCE1, 입력 중 gray/900,
/// 오류 error(#E00052, 글자도 같은 색)
class LabeledInput extends StatelessWidget {
  const LabeledInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.error = false,
    this.autofocus = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final bool error;
  final bool autofocus;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: c),
    );
    final textColor = error ? kErrorColor : AppColors.gray900;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
            obscuringCharacter: '*',
            autofocus: autofocus,
            keyboardType: keyboardType,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            cursorColor: AppColors.gray900,
            cursorWidth: 1,
            style: TextStyle(
              fontFamily: AppFonts.pretendard,
              fontSize: 15,
              letterSpacing: -0.3,
              color: textColor,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: AppFonts.pretendard,
                fontSize: 15,
                letterSpacing: -0.3,
                color: AppColors.gray400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              filled: true,
              fillColor: AppColors.screen,
              enabledBorder: border(error ? kErrorColor : kInputBorderColor),
              focusedBorder: border(error ? kErrorColor : AppColors.gray900),
              border: border(kInputBorderColor),
            ),
          ),
        ),
      ],
    );
  }
}

/// 카카오 버튼 — #FEE500, 상하 14, Noto Sans KR Bold 18
class KakaoButton extends StatelessWidget {
  const KakaoButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: MouseRegion(
        cursor: onPressed != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE500),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text(
              '카카오로 계속하기',
              style: TextStyle(
                fontFamily: AppFonts.notoSansKr,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.6,
                letterSpacing: -0.18,
                color: AppColors.gray900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 꽉 찬 검정/회색 버튼 (로그인 창 아래 버튼) — 높이 50, radius 2
class FillButton extends StatelessWidget {
  const FillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.muted = false,
    this.dimWhenDisabled = true,
    this.height = 50,
  });

  /// 회원가입 창의 '가입하고 시작하기'는 57 (Figma 1100:8495)
  final double height;

  final String label;
  final VoidCallback? onPressed;

  /// true면 회색(gray/100 배경 + gray/400 글자) — 취소
  final bool muted;

  /// 비활성일 때 30% 불투명도 (Figma 로그인 버튼)
  final bool dimWhenDisabled;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final child = Container(
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: muted ? AppColors.gray100 : AppColors.gray900,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: AppTextStyles.title18.copyWith(
          color: muted ? AppColors.gray400 : Colors.white,
        ),
      ),
    );
    return Semantics(
      button: true,
      enabled: enabled,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: onPressed,
          child: Opacity(
            opacity: !enabled && !muted && dimWhenDisabled ? 0.3 : 1,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// '처음이신가요? 계정 만들기' 같은 안내 + 밑줄 링크 (15, 간격 10)
class InlineLinkRow extends StatelessWidget {
  const InlineLinkRow({
    super.key,
    required this.text,
    required this.link,
    required this.onTap,
  });

  final String text;
  final String link;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const base = TextStyle(
      fontFamily: AppFonts.pretendard,
      fontSize: 15,
      height: 1.5,
      letterSpacing: -0.3,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: base.copyWith(color: const Color(0xFF62656D))),
        const SizedBox(width: 10),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Text(
              link,
              style: base.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 화면 왼쪽 위 뒤로가기 (Figma `back` 42 x 42)
class BackBox extends StatelessWidget {
  const BackBox({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '뒤로가기',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap ?? () => Navigator.of(context).maybePop(),
          // Figma back 컴포넌트(775:3858) 그대로: 흰 바탕, 0.5px gray/900 테두리, 꺾인 화살표
          child: Image.asset(AppIcons.back, width: 42, height: 42),
        ),
      ),
    );
  }
}
