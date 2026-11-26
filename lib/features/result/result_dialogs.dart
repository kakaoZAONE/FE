import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/external_links.dart';
import '../../core/save_file.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import 'result_models.dart';
import 'result_pdf.dart';
import 'widgets/pdf_preview.dart';
import 'widgets/result_modal.dart';
import 'widgets/result_toast.dart';

// ------------------------------------------------------------ C2 재탐색

/// Figma `C2 재탐색` (866:2349) · `C2_b-1 특정 장면 재탐색` (1100:9879)
///
/// 추가 조건 문자열을 돌려준다(빈 문자열 가능). 닫으면 null.
/// [mode]를 주면 그 장면 하나만 다시 만드는 창(C2_b-1)이다.
Future<String?> showReExploreDialog(BuildContext context, {PlayMode? mode}) =>
    showDialog<String>(
      context: context,
      barrierColor: kResultDim,
      builder: (_) => _ReExploreDialog(mode: mode),
    );

class _ReExploreDialog extends StatefulWidget {
  const _ReExploreDialog({required this.mode});

  final PlayMode? mode;

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
    final mode = widget.mode;
    return ResultModal(
      title: mode != null ? '이 장면만 다시 생성' : '다시 탐색',
      subtitle: mode != null
          ? '새로운 조건에 맞춰 ${mode.label} 장면이 새로 생성됩니다.'
          : '새 조건에 맞춰 탐색·변형·조합 세 장면을 모두 새로 생성됩니다.',
      closeLabel: '닫기',
      confirmLabel: mode != null ? '다시 생성' : '새로 만들기',
      onConfirm: () => Navigator.of(context).pop(_text.text.trim()),
      children: [
        // Figma `input` 456 x 228: 라벨 13 → 10 → 입력칸(테두리 #D9DCE1, radius 4)
        SizedBox(
          height: 228,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('추가 조건을 자유롭게 입력해 주세요.', style: ResultModalText.body13),
              const SizedBox(height: 10),
              Expanded(
                child: TextField(
                  controller: _text,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  style: _inputText.copyWith(color: AppColors.gray900),
                  cursorColor: AppColors.gray900,
                  decoration: InputDecoration(
                    hintText: '예_20명 이상이 함께 참여하는 활동이면 좋겠습니다.',
                    hintStyle: _inputText.copyWith(color: AppColors.gray400),
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    enabledBorder: _border(const Color(0xFFD9DCE1)),
                    focusedBorder: _border(AppColors.gray900),
                  ),
                ),
              ),
            ],
          ),
        ),
        ModalNote(
          mode != null
              ? '이전 탐색 장면은 저장되지 않습니다.'
              : '기존 결과는 저장되지 않으며 새 탐색은 내 탐색 기록에서 ‘탐색 2’로 따로 저장됩니다.',
        ),
      ],
    );
  }

  static const _inputText = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    letterSpacing: -0.3,
  );

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(color: color),
  );
}

// ------------------------------------------------------------ C3 PDF

/// Figma `C3 pdf 저장` (887:3141) → `C3-1 pdf 저장완료` (889:4353)
///
/// '다운로드'를 누르면 결과 PDF를 앱에서 직접 만들어([buildResultPdf]) 내려받고,
/// '✓ PDF를 저장했습니다 · 파일 이름 · 파일보기' 알림을 띄운다.
/// 만드는 동안 버튼은 '만드는 중…'(눌리지 않음). 실패하면 실패 안내만 띄운다.
Future<void> showPdfDialog(BuildContext context, MaterialResult result) =>
    showDialog<void>(
      context: context,
      barrierColor: kResultDim,
      builder: (dialogContext) {
        var busy = false;
        return StatefulBuilder(
          builder: (dialogContext, setState) => ResultModal(
            title: 'PDF로 받기',
            closeLabel: '닫기',
            confirmLabel: busy ? '만드는 중…' : '다운로드',
            onConfirm: busy
                ? null
                : () async {
                    setState(() => busy = true);
                    final saved = await _savePdf(result);
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                    if (!context.mounted) return;
                    if (saved == null) {
                      showResultToast(
                        context,
                        success: false,
                        message: 'PDF를 만들지 못했어요. 다시 시도해 주세요',
                      );
                      return;
                    }
                    final (:fileName, :url) = saved;
                    showResultToast(
                      context,
                      message: 'PDF를 저장했습니다 · $fileName',
                      actionLabel: url == null ? null : '파일보기',
                      onAction: url == null ? null : () => openFileUrl(url),
                      duration: const Duration(seconds: 6),
                    );
                  },
            children: [
              PdfPreview(result: result),
              Text(
                '“AI가 만든 가상 장면” 안내 문구가 포함됩니다',
                style: ResultModalText.body13.copyWith(
                  color: AppColors.gray800,
                ),
              ),
            ],
          ),
        );
      },
    );

/// PDF를 만들어 내려받는다. 실패하면 null.
Future<({String fileName, String? url})?> _savePdf(
  MaterialResult result,
) async {
  try {
    final bytes = await buildResultPdf(result);
    final fileName = resultPdfFileName(result, DateTime.now());
    final url = downloadFile(bytes, fileName, 'application/pdf');
    return (fileName: fileName, url: url);
  } catch (e, st) {
    debugPrint('PDF 생성 실패: $e\n$st');
    return null;
  }
}

// ------------------------------------------------------------ C4 자원랩

/// Figma `C4 자원랩 연결` (866:2626) — 준비 정보 안내 + PDF · 링크 복사 + 자원랩으로 이동
Future<void> showContactDialog(BuildContext context, MaterialResult result) =>
    showDialog<void>(
      context: context,
      barrierColor: kResultDim,
      builder: (dialogContext) => ResultModal(
        title: '자원랩에 문의하기',
        subtitle: '문의 접수나 계약을 담당하지 않으므로 실제 교육 활용 문의는 자원랩을 통해 진행됩니다.',
        closeLabel: '닫기',
        confirmLabel: '자원랩으로 이동',
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          ExternalLinks.open(ExternalLinks.zaoneContact);
        },
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('문의 전에 준비하면 좋은 정보를 모아봤어요!', style: ResultModalText.bold13),
              for (final item in const [
                '소재명과 발생 공정',
                '대략적인 수량과 발생 주기',
                '보관 상태와 위치',
                '담당자 연락처',
              ]) ...[const SizedBox(height: 5), ModalNote(item, bold: true)],
            ],
          ),
          // 위아래 1px gray/200, 상하 15, 사이 10 (높이 108 = 1 + 15 + 76 + 15 + 1)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: AppColors.gray200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TODO(디자인 확인): Figma 887:3130 문구가 위 제목과 같다. 바뀌면 교체.
                Text('문의 전에 준비하면 좋은 정보를 모아봤어요!', style: ResultModalText.bold13),
                const SizedBox(height: 10),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        label: '결과 링크 복사',
                        variant: AppButtonVariant.outline,
                        expand: true,
                        onPressed: () => _copyLink(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

Future<void> _copyLink(BuildContext context) async {
  try {
    await Clipboard.setData(ClipboardData(text: Uri.base.toString()));
    if (!context.mounted) return;
    showResultToast(context, message: '결과 링크를 복사했어요');
  } catch (_) {
    // 브라우저가 클립보드 접근을 막은 경우 — 복사 완료로 표시하지 않는다
    if (!context.mounted) return;
    showResultToast(
      context,
      success: false,
      message: '링크를 복사하지 못했어요. 주소창의 주소를 복사해 주세요',
    );
  }
}

// ------------------------------------------------------------ 상세보기

/// 결과 머리 '상세보기' — 분석 때 확인한 소재 정보 표
///
/// Figma 최종 섹션에 이 창의 프레임이 없어 결과 창 공통 틀(ResultModal)로 보여 준다.
Future<void> showAnalysisDetailDialog(
  BuildContext context,
  MaterialResult result,
) {
  final a = result.analysis!;
  Widget section(String title, List<InfoRow> rows) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(title, style: ResultModalText.bold13),
      const SizedBox(height: 6),
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  r.label,
                  style: ResultModalText.body13.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
              ),
              Expanded(child: Text(r.value, style: ResultModalText.body13)),
            ],
          ),
        ),
    ],
  );
  return showDialog<void>(
    context: context,
    barrierColor: kResultDim,
    builder: (dialogContext) => ResultModal(
      title: '소재 상세 정보',
      closeLabel: '닫기',
      confirmLabel: '확인',
      onConfirm: () => Navigator.of(dialogContext).pop(),
      children: [
        section('입력하신 정보', a.entered),
        section('AI가 사진에서 추정한 정보', a.estimated),
        section('사진으로 확인할 수 없는 정보', a.unknown),
      ],
    ),
  );
}
