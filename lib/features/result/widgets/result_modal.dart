import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';

/// 결과 화면 창 뒤 dim — rgba(15,17,21,0.55)
const kResultDim = Color(0x8C0F1115);

/// 결과 화면 창 공통 틀 (Figma `modal` 866:2537 · 887:3248 · 866:3041)
///
/// 폭 520, 흰 바탕, 1px gray/900 테두리, radius 2, 그림자 0 20 48 rgba(0,0,0,.18).
/// 안쪽 위 32 · 좌우 32 · 아래 28, 요소 사이 15.
/// 제목 18 SemiBold(줄 25) + 설명 13 Regular gray/500 (사이 5).
/// 아래 버튼 줄: 위 24, [닫기(gray/400 글자)] 8 [주 버튼(검정)].
class ResultModal extends StatelessWidget {
  const ResultModal({
    super.key,
    required this.title,
    required this.children,
    required this.closeLabel,
    required this.confirmLabel,
    required this.onConfirm,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final String closeLabel;
  final String confirmLabel;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.gray900),
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2E000000),
                offset: Offset(0, 20),
                blurRadius: 48,
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(31, 31, 31, 27),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: ResultModalText.title),
                if (subtitle != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    subtitle!,
                    style: ResultModalText.body13.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
                for (final child in children) ...[
                  const SizedBox(height: 15),
                  child,
                ],
                const SizedBox(height: 15 + 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: closeLabel,
                        variant: AppButtonVariant.light,
                        foregroundColor: AppColors.gray400,
                        expand: true,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        label: confirmLabel,
                        expand: true,
                        onPressed: onConfirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 창 안 글자 스타일 (Pretendard, 줄 높이 normal)
abstract final class ResultModalText {
  static const title = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 25 / 18,
    letterSpacing: -0.72,
    color: AppColors.gray900,
  );

  /// body/13_reg — 자간 -2%
  static const body13 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: AppTextStyles.pretendardNormal,
    letterSpacing: -0.26,
    color: AppColors.gray900,
  );

  static final bold13 = body13.copyWith(fontWeight: FontWeight.w700);
}

/// 회색 안내 칸 — gray/100 배경, radius 8, 좌우 14 · 상하 10, 글자 13
/// (다시 탐색 안내 · 자원랩 문의 준비 정보)
class ModalNote extends StatelessWidget {
  const ModalNote(this.text, {super.key, this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: bold
            ? ResultModalText.bold13
            : ResultModalText.body13.copyWith(color: AppColors.gray700),
      ),
    );
  }
}
