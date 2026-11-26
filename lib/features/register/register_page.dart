import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/image_pick/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/design_width.dart';
import '../../widgets/flow_widgets.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/responsive.dart';
import '../result/result_models.dart';
import '../result/result_store.dart';
import '../result/scene_card.dart';
import 'material_api.dart';
import 'register_dialogs.dart';
import 'register_models.dart';

/// Figma `B1 ~ B7` 내 소재 등록 흐름 (`/register`)
///
/// 사진 등록 → 소재 정보 → (외부 AI 동의 · 분석 중) → 분석 확인 → 놀이 장면 생성 → 결과
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum _Step { photo, info, review, generate }

class _RegisterPageState extends State<RegisterPage> {
  final _draft = MaterialDraft();
  final _scroll = ScrollController();
  _Step _step = _Step.photo;
  bool _photoError = false;
  MaterialAnalysis? _analysis;

  // 장면 생성 상태
  final _scenes = <PlayMode, PlayScene>{};
  final _failed = <PlayMode>{};
  final _tabKeys = {for (final m in PlayMode.values) m: GlobalKey()};
  bool _generating = false;

  static const _steps = ['사진등록', '소재 정보', '분석 확인'];

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  int get _trailIndex => switch (_step) {
    _Step.photo => 0,
    _Step.info => 1,
    _Step.review || _Step.generate => 2,
  };

  void _go(_Step step) {
    setState(() => _step = step);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  // ---------------------------------------------------------------- 나가기

  Future<void> _exit() async {
    final navigator = Navigator.of(context);
    bool leave = true;
    if (_step == _Step.generate && _generating) {
      // B6-1 생성 중 나가기 확인
      final stop = await showConfirmDialog(
        context,
        title: '생성을 멈추고 나갈까요?',
        message: '지금 나가면 만들고 있던 장면은 저장되지 않아요.\n입력한 정보도 함께 사라져요.',
        leftLabel: '취소',
        rightLabel: '계속 만들기',
      );
      leave = stop ?? false;
    } else if (_draft.hasInput) {
      // B2 나가기
      final ok = await showConfirmDialog(
        context,
        title: '작성 중인 내용이 있습니다. 나가시겠습니까?',
        message: '페이지를 벗어날 경우, 지금까지 작성하신 내용이 사라집니다',
        leftLabel: '나가기',
        rightLabel: '취소',
      );
      leave = ok ?? false;
    }
    if (!leave || !mounted) return;
    _generating = false;
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.home);
    }
  }

  // ---------------------------------------------------------------- B1 사진

  Future<void> _pickPhotos() async {
    final picked = await pickImages();
    if (!mounted || picked.isEmpty) return;
    final valid = picked.where((p) => p.isValid).toList();
    setState(() {
      _photoError = valid.length != picked.length;
      for (final p in valid) {
        if (_draft.photos.length >= MaterialDraft.maxPhotos) break;
        _draft.photos.add(p);
      }
    });
  }

  void _removePhoto(int index) {
    setState(() => _draft.photos.removeAt(index));
  }

  // ---------------------------------------------------------------- B3 · B4

  Future<void> _startAnalysis() async {
    final agreed = await showAiConsentDialog(context);
    if (agreed != true || !mounted) return;
    while (mounted) {
      final outcome = await showAnalyzingDialog(
        context,
        photo: _draft.photos.isEmpty ? null : _draft.photos.first,
        task: () => MaterialApi.instance.analyze(_draft),
      );
      if (!mounted) return;
      switch (outcome) {
        case AnalysisDone(:final analysis):
          _analysis = analysis;
          _go(_Step.review);
          return;
        case AnalysisRetry():
          continue;
        case AnalysisChangePhoto():
          _go(_Step.photo);
          return;
        case AnalysisStopped():
          return;
      }
    }
  }

  // ---------------------------------------------------------------- B6 · B7

  Future<void> _generateAll() async {
    _go(_Step.generate);
    setState(() {
      _scenes.clear();
      _failed.clear();
      _generating = true;
    });
    for (final mode in PlayMode.values) {
      if (!_generating || !mounted) return;
      await _generate(mode);
    }
    if (mounted) setState(() => _generating = false);
  }

  Future<void> _generate(PlayMode mode) async {
    setState(() {
      _failed.remove(mode);
      _scenes.remove(mode);
    });
    try {
      final scene = await MaterialApi.instance.generateScene(
        _draft,
        _analysis!,
        mode,
      );
      if (!mounted) return;
      setState(() => _scenes[mode] = scene);
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed.add(mode));
    }
  }

  Future<void> _retry(PlayMode mode) async {
    setState(() => _generating = true);
    await _generate(mode);
    if (mounted) setState(() => _generating = false);
  }

  bool get _allReady => _scenes.length == PlayMode.values.length;

  void _finish() {
    final store = ResultStore.instance;
    final result = MaterialResult(
      id: store.newId(),
      name: _draft.name.trim().isEmpty ? '내 소재' : _draft.name.trim(),
      source: [
        _draft.origin.trim(),
        _draft.description.trim(),
      ].where((e) => e.isNotEmpty).join(' · '),
      createdAt: DateTime.now(),
      scenes: [for (final m in PlayMode.values) _scenes[m]!],
      coverImage: _draft.photos.isEmpty ? null : _draft.photos.first,
      analysis: _analysis,
    );
    store.put(result);
    Navigator.of(context).pushReplacementNamed(AppRoutes.resultPath(result.id));
  }

  void _scrollTo(PlayMode mode) {
    final ctx = _tabKeys[mode]!.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final padH = Responsive.value<double>(
      context,
      desktop: 120,
      tablet: 40,
      mobile: 20,
    );

    final (Widget body, Widget bar) = switch (_step) {
      _Step.photo => (
        _PhotoStep(
          draft: _draft,
          error: _photoError,
          onPick: _pickPhotos,
          onRemove: _removePhoto,
        ),
        FlowBottomBar(
          showPrev: false,
          nextLabel: '다음',
          onNext: _draft.photos.isEmpty ? null : () => _go(_Step.info),
        ),
      ),
      _Step.info => (
        _InfoStep(draft: _draft, onChanged: () => setState(() {})),
        FlowBottomBar(
          onPrev: () => _go(_Step.photo),
          nextLabel: '다음',
          onNext: _startAnalysis,
        ),
      ),
      _Step.review => (
        _ReviewStep(
          draft: _draft,
          analysis: _analysis!,
          onChanged: () => setState(() {}),
        ),
        FlowBottomBar(
          onPrev: () => _go(_Step.info),
          nextLabel: '생성하기',
          onNext: _generateAll,
        ),
      ),
      _Step.generate => (
        _GenerateStep(
          scenes: _scenes,
          failed: _failed,
          tabKeys: _tabKeys,
          onTab: (i) => _scrollTo(PlayMode.values[i]),
          onRetry: _retry,
        ),
        FlowBottomBar(
          onPrev: _generating ? null : () => _go(_Step.review),
          nextLabel: '완료',
          onNext: _allReady && !_generating ? _finish : null,
        ),
      ),
    };

    final (
      String title,
      String? sub,
      Color? subColor,
      Widget? trailing,
    ) = switch (_step) {
      _Step.photo => (
        '소재 사진을 등록해 주세요',
        '소재 전체와 표면이 잘 보이는 사진을 올려 주세요. 최대 5장까지 등록할 수 있습니다.',
        null,
        null,
      ),
      _Step.info => (
        '알고 있는 정보를 입력해 주세요',
        '입력할수록 분석이 정확해져요! 헷갈리는 항목은 비워 두셔도 됩니다.',
        null,
        null,
      ),
      _Step.review => (
        '분석 결과를 검토해 주세요',
        'AI 추정 정보는 틀릴 수 있어요. 실제와 다르면 수정한 뒤 다음으로 넘어가 주세요.',
        null,
        null,
      ),
      _Step.generate =>
        _allReady
            ? (
                '3가지 놀이 장면을 보여드릴게요',
                '생성완료! 탐색·변형·조합 장면을 차례로 생성되었습니다.',
                null,
                _Progress(value: 1),
              )
            : (
                '놀이 장면을 만들고 있어요',
                _failed.isNotEmpty
                    ? '${_failed.map((m) => m.label).join('·')} 장면을 생성하지 못했어요'
                    : '탐색·변형·조합 장면을 차례로 생성합니다. 이 화면을 벗어나면 진행이 중단됩니다.',
                _failed.isNotEmpty ? kErrorColor : null,
                _Progress(
                  value:
                      (_scenes.length + _failed.length) /
                      PlayMode.values.length,
                ),
              ),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            FlowHeader(onExit: _exit),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                child: DesignWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FlowTopRow(
                        steps: _steps,
                        current: _trailIndex,
                        onBack: switch (_step) {
                          _Step.photo => null,
                          _Step.info => () => _go(_Step.photo),
                          _Step.review => () => _go(_Step.info),
                          _Step.generate =>
                            _generating ? null : () => _go(_Step.review),
                        },
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padH),
                        child:
                            trailing == null ||
                                Responsive.of(context) == ScreenSize.mobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FlowTitle(
                                    title: title,
                                    sub: sub,
                                    subColor: subColor,
                                  ),
                                  if (trailing != null) ...[
                                    const SizedBox(height: 20),
                                    trailing,
                                  ],
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: FlowTitle(
                                      title: title,
                                      sub: sub,
                                      subColor: subColor,
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  SizedBox(width: 455, child: trailing),
                                ],
                              ),
                      ),
                      body,
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            bar,
          ],
        ),
      ),
    );
  }
}

/// 생성 진행 막대 — 폭 455, 높이 8, 채움 gray/900, 배경 gray/100
class _Progress extends StatelessWidget {
  const _Progress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '생성 진행률 ${(value * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: 8,
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.gray100,
            color: AppColors.gray900,
          ),
        ),
      ),
    );
  }
}

// =================================================================== B1

class _PhotoStep extends StatelessWidget {
  const _PhotoStep({
    required this.draft,
    required this.error,
    required this.onPick,
    required this.onRemove,
  });

  final MaterialDraft draft;
  final bool error;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;

  static const _tips = [
    '밝은 곳에서 소재 전체가 보이게 촬영해 주세요',
    '크기를 알 수 있도록 손이나 자를 함께 찍으면 좋습니다',
    '회사 로고, 문서, 사람 얼굴이 나오지 않게 해 주세요',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    final full = draft.photos.length >= MaterialDraft.maxPhotos;

    final drop = MouseRegion(
      cursor: full ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: full ? null : onPick,
        child: CustomPaint(
          painter: _DashedBorder(
            color: error ? kErrorColor : AppColors.gray200,
          ),
          child: Container(
            height: 407,
            color: error ? const Color(0xFFFDF2F6) : null,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.gray50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.file_upload_outlined,
                    size: 22,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '파일을 선택하거나 여기다 끌어다 놓으세요.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title18.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'JPG, PNG · 장당 10MB 이하',
                  style: AppTextStyles.body13.copyWith(
                    color: AppColors.gray400,
                    letterSpacing: -0.65,
                  ),
                ),
                if (error) ...[
                  const SizedBox(height: 20),
                  Text(
                    '사진을 올리지 못했어요. JPG, PNG 파일만, 장당 10MB 이하로 다시 올려 주세요.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title18.copyWith(color: kErrorColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    final tips = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tip',
          style: TextStyle(
            fontFamily: AppFonts.notoSansKr,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.2,
            color: AppColors.gray900,
          ),
        ),
        for (final tip in _tips) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.check, size: 16, color: AppColors.gray900),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tip,
                  style: const TextStyle(
                    fontFamily: AppFonts.notoSansKr,
                    fontSize: 14,
                    height: 1.4,
                    letterSpacing: -0.21,
                    color: AppColors.gray500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );

    final thumbs = [
      for (var i = 0; i < MaterialDraft.maxPhotos; i++)
        _Thumb(
          photo: i < draft.photos.length ? draft.photos[i] : null,
          onRemove: () => onRemove(i),
        ),
    ];

    final padH = Responsive.value<double>(
      context,
      desktop: 127,
      tablet: 40,
      mobile: 20,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(padH, 56, padH, 0),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [drop, const SizedBox(height: 10), tips],
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      for (var i = 0; i < thumbs.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        thumbs[i],
                      ],
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                drop,
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < thumbs.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        SizedBox(width: 150, child: thumbs[i]),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                tips,
              ],
            ),
    );
  }
}

/// 사진 칸 150 x 112 — 빈 칸은 #F7F8FA + 보더 gray/100
class _Thumb extends StatelessWidget {
  const _Thumb({required this.photo, required this.onRemove});

  final PickedImage? photo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (photo == null) {
      return Container(
        height: 112,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          border: Border.all(color: AppColors.gray100),
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 112,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(photo!.bytes, fit: BoxFit.cover),
            Positioned(
              right: 11,
              top: 8,
              child: Semantics(
                button: true,
                label: '사진 삭제',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 13,
                        color: AppColors.gray900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 11,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  '등록 완료',
                  style: TextStyle(
                    fontFamily: AppFonts.pretendard,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 점선 테두리 (dash 4 · gap 3, radius 2)
class _DashedBorder extends CustomPainter {
  const _DashedBorder({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(2)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 4), paint);
        distance += 7;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorder old) => old.color != color;
}

// =================================================================== B2

class _InfoStep extends StatefulWidget {
  const _InfoStep({required this.draft, required this.onChanged});

  final MaterialDraft draft;
  final VoidCallback onChanged;

  @override
  State<_InfoStep> createState() => _InfoStepState();
}

class _InfoStepState extends State<_InfoStep> {
  late final _name = TextEditingController(text: widget.draft.name);
  late final _desc = TextEditingController(text: widget.draft.description);
  late final _origin = TextEditingController(text: widget.draft.origin);
  late final _extra = TextEditingController(text: widget.draft.extraNote);
  late final _limits = TextEditingController(text: widget.draft.constraints);

  @override
  void dispose() {
    for (final c in [_name, _desc, _origin, _extra, _limits]) {
      c.dispose();
    }
    super.dispose();
  }

  void _set(VoidCallback update) {
    setState(update);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;

    final basic = _FormCard(
      title: '소재의 기본 정보',
      children: [
        _pair(
          isDesktop,
          _DraftInput(
            label: '소재 이름',
            hint: '예) 종이 완충재',
            controller: _name,
            onChanged: (v) => _set(() => d.name = v),
          ),
          _DraftInput(
            label: '소재 설명',
            hint: '예) 제품 포장 후 남는 종이 소재',
            controller: _desc,
            onChanged: (v) => _set(() => d.description = v),
          ),
        ),
        _DraftInput(
          label: '어디에서 생기는 소재인가요?',
          hint: '예) 제품 포장 공정',
          controller: _origin,
          onChanged: (v) => _set(() => d.origin = v),
        ),
        _ChipGroup(
          label: '재질',
          options: MaterialDraft.materials,
          value: d.material,
          onChanged: (v) => _set(() => d.material = v),
        ),
        _ChipGroup(
          label: '가장 가까운 형태',
          options: MaterialDraft.shapes,
          value: d.shape,
          onChanged: (v) => _set(() => d.shape = v),
        ),
      ],
    );
    final extra = _FormCard(
      title: '소재 추가 정보',
      children: [
        _DraftInput(
          label: '추가 설명',
          hint: '예) 원단을 감는 데 쓰고 남은 종이 심',
          controller: _extra,
          onChanged: (v) => _set(() => d.extraNote = v),
        ),
        _DraftInput(
          label: '알려진 제약',
          hint: '예) 절단면이 거칠 수 있음',
          controller: _limits,
          onChanged: (v) => _set(() => d.constraints = v),
        ),
      ],
    );

    final padH = Responsive.value<double>(
      context,
      desktop: 127,
      tablet: 40,
      mobile: 20,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(padH, 43, padH, 0),
      child: isDesktop
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: basic),
                  const SizedBox(width: 35),
                  Expanded(child: extra),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [basic, const SizedBox(height: 20), extra],
            ),
    );
  }

  static Widget _pair(bool row, Widget a, Widget b) => row
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: a),
            const SizedBox(width: 15),
            Expanded(child: b),
          ],
        )
      : Column(children: [a, const SizedBox(height: 20), b]);
}

/// 입력 카드 — 보더 gray/600, 안쪽 20, 간격 30, 제목 18 SemiBold
class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 461),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.screen,
        border: Border.all(color: AppColors.gray600),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.title18.copyWith(color: AppColors.gray900),
          ),
          for (final c in children) ...[const SizedBox(height: 30), c],
        ],
      ),
    );
  }
}

/// B2 입력칸 — 보더 #D9DCE1, radius 4, 글자 15
class _DraftInput extends StatelessWidget {
  const _DraftInput({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: c),
    );
    const text = TextStyle(
      fontFamily: AppFonts.pretendard,
      fontSize: 15,
      letterSpacing: -0.3,
      color: AppColors.gray900,
    );
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
            onChanged: onChanged,
            style: text,
            cursorColor: AppColors.gray900,
            cursorWidth: 1,
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: text.copyWith(color: AppColors.gray400),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              enabledBorder: border(const Color(0xFFD9DCE1)),
              focusedBorder: border(AppColors.gray900),
            ),
          ),
        ),
      ],
    );
  }
}

/// 선택 칩 — 좌우 20 · 상하 10, radius 100, 16 SemiBold
/// 선택: gray/900 + screen 글자 / 기본: gray/50 + gray/500 글자
class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body13.copyWith(color: AppColors.gray900),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final o in options)
              Semantics(
                selected: o == value,
                button: true,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    // 같은 칩을 다시 누르면 선택 해제(모르면 비워 둘 수 있게)
                    onTap: () => onChanged(o == value ? null : o),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: o == value
                            ? AppColors.gray900
                            : AppColors.gray50,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        o,
                        style: AppTextStyles.title16.copyWith(
                          color: o == value
                              ? AppColors.screen
                              : AppColors.gray500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// =================================================================== B5

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.draft,
    required this.analysis,
    required this.onChanged,
  });

  final MaterialDraft draft;
  final MaterialAnalysis analysis;
  final VoidCallback onChanged;

  static const _purple = Color(0xFF7B5CE0);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    final name = draft.name.trim().isEmpty ? '내 소재' : draft.name.trim();
    final meta = [
      if (draft.material != null) draft.material!,
      '사진 ${draft.photos.length}장',
    ].join(' · ');

    final photo = SizedBox(
      width: isDesktop ? 195 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: AspectRatio(
              aspectRatio: 195 / 139,
              child: draft.photos.isEmpty
                  ? Container(color: AppColors.gray100)
                  : Image.memory(draft.photos.first.bytes, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: AppTextStyles.title16.copyWith(
              color: AppColors.gray900,
              letterSpacing: -0.32,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            meta,
            style: AppTextStyles.body13.copyWith(color: AppColors.gray600),
          ),
        ],
      ),
    );

    final tables = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoTable(title: '입력하신 정보', rows: analysis.entered),
        const SizedBox(height: 14),
        _InfoTable(
          title: 'AI가 사진에서 추정한 정보',
          titleColor: _purple,
          note: '실제와 다르면 수정해 주세요',
          noteColor: _purple,
          rows: analysis.estimated,
          actionLabel: '수정',
          actionIcon: Icons.edit_outlined,
          onAction: (row) async {
            final changed = await showEditInfoDialog(context, row: row);
            if (changed == true) onChanged();
          },
        ),
        const SizedBox(height: 14),
        _InfoTable(
          title: '사진으로 확인할 수 없는 정보',
          titleColor: kErrorColor,
          note: '실제와 다르면 수정해 주세요',
          noteColor: kErrorColor,
          rows: analysis.unknown,
          actionLabel: '입력',
          onAction: (row) async {
            final changed = await showEditInfoDialog(
              context,
              row: row,
              input: true,
            );
            if (changed == true) onChanged();
          },
        ),
      ],
    );

    final padH = Responsive.value<double>(
      context,
      desktop: 127,
      tablet: 40,
      mobile: 20,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(padH, 36, padH, 0),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                photo,
                const SizedBox(width: 70),
                Expanded(child: tables),
                const SizedBox(width: 60),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [photo, const SizedBox(height: 24), tables],
            ),
    );
  }
}

/// 정보 표 — 머리(#F7F8FA, 13) + 줄(라벨 gray/600 · 값 Bold), 보더 gray/50
class _InfoTable extends StatelessWidget {
  const _InfoTable({
    required this.title,
    required this.rows,
    this.titleColor,
    this.note,
    this.noteColor,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final List<InfoRow> rows;
  final Color? titleColor;
  final String? note;
  final Color? noteColor;
  final String? actionLabel;
  final IconData? actionIcon;
  final ValueChanged<InfoRow>? onAction;

  @override
  Widget build(BuildContext context) {
    const line = BorderSide(color: AppColors.gray50);
    final label = AppTextStyles.body13.copyWith(
      fontSize: 14,
      color: AppColors.gray600,
    );
    final value = AppTextStyles.body13.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.gray900,
    );
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.gray50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 30,
            color: const Color(0xFFF9FAFB),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.body13.copyWith(
                      color: titleColor ?? AppColors.gray900,
                    ),
                  ),
                ),
                if (note != null)
                  Text(
                    note!,
                    style: AppTextStyles.body13.copyWith(
                      fontSize: 10,
                      color: noteColor,
                    ),
                  ),
              ],
            ),
          ),
          for (final row in rows)
            Container(
              constraints: BoxConstraints(
                minHeight: onAction != null ? 34 : 29,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: const BoxDecoration(border: Border(top: line)),
              child: Row(
                children: [
                  SizedBox(width: 76, child: Text(row.label, style: label)),
                  Expanded(child: Text(row.value, style: value)),
                  if (onAction != null)
                    _SmallAction(
                      label: actionLabel!,
                      icon: actionIcon,
                      onTap: () => onAction!(row),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({required this.label, required this.onTap, this.icon});

  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 18,
          padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray900),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 10, color: AppColors.gray900),
                const SizedBox(width: 3),
              ],
              Text(
                label,
                style: AppTextStyles.body13.copyWith(
                  fontSize: 9,
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================================== B6 · B7

class _GenerateStep extends StatelessWidget {
  const _GenerateStep({
    required this.scenes,
    required this.failed,
    required this.tabKeys,
    required this.onTab,
    required this.onRetry,
  });

  final Map<PlayMode, PlayScene> scenes;
  final Set<PlayMode> failed;
  final Map<PlayMode, GlobalKey> tabKeys;
  final ValueChanged<int> onTab;
  final ValueChanged<PlayMode> onRetry;

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    // 실패한 장면 다음 칸은 기다리는 상태로 둔다
    var shownLoading = false;
    final cards = <Widget>[];
    for (final mode in PlayMode.values) {
      final Widget card;
      if (scenes[mode] != null) {
        card = SceneCard(
          scene: scenes[mode],
          onRegenerate: () => onRetry(mode),
        );
      } else if (failed.contains(mode)) {
        card = SceneCard(
          state: SceneCardState.failed,
          onRetry: () => onRetry(mode),
        );
      } else if (!shownLoading) {
        shownLoading = true;
        card = const SceneCard(state: SceneCardState.loading);
      } else {
        continue;
      }
      cards.add(KeyedSubtree(key: tabKeys[mode], child: card));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 79, pad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ModeTabs(onTap: onTab),
          const SizedBox(height: 115),
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(height: 60),
            cards[i],
          ],
        ],
      ),
    );
  }
}
