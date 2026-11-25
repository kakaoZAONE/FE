import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';
import '../../widgets/design_width.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/responsive.dart';

/// Figma `A5 이용 및 데이터 처리 안내 · 공개` (982:5234)
///
/// 이 화면만 Noto Sans KR 와 별도 색(보라 번호, 연노랑 안내)을 쓴다. Figma 그대로 옮겼다.
class DataPolicyPage extends StatelessWidget {
  const DataPolicyPage({super.key});

  static const _ink = Color(0xFF1A1C1F);
  static const _muted = Color(0xFF636B73);
  static const _subtle = Color(0xFF697078);
  static const _purple = Color(0xFF633DC7);
  static const _cardBg = Color(0xFFF4F6F7);
  static const _rule = Color(0xFFDEE0E3);

  static TextStyle _noto(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.gray900,
  }) => TextStyle(
    fontFamily: AppFonts.notoSansKr,
    fontWeight: weight,
    fontSize: size,
    color: color,
  );

  static const _policyCards = [
    (
      '로그인 전 이용할 수 있는 기능',
      '소재 샘플 둘러보기 · 내 사진 등록 · 소재 정보 입력 · AI 분석 확인 · 탐색/변형/조합 결과 보기 · PDF로 받기',
    ),
    ('로그인이 필요한 기능', '사용자 계정에 결과를 저장하거나, 이전에 저장한 탐색 기록을 다시 보려는 경우 인증이 필요합니다.'),
    (
      'AI 분석과 놀이 제안의 성격',
      '사진 기반 특징은 추정될 수 있습니다. 가상 놀이 장면은 실제 실험·위생·안전성 검증이나 소재 제공 승인을 의미하지 않습니다.',
    ),
    ('자원랩 협의의 범위', '실제 소재 제공과 교육 활용 여부는 자원도감 결과와 별개로 자원랩의 공식 연락·검토 과정을 거칩니다.'),
  ];

  static const _dataRows = [
    ('동의 시점', '외부 AI 분석 시작 전 사용자가 필수 동의 내용을 확인합니다.'),
    ('전송되는 정보', '사용자가 등록한 소재 사진과 입력한 소재 정보입니다.'),
    ('이용 목적', '소재의 형태·특성 해석, 놀이 아이디어 및 장면 이미지 생성입니다.'),
    ('업로드 주의', '회사 기밀, 개인 얼굴·연락처, 제3자의 개인정보는 사진에 포함하지 마세요.'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final isDesktop = size == ScreenSize.desktop;
    final isMobile = size == ScreenSize.mobile;
    final padH = Responsive.value<double>(
      context,
      desktop: 80,
      tablet: 40,
      mobile: 20,
    );
    final sectionTitle = _noto(
      isMobile ? 26 : 36,
      weight: FontWeight.w700,
      color: AppColors.gray900,
    );

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SERVICE & DATA  /  이용 안내',
          style: _noto(17, weight: FontWeight.w700),
        ),
        const SizedBox(height: 29),
        Text(
          '사진과 AI 데이터를\n어떻게 다루나요?',
          style: _noto(isMobile ? 32 : 47, weight: FontWeight.w700, color: _ink),
        ),
        const SizedBox(height: 12),
        Text(
          '입력할 정보와 AI 결과의 한계를 미리 살펴보세요.\n분석을 시작하기 전에는 외부 AI 전송에 대한 동의를 받습니다.',
          style: _noto(isMobile ? 16 : 19, color: _subtle),
        ),
      ],
    );

    return PageScaffold(
      // CTA 아래 ~ 푸터: 1857 - 1793 = 64
      bottomGap: 64,
      body: DesignWidth(
        child: Padding(
          padding: EdgeInsets.fromLTRB(padH, 41, padH, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 머리: 제목(왼쪽) + 이용 원칙 요약(오른쪽 493)
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: intro),
                    const SizedBox(width: 24),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: SizedBox(width: 493, child: _Summary()),
                    ),
                  ],
                )
              else ...[
                intro,
                const SizedBox(height: 24),
                const _Summary(),
              ],
              const SizedBox(height: 30),
              const Divider(height: 1, thickness: 1, color: Color(0xFFDEE3E5)),
              const SizedBox(height: 42),
              // 운영 정책 확인 필요
              Container(
                padding: const EdgeInsets.fromLTRB(25, 22, 25, 22),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('운영 정책 확인 필요', style: _noto(20, weight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Text(
                      '현재 화면은 UX 기능 설명입니다. 정식 이용약관·개인정보처리방침과 AI 공급자·보관 기간은 '
                      '운영 주체 검토 후 별도로 확정·게시해야 합니다.',
                      style: _noto(17, color: _muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 72),
              Text('01  서비스 이용 기준', style: sectionTitle),
              const SizedBox(height: 21),
              _CardGrid(
                columns: isMobile ? 1 : 2,
                children: [
                  for (final c in _policyCards)
                    _PolicyCard(title: c.$1, body: c.$2),
                ],
              ),
              const SizedBox(height: 107),
              Text('02  외부 AI 처리 및 사진 주의사항', style: sectionTitle),
              const SizedBox(height: 21),
              Container(
                padding: const EdgeInsets.fromLTRB(26, 27, 30, 42),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < _dataRows.length; i++) ...[
                      if (i > 0)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 10),
                          child: Divider(height: 1, thickness: 1, color: _rule),
                        ),
                      _DataRow(
                        label: _dataRows[i].$1,
                        value: _dataRows[i].$2,
                        stacked: isMobile,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 64),
              Text(
                '기능 이용방법과 샘플 결과를 확인한 다음 소재 사진을 등록해 보세요.',
                style: _noto(isMobile ? 16 : 19, color: _muted),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 21,
                runSpacing: 12,
                children: [
                  _PolicyCta(
                    label: '이용방법 보기',
                    width: 238,
                    onTap: () => AppHeader.goTo(context, AppRoutes.guide),
                  ),
                  _PolicyCta(
                    label: '내 소재 등록하기',
                    width: 267,
                    onTap: () => AppHeader.goTo(context, AppRoutes.register),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 이용 원칙 요약 — #F5F6F7, radius 14, 번호는 보라 #633DC7
class _Summary extends StatelessWidget {
  const _Summary();

  static const _items = ['샘플·분석·PDF는 로그인 없이', '외부 AI 분석 시작 전 동의', 'AI 이미지는 안전성 검증이 아님'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 42, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFDEE3E5),
                ),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 34),
              child: Row(
                children: [
                  SizedBox(
                    width: 54,
                    child: Text(
                      '0${i + 1}',
                      style: DataPolicyPage._noto(
                        18,
                        weight: FontWeight.w700,
                        color: DataPolicyPage._purple,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _items[i],
                      style: DataPolicyPage._noto(
                        17,
                        weight: FontWeight.w500,
                        color: DataPolicyPage._ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardGrid extends StatelessWidget {
  const _CardGrid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      columns: columns,
      gap: 36,
      runGap: 31,
      children: children,
    );
  }
}

/// 정책 카드 — 622 x 193, #F4F6F7, radius 12
class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 193),
      padding: const EdgeInsets.fromLTRB(24, 22, 33, 22),
      decoration: BoxDecoration(
        color: DataPolicyPage._cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: DataPolicyPage._noto(22, weight: FontWeight.w700)),
          const SizedBox(height: 33),
          Text(
            body,
            style: DataPolicyPage._noto(17, color: DataPolicyPage._muted),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    required this.stacked,
  });

  final String label;
  final String value;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final l = Text(label, style: DataPolicyPage._noto(17, weight: FontWeight.w700));
    final v = Text(
      value,
      style: DataPolicyPage._noto(17, color: DataPolicyPage._muted),
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [l, const SizedBox(height: 4), v],
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 39),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 236, child: l),
          Expanded(child: v),
        ],
      ),
    );
  }
}

/// 검정 CTA — 높이 58, radius 9, 글자 17 Bold 왼쪽 21
class _PolicyCta extends StatelessWidget {
  const _PolicyCta({required this.label, required this.width, this.onTap});

  final String label;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: 58,
            padding: const EdgeInsets.only(left: 21),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.gray900,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              label,
              style: DataPolicyPage._noto(
                17,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
