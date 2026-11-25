import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/image_pick/picked_image.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/form_widgets.dart';
import '../result/result_models.dart';

const _dim = Color(0x8C0F1115);

/// 공통 창 틀 — 흰 배경, radius 2, 그림자, 폭 [width]
class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.width = 506, this.padding});

  final Widget child;
  final double width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Container(
          padding: padding ?? const EdgeInsets.all(30),
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
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ B3

/// Figma `B3 외부 AI 동의` — 필수 동의 체크 후 [동의하고 진행]
Future<bool?> showAiConsentDialog(BuildContext context) => showDialog<bool>(
  context: context,
  barrierColor: _dim,
  builder: (_) => const _ConsentDialog(),
);

class _ConsentDialog extends StatefulWidget {
  const _ConsentDialog();

  @override
  State<_ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<_ConsentDialog> {
  bool _checked = false;

  static const _rows = [
    ('전송 항목', '소재 사진, 입력한 소재 정보'),
    ('이용 목적', '소재 특성 분석, 놀이 장면 이미지 생성'),
    ('보관 기간', '저장하지 않은 결과는 일정 기간 후 자동 삭제'),
    ('주의', '회사 기밀이나 개인정보가 담긴 사진은 올리지 마세요'),
  ];

  @override
  Widget build(BuildContext context) {
    final small = AppTextStyles.body13.copyWith(color: AppColors.gray600);
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '외부 AI 처리 안내',
            style: AppTextStyles.title16.copyWith(
              color: AppColors.gray900,
              letterSpacing: -0.32,
            ),
          ),
          const SizedBox(height: 8),
          Text('분석을 위해 등록하신 사진과 입력 정보가 외부 AI 서비스로 전송됩니다.', style: small),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            color: AppColors.gray100,
            child: Column(
              children: [
                for (final r in _rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 88,
                          child: Text(
                            r.$1,
                            style: AppTextStyles.body13.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            r.$2,
                            style: AppTextStyles.body13.copyWith(
                              color: AppColors.gray900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                checked: _checked,
                label: '외부 AI 처리 동의',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() => _checked = !_checked),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _checked ? AppColors.gray900 : AppColors.screen,
                        border: Border.all(color: AppColors.gray900),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: _checked
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
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
                      onTap: () => setState(() => _checked = !_checked),
                      child: Text(
                        '위 내용을 확인했으며, 외부 AI 처리에 동의합니다. (필수)',
                        style: AppTextStyles.body13.copyWith(
                          color: AppColors.gray900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.dataPolicy),
                        child: Text(
                          '자세한 내용은 개인정보처리방침에서 확인할 수 있습니다.',
                          style: AppTextStyles.body13.copyWith(
                            fontSize: 9,
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: '이전',
                  variant: AppButtonVariant.light,
                  foregroundColor: AppColors.gray400,
                  expand: true,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FillButton(
                  label: '동의하고 진행',
                  onPressed: _checked
                      ? () => Navigator.of(context).pop(true)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ B4

/// 분석 창 결과
sealed class AnalysisOutcome {
  const AnalysisOutcome();
}

class AnalysisDone extends AnalysisOutcome {
  const AnalysisDone(this.analysis);
  final MaterialAnalysis analysis;
}

class AnalysisRetry extends AnalysisOutcome {
  const AnalysisRetry();
}

class AnalysisChangePhoto extends AnalysisOutcome {
  const AnalysisChangePhoto();
}

class AnalysisStopped extends AnalysisOutcome {
  const AnalysisStopped();
}

/// Figma `B4 소재 분석 중` / `B4-error 소재 분석 실패`
Future<AnalysisOutcome> showAnalyzingDialog(
  BuildContext context, {
  required PickedImage? photo,
  required Future<MaterialAnalysis> Function() task,
}) async {
  final result = await showDialog<AnalysisOutcome>(
    context: context,
    barrierColor: _dim,
    barrierDismissible: false,
    builder: (_) => _AnalyzingDialog(photo: photo, task: task),
  );
  return result ?? const AnalysisStopped();
}

class _AnalyzingDialog extends StatefulWidget {
  const _AnalyzingDialog({required this.photo, required this.task});

  final PickedImage? photo;
  final Future<MaterialAnalysis> Function() task;

  @override
  State<_AnalyzingDialog> createState() => _AnalyzingDialogState();
}

class _AnalyzingDialogState extends State<_AnalyzingDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  int _stage = 0; // 0 사진 확인, 1 형태·질감 분석, 2 결과 정리
  bool _failed = false;
  Timer? _timer;

  static const _stages = ['사진 확인', '형태·질감 분석', '분석 결과 정리'];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_stage < 1) setState(() => _stage++);
    });
    _run();
  }

  Future<void> _run() async {
    try {
      final analysis = await widget.task();
      if (!mounted) return;
      setState(() => _stage = 2);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (mounted) Navigator.of(context).pop(AnalysisDone(analysis));
    } catch (_) {
      if (!mounted) return;
      _timer?.cancel();
      _scan.stop();
      setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;
    return _Panel(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 455 / 300,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (photo != null)
                  Image.memory(photo.bytes, fit: BoxFit.cover)
                else
                  Container(color: AppColors.gray100),
                // 위아래로 움직이는 보라색 스캔 띠
                AnimatedBuilder(
                  animation: _scan,
                  builder: (context, _) => Align(
                    alignment: Alignment(0, -1 + 2 * _scan.value),
                    child: Container(
                      height: 72,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x00A58BFF), Color(0x80A58BFF)],
                        ),
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF7B5CE0), width: 3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _failed ? '분석을 마치지 못했어요' : '소재를 분석하고 있습니다',
            textAlign: TextAlign.center,
            style: AppTextStyles.title24.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            _failed
                ? '입력한 정보는 그대로 남아 있어요. 다시 시도하거나 사진을 바꿔 보세요.'
                : '사진과 입력하신 정보를 함께 살펴보고 있어요!',
            textAlign: TextAlign.center,
            style: AppTextStyles.body13.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: _failed ? kErrorColor : AppColors.gray500,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              children: [
                for (var i = 0; i < _stages.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        _StageIcon(
                          state: _failed
                              ? _Stage.error
                              : i < _stage
                              ? _Stage.done
                              : i == _stage
                              ? _Stage.active
                              : _Stage.waiting,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          i == 1 && (i == _stage || _failed)
                              ? '${_stages[i]}  ·  진행 중'
                              : _stages[i],
                          style: AppTextStyles.body13.copyWith(
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_failed)
            Row(
              children: [
                Expanded(
                  child: FillButton(
                    label: '사진 바꾸기',
                    muted: true,
                    onPressed: () =>
                        Navigator.of(context).pop(const AnalysisChangePhoto()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FillButton(
                    label: '다시 시도하기',
                    onPressed: () =>
                        Navigator.of(context).pop(const AnalysisRetry()),
                  ),
                ),
              ],
            )
          else
            FillButton(
              label: '중단하기',
              muted: true,
              onPressed: () => Navigator.of(context).pop(const AnalysisStopped()),
            ),
        ],
      ),
    );
  }
}

enum _Stage { waiting, active, done, error }

class _StageIcon extends StatelessWidget {
  const _StageIcon({required this.state});

  final _Stage state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: switch (state) {
        _Stage.done => Container(
          decoration: const BoxDecoration(
            color: AppColors.gray900,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 11, color: Colors.white),
        ),
        _Stage.active => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gray900, width: 2.5),
          ),
        ),
        _Stage.waiting => Container(
          decoration: const BoxDecoration(
            color: AppColors.gray100,
            shape: BoxShape.circle,
          ),
        ),
        _Stage.error => Container(
          decoration: const BoxDecoration(
            color: kErrorColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '!',
              style: TextStyle(
                fontFamily: AppFonts.pretendard,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                height: 1,
                color: Colors.white,
              ),
            ),
          ),
        ),
      },
    );
  }
}

// ------------------------------------------------------------------ B5-1

/// Figma `B5-1 AI 정보 수정` — AI 추정값(보라 칸) + 수정한 내용 입력
/// [input]이 true면 '사진으로 확인할 수 없는 정보' 입력 창(추정값 칸 없음)
Future<bool?> showEditInfoDialog(
  BuildContext context, {
  required InfoRow row,
  bool input = false,
}) => showDialog<bool>(
  context: context,
  barrierColor: _dim,
  builder: (_) => _EditInfoDialog(row: row, input: input),
);

class _EditInfoDialog extends StatefulWidget {
  const _EditInfoDialog({required this.row, required this.input});

  final InfoRow row;
  final bool input;

  @override
  State<_EditInfoDialog> createState() => _EditInfoDialogState();
}

class _EditInfoDialogState extends State<_EditInfoDialog> {
  late final _controller = TextEditingController(
    text: widget.row.edited ? widget.row.value : '',
  );
  late final String _original = widget.row.value;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      Navigator.of(context).pop(false);
      return;
    }
    widget.row
      ..value = text
      ..edited = true;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.row.label;
    const purple = Color(0xFF7B5CE0);
    return _Panel(
      width: 506,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.input ? '$label 정보 입력' : '$label 정보 수정',
            style: AppTextStyles.title16.copyWith(
              color: AppColors.gray900,
              letterSpacing: -0.32,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.input
                ? '알고 있는 내용을 적어 주세요.\n입력한 내용으로 장면을 만들게요'
                : 'AI가 추정한 내용이 실제와 다르면 고쳐 주세요.\n고친 내용으로 장면을 만들게요',
            style: AppTextStyles.body13.copyWith(color: AppColors.gray600),
          ),
          if (!widget.input) ...[
            const SizedBox(height: 20),
            Text('ai 추정', style: AppTextStyles.body13.copyWith(fontSize: 11, color: purple)),
            const SizedBox(height: 8),
            Container(
              height: 43,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: const Color(0xFFE9E4FB),
                border: Border.all(color: const Color(0xFFC7B9F5)),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                _original,
                style: AppTextStyles.body13.copyWith(color: AppColors.gray900),
              ),
            ),
          ],
          const SizedBox(height: 20),
          LabeledInput(
            label: widget.input ? '입력한 내용' : '수정한 내용',
            controller: _controller,
            autofocus: true,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: '닫기',
                  variant: AppButtonVariant.light,
                  foregroundColor: AppColors.gray400,
                  expand: true,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(label: '저장', expand: true, onPressed: _save),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
