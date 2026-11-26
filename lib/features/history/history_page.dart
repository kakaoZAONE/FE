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
import '../result/result_models.dart';
import '../result/result_store.dart';

/// Figma `D1_내 탐색기록 빈상태` (969:4493) · `D2_내 탐색기록` (889:4542)
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.value<double>(
      context,
      desktop: 120,
      tablet: 40,
      mobile: 20,
    );
    final isMobile = Responsive.of(context) == ScreenSize.mobile;

    return ListenableBuilder(
      listenable: Listenable.merge([AuthState.instance, ResultStore.instance]),
      builder: (context, _) {
        if (!AuthState.instance.isSignedIn) return const _NeedLogin();
        final all = ResultStore.instance.saved;
        final items = _query.isEmpty
            ? all
            : all.where((r) => r.name.contains(_query)).toList();
        final columns = Responsive.value<int>(
          context,
          desktop: 3,
          tablet: 2,
          mobile: 1,
        );

        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '내 탐색 기록',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: isMobile ? 26 : 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '등록한 소재와 소재별 탐색 결과를 모아 볼 수 있어요',
              style: AppTextStyles.body13.copyWith(color: AppColors.gray800),
            ),
          ],
        );
        final newButton = IconFillButton(
          label: '새 소재 등록',
          onPressed: () => AppHeader.goTo(context, AppRoutes.register),
        );
        final actions = all.isEmpty
            ? Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  newButton,
                  AppButton(
                    label: '샘플로 미리보기',
                    variant: AppButtonVariant.outline,
                    onPressed: () => AppHeader.goTo(context, AppRoutes.samples),
                  ),
                ],
              )
            : Wrap(
                spacing: 28,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: isMobile ? double.infinity : 330,
                    child: _SearchBox(
                      onChanged: (v) => setState(() => _query = v.trim()),
                    ),
                  ),
                  newButton,
                ],
              );

        return PageScaffold(
          bottomGap: 120,
          body: DesignWidth(
            child: Padding(
              padding: EdgeInsets.fromLTRB(pad, 104, pad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isMobile) ...[
                    heading,
                    const SizedBox(height: 16),
                    actions,
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: heading),
                        actions,
                      ],
                    ),
                  const SizedBox(height: 26),
                  if (all.isEmpty)
                    const _Empty()
                  else
                    ResponsiveGrid(
                      columns: columns,
                      gap: 23,
                      runGap: 23,
                      children: [
                        for (final r in items) _MaterialCard(result: r),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 검색칸 — 높이 40, radius 6, 보더 gray/200
class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: c),
    );
    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.body13.copyWith(color: AppColors.gray900),
        cursorColor: AppColors.gray900,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Icon(
            Icons.search,
            size: 16,
            color: AppColors.gray600,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 36),
          hintText: '소재명으로 검색',
          hintStyle: AppTextStyles.body13.copyWith(color: AppColors.gray500),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: border(AppColors.gray200),
          focusedBorder: border(AppColors.gray900),
        ),
      ),
    );
  }
}

/// 검정 버튼 + 더하기 아이콘 (새 소재 등록)
class IconFillButton extends StatelessWidget {
  const IconFillButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.gray900,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 22, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTextStyles.title18.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 426,
      color: AppColors.gray50,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '아직 저장한 탐색 기록이 없어요',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: Responsive.of(context) == ScreenSize.mobile ? 22 : 36,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '결과 화면에서 저장하기를 누르면 해당 페이지에서 모아볼 수 있어요',
            textAlign: TextAlign.center,
            style: AppTextStyles.body13.copyWith(color: AppColors.gray800),
          ),
        ],
      ),
    );
  }
}

/// 소재 카드 — 이미지 + 회색 칸(이름 · 생성일 · >)
class _MaterialCard extends StatelessWidget {
  const _MaterialCard({required this.result});

  final MaterialResult result;

  @override
  Widget build(BuildContext context) {
    final d = result.createdAt;
    String two(int v) => v.toString().padLeft(2, '0');
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.historyPath(result.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 384 / 282,
              child: _Cover(result: result),
            ),
            Container(
              height: 103,
              color: AppColors.gray50,
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.title24.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '생성 ${d.year}.${two(d.month)}.${two(d.day)}',
                          style: AppTextStyles.body15.copyWith(
                            fontSize: 17,
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.gray900),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.result});

  final MaterialResult result;

  @override
  Widget build(BuildContext context) {
    if (result.coverImage != null) {
      return Image.memory(result.coverImage!.bytes, fit: BoxFit.cover);
    }
    if (result.coverAsset != null) {
      return Image.asset(result.coverAsset!, fit: BoxFit.cover);
    }
    return Container(color: AppColors.gray100);
  }
}

/// 로그인하지 않고 들어온 경우
class _NeedLogin extends StatelessWidget {
  const _NeedLogin();

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      bottomGap: 120,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
        child: Column(
          children: [
            Text(
              '내 탐색 기록은 로그인 후 볼 수 있어요',
              style: AppTextStyles.title24,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(label: '로그인', onPressed: () => showLoginDialog(context)),
          ],
        ),
      ),
    );
  }
}

// ================================================================ D3 상세

/// Figma `D3_내 탐색기록` (969:4268) · `6.4 MY` 삭제 확인 (982:4683)
class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key, required this.resultId});

  final String resultId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ResultStore.instance,
      builder: (context, _) {
        final result = ResultStore.instance.byId(resultId);
        if (result == null || !result.saved) {
          return const _NeedLogin();
        }
        // 같은 이름의 저장 결과 = 같은 소재의 탐색 기록
        final runs = ResultStore.instance.saved
            .where((r) => r.name == result.name)
            .toList();
        return _DetailBody(result: result, runs: runs);
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.result, required this.runs});

  final MaterialResult result;
  final List<MaterialResult> runs;

  Future<void> _delete(
    BuildContext context,
    MaterialResult run,
    int number,
  ) async {
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x8C0F1115),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.all(30),
            color: AppColors.screen,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '기록을 삭제할까요?',
                  style: AppTextStyles.title16.copyWith(
                    color: AppColors.gray900,
                    letterSpacing: -0.32,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '선택한 기록만 삭제됩니다. 삭제 후에는 복구할 수 없어요.',
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 11,
                    color: kErrorColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '삭제할 탐색 기록',
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${run.name} · 탐색 $number _ 놀이 장면 ${run.scenes.length}개와 소재 정보',
                    style: AppTextStyles.body13.copyWith(
                      fontSize: 11,
                      color: AppColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: '닫기',
                        variant: AppButtonVariant.light,
                        foregroundColor: AppColors.gray400,
                        expand: true,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        label: '삭제',
                        expand: true,
                        onPressed: () => Navigator.of(ctx).pop(true),
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
    if (ok == true) {
      ResultStore.instance.remove(run);
      if (runs.length <= 1 && navigator.canPop()) navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.value<double>(
      context,
      desktop: 120,
      tablet: 40,
      mobile: 20,
    );
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    String two(int v) => v.toString().padLeft(2, '0');
    String date(DateTime d) => '${d.year}.${two(d.month)}.${two(d.day)}';
    final shape = result.analysis?.entered
        .where((r) => r.label == '형태')
        .map((r) => r.value)
        .firstOrNull;
    final size = result.analysis?.entered
        .where((r) => r.label == '크기')
        .map((r) => r.value)
        .firstOrNull;

    final facts = Wrap(
      spacing: 28,
      runSpacing: 10,
      children: [
        if (shape != null) _Fact('형태', shape),
        if (size != null) _Fact('크기', size),
        _Fact('등록일', date(runs.last.createdAt)),
        _Fact('탐색', '${runs.length}회'),
      ],
    );

    final head = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop) ...[
          SizedBox(
            width: 195,
            height: 158,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: _Cover(result: result),
            ),
          ),
          const SizedBox(width: 22),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.name,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                result.source,
                style: AppTextStyles.sectionSub.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 16),
              facts,
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                runSpacing: 8,
                children: [
                  IconOutlineButton(
                    icon: Icons.edit_outlined,
                    label: '소재 정보 수정',
                    compact: true,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('소재 정보 수정은 준비 중이에요')),
                    ),
                  ),
                  FillButton(
                    label: '이 소재로 새 탐색',
                    onPressed: () =>
                        AppHeader.goTo(context, AppRoutes.register),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    return PageScaffold(
      bottomGap: 20,
      body: DesignWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                Responsive.pagePadding(context),
                15,
                Responsive.pagePadding(context),
                0,
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: BackBox(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 40, pad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  head,
                  const SizedBox(height: 28),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.gray500,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        '탐색 기록 ${runs.length}건',
                        style: AppTextStyles.title16.copyWith(
                          color: AppColors.gray900,
                          letterSpacing: -0.32,
                        ),
                      ),
                      const Spacer(),
                      if (isDesktop)
                        Text(
                          '각 탐색은 생성 당시의 소재 정보로 보관되며, 소재 정보를 수정해도 이전 결과는 바뀌지 않습니다.',
                          style: AppTextStyles.body13.copyWith(
                            fontSize: 11,
                            color: AppColors.gray500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < runs.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    _RunCard(
                      run: runs[i],
                      number: runs.length - i,
                      onOpen: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.resultPath(runs[i].id)),
                      onDelete: () =>
                          _delete(context, runs[i], runs.length - i),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body13.copyWith(color: AppColors.gray400),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body13.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }
}

/// 탐색 1건 — 보더 gray/600, 왼쪽 정보 · 가운데 장면 3장 · 오른쪽 [결과 보기]
class _RunCard extends StatelessWidget {
  const _RunCard({
    required this.run,
    required this.number,
    required this.onOpen,
    required this.onDelete,
  });

  final MaterialResult run;
  final int number;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  static const _modeColors = {
    PlayMode.explore: Color(0xFF6D4BD8),
    PlayMode.transform: Color(0xFFD4572A),
    PlayMode.combine: Color(0xFFB8860B),
  };

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    final d = run.createdAt;
    String two(int v) => v.toString().padLeft(2, '0');
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '탐색 $number',
              style: AppTextStyles.title16.copyWith(
                color: AppColors.gray900,
                letterSpacing: -0.32,
              ),
            ),
            const SizedBox(width: 10),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: kErrorColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${d.year}.${two(d.month)}.${two(d.day)} ${two(d.hour)}:${two(d.minute)}',
          style: AppTextStyles.body13.copyWith(
            fontSize: 11,
            color: AppColors.gray500,
          ),
        ),
      ],
    );
    final thumbs = Row(
      children: [
        for (var i = 0; i < run.scenes.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: AspectRatio(
                    aspectRatio: 158 / 77,
                    child: Image.asset(run.scenes[i].image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  run.scenes[i].mode.label,
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: _modeColors[run.scenes[i].mode],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
    final open = AppButton(
      label: '결과 보기',
      variant: AppButtonVariant.outline,
      onPressed: onOpen,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
      decoration: BoxDecoration(border: Border.all(color: AppColors.gray600)),
      child: isDesktop
          ? Row(
              children: [
                SizedBox(width: 225, child: info),
                Expanded(child: thumbs),
                const SizedBox(width: 17),
                open,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                info,
                const SizedBox(height: 12),
                thumbs,
                const SizedBox(height: 12),
                open,
              ],
            ),
    );
  }
}
