import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/notch_clipper.dart';
import '../home_assets.dart';
import 'section_heading.dart';

/// "자원도감은 이런 과정을 거칩니다" — 01~03 카드
class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  static const _steps = [
    (
      '01',
      '번거로운 입력대신 소재 사진으로',
      '사진 한 장이면 자원도감을 시작할 수 있어요\n크기나 재질 같은 정보는 아는 만큼만 입력해주세요!',
    ),
    (
      '02',
      '정확한 결과를 위해 검토해주세요',
      'AI가 사진에서 읽은 특징을 확인하고\n실제와 다르면 직접 수정할 수 있어요!',
    ),
    (
      '03',
      '더욱 확장된 놀이 장면 제안',
      '탐색·변형·조합 세 방향의 놀이 확장을\n기업만의 자료로 받아보고 PDF로 저장할 수 있어요',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          eyebrow: '자원도감은 어떤 서비스인가요?',
          title: '자원도감은 이런 과정을 거칩니다',
        ),
        const SizedBox(height: 40),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.gray500)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _steps.length; i++) ...[
                if (i > 0) const SizedBox(width: 20),
                _ProcessCard(
                  number: _steps[i].$1,
                  title: _steps[i].$2,
                  body: _steps[i].$3,
                ),
              ],
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
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 427,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: NotchClipper(
              notchStart: (s) => s.width * 0.686,
              notchEnd: (s) => s.width * 0.808,
              notchDepth: 66,
            ),
            child: SizedBox(
              height: 428,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(HomeAssets.processCard, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x99000000),
                          Color(0x80000000),
                          Color(0x38000000),
                          Color(0x00000000),
                        ],
                        stops: [0, 0.133, 0.333, 0.613],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    top: 25,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.screen),
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
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
            decoration: const BoxDecoration(
              color: AppColors.screen,
              border: Border(left: BorderSide(color: AppColors.gray300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title24),
                const SizedBox(height: 15),
                Text(
                  body,
                  style: AppTextStyles.body15.copyWith(height: 20 / 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
