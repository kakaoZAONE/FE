import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/external_links.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/design_width.dart';
import '../../widgets/notch_banner.dart';
import '../../widgets/notch_image.dart';
import '../../widgets/number_tag.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';
import '../home/home_assets.dart';
import '../home/sections/section_heading.dart';

/// Figma `A4 자원랩 소개` (992:7373)
///
/// 히어로 → 자원/자원랩 비교 → 대표 인용 → 놀이가 되기까지 3단계 → Contact 배너
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final sectionPad = EdgeInsets.all(pad);
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;

    return PageScaffold(
      // Contact 배너 배경(289) 아래 ~ 푸터: 3392 - (111 + 2910 + 289) = 82
      bottomGap: 82,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _AboutHero(),
          const SizedBox(height: 40),
          DesignWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 자원과 자원랩
                Padding(
                  padding: sectionPad,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionHeading(title: '자원과 자원랩, 무엇이 다른가요?'),
                      const SizedBox(height: 40),
                      _pair(
                        isDesktop,
                        const _OrgCard(
                          tag: 'ZAONE',
                          title: '자원 ZAONE',
                          body: TextSpan(
                            children: [
                              TextSpan(
                                text: '비영리 기관으로 생산·유통 과정에서 다음 쓰임을 찾지 못한 ',
                              ),
                              TextSpan(
                                text: '휴면자원',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: '을 발굴하고\n놀이가능성을 더해 교육 현장과 연결해요.'),
                            ],
                          ),
                        ),
                        const _OrgCard(
                          tag: 'ZAONE LAB',
                          title: '자원랩 ZAONE LAB',
                          body: TextSpan(
                            text:
                                '교육 실험 공간으로 정해진 사용법이 없는 재료를 직접 만지고 결합하는 공간이에요. \n'
                                '어린이·교사·기업·성인 모두를 위한 프로그램을 운영해요.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(padding: sectionPad, child: const _Quote()),
                const SizedBox(height: 40),
                Padding(padding: sectionPad, child: const _Journey()),
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: NotchBanner(
                    // 피그마 배경 div 높이 289 (마스크 그룹 314보다 낮음)
                    minHeight: 0,
                    eyebrow: 'Contact',
                    title: 'ZAONE LAB과 함께하고 싶다면',
                    body:
                        '자원도감의 장면은 AI가 만든 가상 예시예요. '
                        '실제 소재 제공과 교육 활용은 자원랩의 공식 협의로 진행돼요.',
                    action: AppButton(
                      label: 'ZAONE LAB 바로가기',
                      onPressed: () =>
                          ExternalLinks.open(ExternalLinks.zaoneLab),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _pair(bool row, Widget a, Widget b) {
    if (!row) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [a, const SizedBox(height: 40), b],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: 40),
        Expanded(child: b),
      ],
    );
  }
}

/// 히어로 640 — 사진 위 흰색 그라데이션(0 → 80%), 글자는 진한색
class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final isDesktop = Responsive.of(context) == ScreenSize.desktop;
    final padH = Responsive.value<double>(
      context,
      desktop: 80,
      tablet: 48,
      mobile: 20,
    );
    final titleSize = Responsive.value<double>(
      context,
      desktop: 48,
      tablet: 40,
      mobile: 30,
    );
    final body = AppTextStyles.title18.copyWith(
      color: AppColors.gray900,
      fontSize: isMobile ? 15 : 18,
      height: isMobile ? 22 / 15 : 25 / 18,
    );

    return SizedBox(
      height: Responsive.value<double>(
        context,
        desktop: 640,
        tablet: 560,
        mobile: 520,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 피그마: 이미지 높이 225%, top -25.5% → 위쪽 25.5/125 지점 기준으로 잘림
          Image.asset(
            HomeAssets.sceneExplore,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.6),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00FFFFFF), Color(0xCCFFFFFF)],
              ),
            ),
          ),
          DesignWidth(
            child: Padding(
              // 피그마(1096:6107): 글자 묶음 left 80 · top 309 / 640
              padding: EdgeInsets.fromLTRB(
                padH,
                isDesktop ? 309 : 0,
                padH,
                isMobile ? 40 : 0,
              ),
              child: Align(
                alignment: isDesktop
                    ? Alignment.topLeft
                    : isMobile
                    ? Alignment.bottomLeft
                    : const Alignment(-1, 0.62),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ABOUT ZAONE LAB', style: body),
                    const SizedBox(height: 20),
                    Text(
                      '쓸모를 다한 재료에서,\n정답 없는 놀이가 시작돼요',
                      style: AppTextStyles.heroTitle.copyWith(
                        color: AppColors.gray900,
                        fontSize: titleSize,
                        letterSpacing: titleSize * -0.03,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '자원랩은 기업에서 남은 휴면자원을 어린이의 열린 놀이 재료로 바꾸는 비영리 교육·실험 공간이에요.',
                      style: body,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: isMobile ? 12 : 30,
                      runSpacing: 12,
                      children: [
                        AppButton(
                          label: '자원도감 시작하기',
                          onPressed: () =>
                              AppHeader.goTo(context, AppRoutes.register),
                        ),
                        AppButton(
                          label: 'ZAONE LAB 방문하기',
                          variant: AppButtonVariant.light,
                          onPressed: () =>
                              ExternalLinks.open(ExternalLinks.zaoneLab),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 이미지(640 x 333, 사선 마스크) + 설명(249, 왼쪽 세로선)
class _OrgCard extends StatelessWidget {
  const _OrgCard({required this.tag, required this.title, required this.body});

  final String tag;
  final String title;
  final TextSpan body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // TODO(디자인): 자원랩 카드 이미지는 '확인 후 자원랩 이미지 첨부 예정'(Figma 메모)
        NotchImage(
          image: HomeAssets.processCard,
          tag: tag,
          aspectRatio: 640 / 333,
          // Figma 1094:5906: 1000x928 사진을 640x428로 늘려 채우고 위 333만 보임
          fillAspectRatio: 640 / 427.81,
        ),
        LeftRuleCard(
          // 피그마 설명 칸 높이 249 (데스크톱)
          height: Responsive.of(context) == ScreenSize.desktop ? 249 : null,
          padding: const EdgeInsets.all(20),
          gap: 20,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppFonts.pretendard,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                height: AppTextStyles.pretendardNormal,
                letterSpacing: -0.56,
                color: AppColors.gray900,
              ),
            ),
            Text.rich(
              body,
              style: const TextStyle(
                fontFamily: AppFonts.pretendard,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 1.5,
                color: AppColors.gray900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 대표 인용 — gray/50, radius 32, 좌우 56 · 상하 48, 간격 16
class _Quote extends StatelessWidget {
  const _Quote();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 56,
        vertical: isMobile ? 32 : 48,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이수영 · 자원랩 대표',
            style: TextStyle(
              fontFamily: AppFonts.pretendard,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 1.5,
              letterSpacing: -0.36,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '“중요한 것은 능력의 유무보다 어떤 환경에서\n잠재된 창의성이 발현될 수 있느냐입니다.”',
            style: TextStyle(
              fontFamily: AppFonts.pretendard,
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 22 : 32,
              height: 1.45,
              letterSpacing: isMobile ? -0.44 : -0.64,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '“무엇을 만들면 되나요?” 대신, 아이가 놀이의 시간·공간·방향을 스스로 정하는 '
            '‘놀이설계자’가 되도록 자원랩은 정답 대신 재료와 환경을 준비해요.',
            style: TextStyle(
              fontFamily: AppFonts.pretendard,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 1.6,
              letterSpacing: -0.36,
              color: AppColors.gray800,
            ),
          ),
        ],
      ),
    );
  }
}

/// 휴면자원이 아이들의 놀이가 되기까지 — 3단계 카드 + 휴면자원이란?
class _Journey extends StatelessWidget {
  const _Journey();

  static const _steps = [
    ('01', '기업의 휴면자원을 발견해요', '쓰임을 잃은 소재를 찾고\n직접 받아 상태를 확인해요.'),
    ('02', '만지고 실험해요', '손질과 안전 검토를 거쳐\n놀이가능성을 찾아요.'),
    ('03', '교육 현장과 연결해요', '연령·인원·공간에 맞는 소재를\n프로그램으로 이어가요.'),
  ];

  static const _images = [
    'assets/images/home/sample_paper_tube_main.png',
    HomeAssets.sceneTransform,
    HomeAssets.sceneCombine,
  ];

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.value<int>(
      context,
      desktop: 3,
      tablet: 3,
      mobile: 1,
    );
    final cards = [
      for (var i = 0; i < _steps.length; i++)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NotchImage(
              image: _images[i],
              tag: _steps[i].$1,
              aspectRatio: 427 / 428,
              shade: NotchImage.topShade,
              tagFontFamily: AppFonts.notoSansKr,
            ),
            LeftRuleCard(
              children: [
                Text(
                  _steps[i].$2,
                  style: const TextStyle(
                    fontFamily: AppFonts.notoSansKr,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    // 피그마 카드 높이 582 = 사진 428 + 글 154 → 제목 줄 높이 약 28.8
                    height: 1.2,
                    letterSpacing: -0.48,
                    color: AppColors.gray900,
                  ),
                ),
                Text(
                  _steps[i].$3,
                  style: const TextStyle(
                    fontFamily: AppFonts.notoSansKr,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    height: 20 / 15,
                    color: AppColors.gray900,
                  ),
                ),
              ],
            ),
          ],
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '휴면자원이 아이들의 놀이가 되기까지',
          style: TextStyle(
            fontFamily: AppFonts.notoSansKr,
            fontWeight: FontWeight.w700,
            fontSize: 40,
            height: 1.3,
            letterSpacing: -0.8,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 40),
        ResponsiveGrid(columns: columns, children: cards),
        const SizedBox(height: 40),
        const _DormantNote(),
      ],
    );
  }
}

/// 휴면자원이란? — 1px gray/300 테두리, 좌우 32 · 상하 24, radius 2
class _DormantNote extends StatelessWidget {
  const _DormantNote();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    const label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Figma glyphs:box-1 (1100:6124) — SVG를 40px 기준 3배 PNG로 변환
        Image(image: AssetImage(AppIcons.box), width: 40, height: 40),
        SizedBox(width: 10),
        Text(
          '휴면자원이란?',
          style: TextStyle(
            fontFamily: AppFonts.pretendard,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            height: 1.5,
            letterSpacing: -0.44,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
    const desc = Text(
      '아직 쓸 수 있지만 다음 쓰임을 찾지 못한 채 보관되거나 버려지는 소재예요. '
      '포장재, 공정 부산물, 재고 자재처럼 형태와 물성이 그대로 남아 있어요.',
      style: TextStyle(
        fontFamily: AppFonts.pretendard,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        height: 1.5,
        letterSpacing: -0.36,
        color: AppColors.gray600,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray300),
        borderRadius: BorderRadius.circular(2),
      ),
      child: isMobile
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [label, SizedBox(height: 12), desc],
            )
          : const Row(
              children: [
                label,
                SizedBox(width: 24),
                Expanded(child: desc),
              ],
            ),
    );
  }
}
