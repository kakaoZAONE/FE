import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/external_links.dart';
import '../../core/print_page.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import 'result_models.dart';

const _dim = Color(0x8C0F1115);

/// 결과 화면 창 공통 틀 — 폭 520, 안쪽 30
class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.title,
    required this.children,
    required this.leftLabel,
    required this.rightLabel,
    required this.onRight,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final String leftLabel;
  final String rightLabel;
  final VoidCallback? onRight;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          padding: const EdgeInsets.all(30),
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
                  title,
                  style: AppTextStyles.title16.copyWith(
                    color: AppColors.gray900,
                    letterSpacing: -0.32,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.body13.copyWith(
                      fontSize: 11,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                ...children,
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: leftLabel,
                        variant: AppButtonVariant.light,
                        foregroundColor: AppColors.gray400,
                        expand: true,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        label: rightLabel,
                        expand: true,
                        onPressed: onRight,
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

/// 회색 안내 줄 (radius 6, gray/100 배경, 글자 11)
class _GrayNote extends StatelessWidget {
  const _GrayNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.body13.copyWith(fontSize: 11, color: AppColors.gray700),
      ),
    );
  }
}

// ------------------------------------------------------------ C2 재탐색

/// Figma `C2 재탐색` · `C2_b-1 특정 장면 재탐색`
/// 추가 조건 문자열을 돌려준다(빈 문자열 가능). 닫으면 null.
Future<String?> showReExploreDialog(BuildContext context, {bool single = false}) =>
    showDialog<String>(
      context: context,
      barrierColor: _dim,
      builder: (_) => _ReExploreDialog(single: single),
    );

class _ReExploreDialog extends StatefulWidget {
  const _ReExploreDialog({required this.single});

  final bool single;

  @override
  State<_ReExploreDialog> createState() => _ReExploreDialogState();
}

class _ReExploreDialogState extends State<_ReExploreDialog> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final single = widget.single;
    return _ResultPanel(
      title: single ? '이 장면만 다시 생성' : '다시 탐색',
      subtitle: single
          ? '새로운 조건에 맞춰 탐색 장면이 새로 생성됩니다.'
          : '새 조건에 맞춰 탐색·변형·조합 세 장면을 모두 새로 생성됩니다.',
      leftLabel: '닫기',
      rightLabel: single ? '다시 생성' : '새로 만들기',
      onRight: () => Navigator.of(context).pop(_text.text.trim()),
      children: [
        Text(
          '추가 조건을 자유롭게 입력해 주세요.',
          style: AppTextStyles.body13.copyWith(fontSize: 11, color: AppColors.gray900),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _text,
          maxLines: 6,
          minLines: 6,
          style: AppTextStyles.body13.copyWith(color: AppColors.gray900),
          cursorColor: AppColors.gray900,
          decoration: InputDecoration(
            hintText: '예_20명 이상이 함께 참여하는 활동이면 좋겠습니다.',
            hintStyle: AppTextStyles.body13.copyWith(color: AppColors.gray400),
            contentPadding: const EdgeInsets.all(10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: AppColors.gray100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: AppColors.gray900),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _GrayNote(
          single
              ? '이전 탐색 장면은 저장되지 않습니다.'
              : '기존 결과는 저장되지 않으며 새 탐색은 내 탐색 기록에서 ‘탐색 2’로 따로 저장됩니다.',
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ C3 PDF

/// Figma `C3 pdf 저장` → 다운로드 → `C3-1 pdf 저장완료`
///
/// PDF는 브라우저 인쇄(‘PDF로 저장’)로 만든다. 별도 PDF 패키지 없이 프론트에서 생성.
Future<void> showPdfDialog(BuildContext context, MaterialResult result) =>
    showDialog<void>(
      context: context,
      barrierColor: _dim,
      builder: (dialogContext) => _ResultPanel(
        title: 'PDF로 받기',
        leftLabel: '닫기',
        rightLabel: '다운로드',
        onRight: () {
          Navigator.of(dialogContext).pop();
          final messenger = ScaffoldMessenger.of(context);
          printCurrentPage();
          messenger.showSnackBar(
            const SnackBar(content: Text('인쇄 창에서 ‘PDF로 저장’을 선택해 주세요')),
          );
        },
        children: [
          Container(
            height: 165,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: _PdfPagePreview(result: result, page: i)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '“AI가 만든 가상 장면” 안내 문구가 포함됩니다',
            style: AppTextStyles.body13.copyWith(fontSize: 11, color: AppColors.gray900),
          ),
        ],
      ),
    );

/// PDF 미리보기 한 장 (표지 · 장면 · 소재 정보)
class _PdfPagePreview extends StatelessWidget {
  const _PdfPagePreview({required this.result, required this.page});

  final MaterialResult result;
  final int page;

  @override
  Widget build(BuildContext context) {
    Widget line(double w) => Container(
      width: w,
      height: 3,
      margin: const EdgeInsets.only(top: 4),
      color: AppColors.gray100,
    );
    final scenes = result.scenes;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body13.copyWith(fontSize: 6, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          if (page == 0 && result.coverAsset != null)
            Expanded(child: Image.asset(result.coverAsset!, fit: BoxFit.cover))
          else if (page == 1)
            for (final s in scenes.take(3))
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      Expanded(child: Image.asset(s.image, fit: BoxFit.cover)),
                      const SizedBox(width: 3),
                      Expanded(child: Column(children: [line(20), line(16)])),
                    ],
                  ),
                ),
              )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (var i = 0; i < 8; i++) line(i.isEven ? 60 : 40)],
              ),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ C4 자원랩

/// Figma `C4 자원랩 연결` — 준비 정보 안내 + PDF · 링크 복사 + 자원랩으로 이동
Future<void> showContactDialog(BuildContext context, MaterialResult result) =>
    showDialog<void>(
      context: context,
      barrierColor: _dim,
      builder: (dialogContext) {
        Widget chip(String text) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: AppTextStyles.body13.copyWith(fontSize: 11, color: AppColors.gray900),
          ),
        );
        final label = AppTextStyles.body13.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.gray900,
        );
        return _ResultPanel(
          title: '자원랩에 문의하기',
          subtitle: '문의 접수나 계약을 담당하지 않으므로 실제 교육 활용 문의는 자원랩을 통해 진행됩니다.',
          leftLabel: '닫기',
          rightLabel: '자원랩으로 이동',
          onRight: () {
            Navigator.of(dialogContext).pop();
            ExternalLinks.open(ExternalLinks.zaoneContact);
          },
          children: [
            Text('문의 전에 준비하면 좋은 정보를 모아봤어요!', style: label),
            const SizedBox(height: 8),
            chip('소재명과 발생 공정'),
            chip('대략적인 수량과 발생 주기'),
            chip('보관 상태와 위치'),
            chip('담당자 연락처'),
            const Divider(height: 20, color: AppColors.gray100),
            Text('문의 전에 준비하면 좋은 정보를 모아봤어요!', style: label),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'PDF로 받기',
                    variant: AppButtonVariant.outline,
                    expand: true,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      showPdfDialog(context, result);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppButton(
                    label: '결과 링크 복사',
                    variant: AppButtonVariant.outline,
                    expand: true,
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await Clipboard.setData(
                        ClipboardData(text: Uri.base.toString()),
                      );
                      messenger.showSnackBar(
                        const SnackBar(content: Text('결과 링크를 복사했어요')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: AppColors.gray100),
          ],
        );
      },
    );

// ------------------------------------------------------------ 상세보기

/// 결과 머리 '상세보기' — 분석 때 확인한 소재 정보 표
Future<void> showAnalysisDetailDialog(BuildContext context, MaterialResult result) {
  final a = result.analysis!;
  Widget section(String title, List<InfoRow> rows) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        title,
        style: AppTextStyles.body13.copyWith(fontWeight: FontWeight.w600, color: AppColors.gray900),
      ),
      const SizedBox(height: 6),
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(r.label, style: AppTextStyles.body13.copyWith(color: AppColors.gray600)),
              ),
              Expanded(
                child: Text(r.value, style: AppTextStyles.body13.copyWith(color: AppColors.gray900)),
              ),
            ],
          ),
        ),
      const SizedBox(height: 14),
    ],
  );
  return showDialog<void>(
    context: context,
    barrierColor: _dim,
    builder: (dialogContext) => _ResultPanel(
      title: '소재 상세 정보',
      leftLabel: '닫기',
      rightLabel: '확인',
      onRight: () => Navigator.of(dialogContext).pop(),
      children: [
        section('입력하신 정보', a.entered),
        section('AI가 사진에서 추정한 정보', a.estimated),
        section('사진으로 확인할 수 없는 정보', a.unknown),
      ],
    ),
  );
}
