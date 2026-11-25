import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/external_links.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/design_width.dart';
import '../../widgets/flow_widgets.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/login_dialog.dart';
import '../../widgets/notch_banner.dart';
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

/// Figma `C1 내 소재 탐색 결과` (787:14530) · `C1-1 저장` (851:1981)
/// · `A2-1 샘플 상세` (775:3531) · `C2 재탐색` 계열
///
/// 머리(소재 정보 + 버튼) → 탐색·변형·조합 메뉴 → 장면 카드 3개 → 배너
class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.resultId});

  final String resultId;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  MaterialResult? _result;
  final _keys = {for (final m in PlayMode.values) m: GlobalKey()};

  /// 다시 만드는 중인 장면
  final _regenerating = <PlayMode>{};

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

  Future<void> _save() async {
    final result = _result!;
    if (!AuthState.instance.isSignedIn) {
      final ok = await showLoginDialog(context);
      if (!ok || !mounted) return;
    }
    setState(() => ResultStore.instance.save(result));
    if (!mounted) return;
    // C1-1: 화면 위 검정 알림 '내 탐색 기록에 저장했습니다 | 기록 보기'
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.gray900,
        width: 360,
        content: const Text('내 탐색 기록에 저장했습니다'),
        action: SnackBarAction(
          label: '기록 보기',
          textColor: AppColors.gray300,
          onPressed: () => AppHeader.goTo(context, AppRoutes.history),
        ),
      ),
    );
  }

  Future<void> _reExploreAll() async {
    final condition = await showReExploreDialog(context);
    if (condition == null || !mounted) return;
    await _regenerate(PlayMode.values);
  }

  Future<void> _reExploreOne(PlayMode mode) async {
    final condition = await showReExploreDialog(context, single: true);
    if (condition == null || !mounted) return;
    await _regenerate([mode]);
  }

  Future<void> _regenerate(List<PlayMode> modes) async {
    final result = _result!;
    setState(() => _regenerating.addAll(modes));
    final draft = MaterialDraft()..name = result.name;
    final analysis =
        result.analysis ??
        MaterialAnalysis(entered: [], estimated: [], unknown: []);
    for (final mode in modes) {
      try {
        final scene = await MaterialApi.instance.generateScene(
          draft,
          analysis,
          mode,
        );
        if (!mounted) return;
        setState(() {
          final i = result.scenes.indexWhere((s) => s.mode == mode);
          if (i >= 0) result.scenes[i] = scene;
          _regenerating.remove(mode);
        });
      } catch (_) {
        if (!mounted) return;
        setState(() => _regenerating.remove(mode));
      }
    }
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
        return PageScaffold(
          bottomGap: Responsive.value<double>(
            context,
            desktop: 60,
            mobile: 40,
          ),
          body: DesignWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(pad, 15, pad, 0),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: BackBox(),
                  ),
                ),
                const SizedBox(height: 50),
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
                      ),
                      if (!result.isSample) ...[
                        const SizedBox(height: 31),
                        _Notice(saved: result.saved),
                      ],
                    ],
                  ),
                ),
                _Head(
                  result: result,
                  onReExplore: result.isSample ? null : _reExploreAll,
                  onPdf: () => showPdfDialog(context, result),
                  onSave: result.isSample || result.saved ? null : _save,
                  onContact: () => showContactDialog(context, result),
                ),
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: ModeTabs(onTap: _scrollTo),
                ),
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
                                  onRegenerate: result.isSample
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
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: _Banners(
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

/// 저장 안내 — 저장 전: 빨강 테두리 / 저장 후: 파랑 테두리
class _Notice extends StatelessWidget {
  const _Notice({required this.saved});

  final bool saved;

  static const _blue = Color(0xFF1F6FEB);

  @override
  Widget build(BuildContext context) {
    final color = saved ? _blue : kErrorColor;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        saved
            ? '내 탐색 기록에 저장된 결과입니다. 같은 소재로 언제든 새 탐색을 시작할 수 있습니다.'
            : '아직 저장되지 않은 결과입니다. 저장하지 않으면 일정 시간이 지난 뒤 삭제됩니다. PDF로는 언제든 받아 둘 수 있습니다.',
        style: AppTextStyles.body15.copyWith(color: color),
      ),
    );
  }
}

/// 결과 머리 — 좌우 120 · 상하 60, 아래 보더 gray/500
/// 왼쪽 565(날짜 · 이름 · 발생처 · 상세보기 · 버튼) / 오른쪽 이미지 626 x 427
class _Head extends StatelessWidget {
  const _Head({
    required this.result,
    required this.onReExplore,
    required this.onPdf,
    required this.onSave,
    required this.onContact,
  });

  final MaterialResult result;
  final VoidCallback? onReExplore;
  final VoidCallback onPdf;
  final VoidCallback? onSave;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final padH = Responsive.value<double>(
      context,
      desktop: 120,
      tablet: 40,
      mobile: 20,
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          result.createdLabel,
          style: AppTextStyles.body13.copyWith(
            color: AppColors.gray600,
            letterSpacing: -0.65,
          ),
        ),
        const SizedBox(height: 41),
        Text(
          result.name,
          style: AppTextStyles.heroTitle.copyWith(
            color: AppColors.gray900,
            fontSize: isMobile ? 34 : 48,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          result.source,
          style: AppTextStyles.sectionSub.copyWith(fontSize: isMobile ? 16 : 22),
        ),
        const SizedBox(height: 41),
        if (result.analysis != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => showAnalysisDetailDialog(context, result),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '상세보기',
                      style: AppTextStyles.sectionSub.copyWith(
                        fontSize: isMobile ? 16 : 22,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, color: AppColors.gray600),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 41),
        ],
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            if (onReExplore != null)
              IconOutlineButton(
                icon: Icons.refresh,
                label: '다시 탐색',
                gap: 5,
                onPressed: onReExplore,
              ),
            IconOutlineButton(icon: null, label: 'PDF로 받기', onPressed: onPdf),
            if (!result.isSample)
              IconOutlineButton(
                icon: result.saved ? Icons.bookmark : Icons.bookmark_border,
                label: result.saved ? '저장 완료' : '저장하기',
                gap: 5,
                onPressed: onSave,
              ),
          ],
        ),
        const SizedBox(height: 15),
        AppButton(label: '자원랩에 문의하기', expand: true, onPressed: onContact),
      ],
    );

    final cover = Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray900),
        borderRadius: BorderRadius.circular(2),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 626 / 426.818,
        child: result.coverImage != null
            ? Image.memory(result.coverImage!.bytes, fit: BoxFit.cover)
            : result.coverAsset != null
            ? Image.asset(result.coverAsset!, fit: BoxFit.cover)
            : Container(color: AppColors.gray100),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: 60),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray500)),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 565, child: info),
                const SizedBox(width: 38),
                Expanded(child: cover),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [cover, const SizedBox(height: 30), info],
            ),
    );
  }
}

/// 아래 배너 — 로그인 전: [Login(밝은)] [Contact(어두운)] 나란히 / 로그인 후: Contact만
class _Banners extends StatelessWidget {
  const _Banners({
    required this.showLogin,
    required this.row,
    required this.onLogin,
  });

  final bool showLogin;
  final bool row;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final contact = NotchBanner(
      dark: true,
      eyebrow: 'Contact',
      title: showLogin ? '결과가 마음에 드신다면' : '마음에 드는 소재를 발견하셨나요? ZAONE LAB에 문의해 보세요.',
      body:
          '실제 소재 제공과 교육 활용은 자원랩의 공식 협의 절차로 진행됩니다.\n'
          '탐색 결과를 저장해 두면 내부 검토와 문의에 그대로 활용할 수 있습니다.',
      action: AppButton(
        label: 'ZAONE LAB  바로가기',
        variant: AppButtonVariant.light,
        onPressed: () => ExternalLinks.open(ExternalLinks.zaoneLab),
      ),
    );
    if (!showLogin) return contact;
    final login = NotchBanner(
      eyebrow: 'Login',
      title: '내 소재로 놀이 장면을 보고싶다면',
      body: '직접 사진을 등록하고 자원도감이 검토해 \n3가지 놀이 장면을 확인할 수 있어요',
      action: AppButton(label: '로그인 하러가기', onPressed: onLogin),
    );
    if (!row) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [login, const SizedBox(height: 20), contact],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: login),
          const SizedBox(width: 20),
          Expanded(child: contact),
        ],
      ),
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
