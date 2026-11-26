import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/design_width.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';

/// Figma `D2-1 서비스안내` (1100:10398) — 회원가입 동의 '자세히' 링크로 들어온다.
///
/// 이 화면은 Noto Sans KR. 1440 기준 y: 서비스 안내 139 → 제목 188 → 설명 250
/// → 카드 315부터 133 + 간격 20 → 푸터 1140.
class ServiceInfoPage extends StatelessWidget {
  const ServiceInfoPage({super.key});

  static const _green = Color(0xFF2E7D4F);

  static const _items = [
    (
      '서비스가 하는 일',
      '기업이 보유한 소재의 사진과 정보를 바탕으로 놀이 가능성을 가상 장면으로 보여주는 탐색 도구예요. 안전성이나 실제 사용 가능 여부를 판정하지 않아요.',
    ),
    (
      '외부 AI 처리와 사진 전송',
      '분석과 장면 생성을 위해 사진과 입력 정보를 외부 AI 서비스로 보내요. 보내기 전에 꼭 동의를 받아요.',
    ),
    ('보관 기간', '저장하지 않은 결과는 창을 닫으면 사라져요. 저장한 결과는 내 탐색 기록에서 언제든 지울 수 있어요.'),
    ('올리면 안 되는 정보', '회사 로고, 내부 문서, 사람 얼굴, 연락처처럼 민감한 정보가 담긴 사진은 올리지 말아 주세요.'),
    ('실제 소재 제공', '결과는 참고용이에요. 실제 소재 제공과 교육 활용은 자원랩의 공식 문의와 검토를 거쳐요.'),
  ];

  static TextStyle _noto(
    double size,
    FontWeight weight,
    double height,
    double spacing,
    Color color,
  ) => TextStyle(
    fontFamily: AppFonts.notoSansKr,
    fontWeight: weight,
    fontSize: size,
    height: height,
    letterSpacing: size * spacing,
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final isMobile = Responsive.of(context) == ScreenSize.mobile;
    final subSize = isMobile ? 15.0 : 22.0;

    // 24 Bold, 줄 높이 1.35, 자간 -2%
    final title24 = _noto(24, FontWeight.w700, 1.35, -0.02, AppColors.gray900);

    return PageScaffold(
      // content 아래 여백 80
      bottomGap: 80,
      body: DesignWidth(
        child: Padding(
          // 헤더(110) 아래 29 → '서비스 안내' top 139
          padding: EdgeInsets.fromLTRB(pad, 29, pad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '서비스 안내',
                style: _noto(
                  subSize,
                  FontWeight.w500,
                  1.6,
                  -0.01,
                  AppColors.gray600,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '이용 및 AI·데이터 처리 안내',
                style: _noto(
                  isMobile ? 26 : 40,
                  FontWeight.w700,
                  1.3,
                  -0.02,
                  AppColors.gray900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '자원도감이 사진과 정보를 어떻게 쓰는지 알기 쉽게 정리했어요.',
                style: _noto(
                  subSize,
                  FontWeight.w400,
                  1.5,
                  -0.01,
                  AppColors.gray600,
                ),
              ),
              const SizedBox(height: 32),
              for (var i = 0; i < _items.length; i++) ...[
                if (i > 0) const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(isMobile ? 20 : 32),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('0${i + 1}', style: title24.copyWith(color: _green)),
                      SizedBox(width: isMobile ? 16 : 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_items[i].$1, style: title24),
                            const SizedBox(height: 8),
                            Text(
                              _items[i].$2,
                              style: _noto(
                                isMobile ? 15 : 18,
                                FontWeight.w500,
                                1.6,
                                -0.01,
                                AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
