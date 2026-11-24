import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/notch_clipper.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/sized_asset_image.dart';
import '../home_assets.dart';
import 'section_heading.dart';

/// "자원도감은 이런 과정을 거칩니다" — 01~03 카드
/// 데스크톱 3열 / 태블릿 2열 / 모바일 1열
class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  // 카드 위쪽 그라데이션 (Figma div.absolute)
  static const _darkShade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x99000000),
      Color(0x80000000),
      Color(0x38000000),
      Color(0x00000000),
    ],
    stops: [0, 0.133, 0.333, 0.613],
  );
  static const _lightShade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x38000000), Color(0x00000000)],
    stops: [0, 0.613],
  );

  static final _steps = [
    (
      '01',
      '번거로운 입력대신 소재 사진으로',
      '사진 한 장이면 자원도감을 시작할 수 있어요\n크기나 재질 같은 정보는 아는 만큼만 입력해주세요!',
      SizedAssetImage(HomeAssets.processCard),
      _darkShade,
    ),
    (
      '02',
      '정확한 결과를 위해 검토해주세요',
      'AI가 사진에서 읽은 특징을 확인하고\n실제와 다르면 직접 수정할 수 있어요!',
      const _MaterialPreviewArt(),
      _lightShade,
    ),
    (
      '03',
      '더욱 확장된 놀이 장면 제안',
      '탐색·변형·조합 세 방향의 놀이 확장을\n기업만의 자료로 받아보고 PDF로 저장할 수 있어요',
      SizedAssetImage(HomeAssets.paperTube[2]),
      _darkShade,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.value(context, desktop: 3, tablet: 2, mobile: 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          eyebrow: '자원도감은 어떤 서비스인가요?',
          title: '자원도감은 이런 과정을 거칩니다',
        ),
        SizedBox(
          height: Responsive.value<double>(context, desktop: 40, mobile: 24),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.gray500)),
          ),
          child: ResponsiveGrid(
            columns: columns,
            gap: 20,
            runGap: 0,
            children: [
              for (final step in _steps)
                _ProcessCard(
                  number: step.$1,
                  title: step.$2,
                  body: step.$3,
                  art: step.$4,
                  shade: step.$5,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({
    required this.number,
    required this.title,
    required this.body,
    required this.art,
    required this.shade,
  });

  final String number;
  final String title;
  final String body;
  final Widget art;
  final Gradient shade;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.of(context) == ScreenSize.mobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipPath(
          // 피그마 마스크 path: M0 0 H294.938 L347.763 67.1748 H427 (폭 427 기준)
          clipper: NotchClipper(
            notchStart: (s) => s.width * 294.938 / 427,
            notchEnd: (s) => s.width * 347.763 / 427,
            notchDepth: 67.1748,
          ),
          child: AspectRatio(
            // 피그마 427 x 428
            aspectRatio: 427 / 428,
            child: Stack(
              fit: StackFit.expand,
              children: [
                art,
                DecoratedBox(decoration: BoxDecoration(gradient: shade)),
                // 번호 배지: 검정 채움 + 흰 글자, 안쪽 10
                Positioned(
                  left: 25,
                  top: 25,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.gray900,
                      border: Border.all(color: AppColors.gray900),
                    ),
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontFamily: AppFonts.pretendard,
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        height: 25 / 24,
                        color: AppColors.screen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, isMobile ? 32 : 50),
          decoration: const BoxDecoration(
            color: AppColors.screen,
            border: Border(left: BorderSide(color: AppColors.gray300)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.title24.copyWith(
                  fontSize: isMobile ? 20 : 24,
                ),
              ),
              const SizedBox(height: 15),
              Text(body, style: AppTextStyles.body15.copyWith(height: 20 / 15)),
            ],
          ),
        ),
      ],
    );
  }
}

/// 카드 02 그림: 흰 바탕 가운데 '소재 정보 확인' 표 (Figma 964:2990)
///
/// 실제 입력 화면을 축소해 보여 주는 설명용 그림이다. 이미지 에셋이 아니라
/// 레이어로 그려져 있어 Flutter 위젯으로 같은 크기(폭 380)로 그린 뒤
/// 카드 폭(427)에 맞춰 비율대로 축소한다.
class _MaterialPreviewArt extends StatelessWidget {
  const _MaterialPreviewArt();

  static const _input = (Color(0xFFE8F5EC), Color(0xFF2E7D4F), '입력');
  static const _ai = (Color(0xFFEBEBEB), Color(0xFF939393), 'AI 추정');
  static const _check = (AppColors.gray50, Color(0xFFE00052), '확인 필요');

  static const _rows = [
    ('분류', '종이·판지', _input, false),
    ('형태', '원통형', _input, false),
    ('발생 원인', '섬유 제조 · 원단 가공', _input, false),
    ('재질', '종이(크라프트)', _input, false),
    ('알아보고 싶은 활용', '유아 대상 놀이 프로그램', _input, false),
    ('알려진 제약', '절단면이 거칠 수 있음', _input, false),
    ('구조', '속이 빈 원통 형태', _ai, false),
    ('특성', '세우면 자립, 바닥에서 잘 굴러감', _ai, false),
    ('강도 · 코팅 · 위생', '사진으로 확인할 수 없음', _check, true),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / 427;
          return Center(
            child: SizedBox(
              width: 380 * scale,
              child: FittedBox(fit: BoxFit.fitWidth, child: _table()),
            ),
          );
        },
      ),
    );
  }

  Widget _table() {
    const base = TextStyle(
      fontFamily: AppFonts.notoSansKr,
      fontSize: 7.611,
      height: 1.4,
      letterSpacing: -0.1142,
    );
    return Container(
      width: 380,
      padding: const EdgeInsets.all(10.873),
      decoration: const BoxDecoration(
        color: AppColors.screen,
        // Figma drop-shadow 0 8 12 rgba(0,0,0,0.08)
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 8),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in _rows)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5.98),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.gray100, width: 0.544),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 81.545,
                    child: Text(
                      row.$1,
                      style: base.copyWith(color: AppColors.gray500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.$2,
                      style: base.copyWith(
                        fontWeight: FontWeight.w500,
                        color: row.$4 ? AppColors.gray400 : AppColors.gray900,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.349,
                      vertical: 2.175,
                    ),
                    decoration: BoxDecoration(
                      color: row.$3.$1,
                      borderRadius: BorderRadius.circular(3.262),
                    ),
                    child: Text(
                      row.$3.$3,
                      style: TextStyle(
                        fontFamily: AppFonts.notoSansKr,
                        fontWeight: FontWeight.w700,
                        fontSize: 6.524,
                        height: 1.2,
                        color: row.$3.$2,
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
}
