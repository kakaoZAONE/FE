import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/external_links.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/design_width.dart';
import '../../widgets/login_dialog.dart';
import '../../widgets/notch_banner.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';
import '../auth/auth_state.dart';
import '../result/result_models.dart';
import '../result/sample_results.dart';

/// Figma `A2 샘플 결과 목록` (775:2989) — `/samples`
///
/// 소재 4종을 한 줄씩: 번호 · 대표 사진(이름) · 탐색/변형/조합 장면 3장 · [자세히 보기]
/// 상세는 결과 화면(`/result/sample-N`, Figma A2-1)으로 연다.
class SampleResultPage extends StatelessWidget {
  const SampleResultPage({super.key});

  /// 샘플 결과 목록(`/samples`)으로 이동
  static void open(BuildContext context) =>
      AppHeader.goTo(context, AppRoutes.samples);

  /// 메인의 샘플 카드에서 [index]번째 소재 상세를 바로 연다.
  static void openSample(BuildContext context, int index) {
    final all = SampleResults.all;
    if (index < 0 || index >= all.length) return open(context);
    Navigator.of(context).pushNamed(AppRoutes.resultPath(all[index].id));
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final isMobile = Responsive.of(context) == ScreenSize.mobile;

    return PageScaffold(
      bottomGap: Responsive.value<double>(context, desktop: 160, mobile: 60),
      body: DesignWidth(
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, 54, pad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '샘플 결과',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: isMobile ? 28 : 40,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '검증된 소재 정보 → AI 해석 → 탐색·변형·조합. 소재별 가상 장면을 먼저 둘러보세요.',
                style: AppTextStyles.sectionSub.copyWith(
                  fontSize: isMobile ? 15 : 22,
                ),
              ),
              const SizedBox(height: 36),
              for (var i = 0; i < SampleResults.all.length; i++)
                _SampleRow(index: i, result: SampleResults.all[i]),
              SizedBox(
                height: Responsive.value<double>(
                  context,
                  desktop: 510,
                  tablet: 160,
                  mobile: 60,
                ),
              ),
              ListenableBuilder(
                listenable: AuthState.instance,
                builder: (context, _) => _SampleBanners(
                  showLogin: !AuthState.instance.isSignedIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 한 줄 — 위 아래 여백 30, 아래 보더 gray/400
class _SampleRow extends StatelessWidget {
  const _SampleRow({required this.index, required this.result});

  final int index;
  final MaterialResult result;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    void openDetail() => SampleResultPage.openSample(context, index);

    final number = Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: AppColors.gray900)),
      child: Text('${index + 1}', style: AppTextStyles.title18.copyWith(color: AppColors.gray900)),
    );

    final cover = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: openDetail,
        child: SizedBox(
          width: 247,
          height: 247,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(result.coverAsset!, fit: BoxFit.cover),
              Positioned(
                right: 16,
                bottom: 14,
                child: Text(
                  result.name,
                  style: AppTextStyles.title24.copyWith(
                    color: AppColors.screen,
                    fontSize: 22,
                    shadows: const [Shadow(color: Color(0x66000000), blurRadius: 6)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final scenes = Row(
      children: [
        for (var i = 0; i < result.scenes.length; i++) ...[
          if (i > 0) const SizedBox(width: 30),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(result.scenes[i].image, fit: BoxFit.cover),
                  // 피그마: 장면 미리보기는 흐리게(흰색 덮개) + 오른쪽 아래 방향 이름
                  const ColoredBox(color: Color(0xA6FFFFFF)),
                  Positioned(
                    right: 12,
                    bottom: 10,
                    child: Text(
                      result.scenes[i].mode.label,
                      style: AppTextStyles.title16.copyWith(
                        fontSize: 15,
                        color: AppColors.gray900,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );

    final more = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: openDetail,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: AppColors.gray900,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('자세히 보기', style: AppTextStyles.title16.copyWith(color: Colors.white, letterSpacing: 0)),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray400)),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 50),
                number,
                const SizedBox(width: 30),
                cover,
                const SizedBox(width: 50),
                Expanded(child: scenes),
                const SizedBox(width: 30),
                more,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [number, const Spacer(), more]),
                const SizedBox(height: 12),
                cover,
                const SizedBox(height: 12),
                scenes,
              ],
            ),
    );
  }
}

class _SampleBanners extends StatelessWidget {
  const _SampleBanners({required this.showLogin});

  final bool showLogin;

  @override
  Widget build(BuildContext context) {
    final contact = NotchBanner(
      dark: true,
      eyebrow: 'Contact',
      title: '마음에 드는 소재를 발견하셨나요?',
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
      action: AppButton(label: '로그인 하러가기', onPressed: () => showLoginDialog(context)),
    );
    if (Responsive.of(context) != ScreenSize.desktop) {
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
