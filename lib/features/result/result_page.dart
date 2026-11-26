import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/design_width.dart';
import '../../widgets/flow_widgets.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/login_dialog.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';
import '../auth/auth_state.dart';
import '../register/material_api.dart';
import '../register/register_models.dart';
import 'result_dialogs.dart';
import 'result_models.dart';
import 'result_store.dart';
import 'sample_results.dart';
import 'scene_card.dart';
import 'widgets/result_banners.dart';
import 'widgets/result_head.dart';
import 'widgets/result_toast.dart';

/// Figma `C1 내 소재 탐색 결과` (787:14530) · `C1-1 저장` (851:1981)
/// · `A2-1 샘플 상세` (775:3531) · `C2 재탐색` 계열 (866:2349 · 1100:7850 · 1100:9651 · 1100:9879 · 1100:10037)
///
/// 뒤로가기 → 단계 표시 · 저장 안내 → 머리(소재 정보 + 버튼) → 탐색·변형·조합 메뉴
/// → 장면 카드 3개 → 배너
class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.resultId});

  final String resultId;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  MaterialResult? _result;
  final _keys = {for (final m in PlayMode.values) m: GlobalKey()};

  /// 다시 만드는 중인 장면 (C2_a-1 재탐색 중)
  final _regenerating = <PlayMode>{};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _result =
        ResultStore.instance.byId(widget.resultId) ??
        SampleResults.byId(widget.resultId);
  }

  void _scrollTo(int index) {
    final ctx = _keys[PlayMode.values[index]]!.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // ------------------------------------------------------------ 동작

  /// 저장하기 — 로그인 전이면 로그인 창(D1)을 먼저 띄우고, 로그인하면 이어서 저장한다.
  ///
  /// '저장 완료'와 C1-1 알림은 저장이 실제로 끝난 뒤에만 보여 준다.
  /// (지금 [ResultStore]는 메모리 Mock — 저장 API가 생기면 실패 시 아래 catch로 간다)
  Future<void> _save() async {
    final result = _result!;
    if (_saving || result.saved) return;
    if (!AuthState.instance.isSignedIn) {
      // D1 (1100:8260): 결과 저장에서 연 로그인 창 제목
      final ok = await showLoginDialog(context, title: '결과를 저장하려면 로그인해 주세요');
      if (!ok || !mounted) return;
    }
    setState(() => _saving = true);
    try {
      await ResultStore.instance.save(result);
      if (!mounted) return;
      setState(() => _saving = false);
      showResultToast(
        context,
        message: '내 탐색 기록에 저장했습니다',
        actionLabel: '보러 가기',
        onAction: () => AppHeader.goTo(context, AppRoutes.history),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      showResultToast(
        context,
        success: false,
        message: '저장하지 못했어요. 잠시 후 다시 시도해 주세요',
      );
    }
  }

  Future<void> _reExploreAll() async {
    final condition = await showReExploreDialog(context);
    if (condition == null || !mounted) return;
    final ok = await _regenerate(PlayMode.values);
    if (!mounted || ok == null) return;
    if (ok) {
      // C2_a-2 재탐색 완료
      showResultToast(
        context,
        message: '입력하신 정보를 바탕으로 재탐색을 완료했어요',
        actionLabel: AuthState.instance.isSignedIn ? '내 탐색기록 바로가기' : null,
        onAction: () => AppHeader.goTo(context, AppRoutes.history),
      );
    } else {
      _showRegenerateFailed();
    }
  }

  Future<void> _reExploreOne(PlayMode mode) async {
    final condition = await showReExploreDialog(context, mode: mode);
    if (condition == null || !mounted) return;
    final ok = await _regenerate([mode]);
    if (!mounted || ok == null) return;
    if (ok) {
      // C2_b-2 특정 장면 재탐색 완료
      showResultToast(
        context,
        message: '입력하신 정보를 바탕으로 [${mode.label}]장면을 다시 생성했어요',
      );
    } else {
      _showRegenerateFailed();
    }
  }

  void _showRegenerateFailed() => showResultToast(
    context,
    success: false,
    message: '장면을 다시 만들지 못했어요. 기존 장면은 그대로 남아 있어요',
  );

  /// 장면을 다시 만든다. 모두 성공하면 true, 하나라도 실패하면 false,
  /// 화면을 떠났으면 null.
  ///
  /// TODO(API): 추가 조건(condition)은 생성 API 명세가 정해지면 함께 보낸다.
  /// 재탐색 결과를 '탐색 2'로 따로 저장하는 동작도 저장 API 확정 후 구현.
  Future<bool?> _regenerate(List<PlayMode> modes) async {
    final result = _result!;
    setState(() => _regenerating.addAll(modes));
    final draft = MaterialDraft()..name = result.name;
    final analysis =
        result.analysis ??
        MaterialAnalysis(entered: [], estimated: [], unknown: []);
    var allOk = true;
    for (final mode in modes) {
      try {
        final scene = await MaterialApi.instance.generateScene(
          draft,
          analysis,
          mode,
        );
        if (!mounted) return null;
        setState(() {
          final i = result.scenes.indexWhere((s) => s.mode == mode);
          if (i >= 0) result.scenes[i] = scene;
          _regenerating.remove(mode);
        });
      } catch (_) {
        if (!mounted) return null;
        allOk = false;
        setState(() => _regenerating.remove(mode));
      }
    }
    return allOk;
  }

  // ------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final result = _result;
    if (result == null) return const _Missing();

    final pad = Responsive.pagePadding(context);
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;

    return ListenableBuilder(
      listenable: Listenable.merge([AuthState.instance, ResultStore.instance]),
      builder: (context, _) {
        final signedIn = AuthState.instance.isSignedIn;
        final busy = _regenerating.isNotEmpty;
        return PageScaffold(
          bottomGap: Responsive.value<double>(context, desktop: 60, mobile: 40),
          body: DesignWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // back 60,126 (헤더 111 아래 15)
                Padding(
                  padding: EdgeInsets.fromLTRB(pad, 15, pad, 0),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: BackBox(),
                  ),
                ),
                // 단계 표시 top 233 = 126 + 42 + 65
                const SizedBox(height: 65),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StepTrail(
                        steps: result.isSample
                            ? ['샘플 둘러보기', result.name]
                            : ['내 소재등록하기', '결과'],
                        current: 1,
                        // C1: '내 소재등록하기'는 흐리게, '결과'만 진하게
                        boldPast: result.isSample,
                      ),
                      if (!result.isSample) ...[
                        const SizedBox(height: 31),
                        ResultSaveNotice(saved: result.saved),
                      ],
                    ],
                  ),
                ),
                ResultHead(
                  result: result,
                  showReExplore: !result.isSample,
                  onReExplore: busy ? null : _reExploreAll,
                  onPdf: () => showPdfDialog(context, result),
                  onSave: result.isSample || result.saved || _saving
                      ? null
                      : _save,
                  onContact: () => showContactDialog(context, result),
                  onDetail: () => showAnalysisDetailDialog(context, result),
                ),
                // 탐색 · 변형 · 조합 메뉴 (상하좌우 60)
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: ModeTabs(onTap: _scrollTo),
                ),
                // 장면 카드 (상하좌우 60, 사이 60)
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < result.scenes.length; i++) ...[
                        if (i > 0) const SizedBox(height: 60),
                        KeyedSubtree(
                          key: _keys[result.scenes[i].mode],
                          child: _regenerating.contains(result.scenes[i].mode)
                              ? const SceneCard(state: SceneCardState.loading)
                              : SceneCard(
                                  scene: result.scenes[i],
                                  onRegenerate: result.isSample || busy
                                      ? null
                                      : () => _reExploreOne(
                                          result.scenes[i].mode,
                                        ),
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Figma의 '해외 실제 사례' 블록은 정책상 넣지 않는다(docs/FIGMA.md)
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: ResultBanners(
                    showLogin: !signedIn,
                    row: isDesktop,
                    onLogin: () => showLoginDialog(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 새로고침 등으로 결과가 사라졌을 때
class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      bottomGap: 120,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
        child: Column(
          children: [
            Text(
              '결과를 찾을 수 없어요',
              style: AppTextStyles.title24,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '저장하지 않은 결과는 새로고침하면 사라져요.',
              style: AppTextStyles.body15.copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            AppButton(
              label: '내 소재 등록하기',
              onPressed: () => Navigator.of(
                context,
              ).pushReplacementNamed(AppRoutes.register),
            ),
          ],
        ),
      ),
    );
  }
}
