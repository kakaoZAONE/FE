import 'package:flutter/material.dart';

import '../../../core/external_links.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/notch_banner.dart';

/// 결과 아래 배너
///
/// - 로그인 전 (C1 787:14545 · 787:14533): [Login(밝은) 651] 18.6 [Contact(어두운) 651]
/// - 로그인 후 (C1-1 1033:2363): Contact 1320 하나, 제목이 바뀐다
class ResultBanners extends StatelessWidget {
  const ResultBanners({
    super.key,
    required this.showLogin,
    required this.row,
    required this.onLogin,
  });

  final bool showLogin;

  /// 데스크톱이면 두 배너를 나란히
  final bool row;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final contact = NotchBanner(
      dark: true,
      eyebrow: 'Contact',
      title: showLogin
          ? '결과가 마음에 드신다면'
          : '마음에 드는 소재를 발견하셨나요? ZAONE LAB에 문의해 보세요.',
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
          // Figma: Login 60~729 · Contact 729.6~1380.6 → 사이 약 18.6
          const SizedBox(width: 18.6),
          Expanded(child: contact),
        ],
      ),
    );
  }
}
