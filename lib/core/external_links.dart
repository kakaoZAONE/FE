import 'package:url_launcher/url_launcher.dart';

/// 서비스에서 여는 외부 공식 주소 (2026-11-24 접속 확인)
abstract final class ExternalLinks {
  /// 자원랩 소개 — 'ZAONE LAB 바로가기'
  static final zaoneLab = Uri.parse('https://www.zaone.org/zaone-lab');

  /// 자원 공식 문의 페이지 — 푸터 '자원랩 공식 문의'
  static final zaoneContact = Uri.parse('https://www.zaone.org/contact');

  /// 새 탭으로 연다.
  static Future<bool> open(Uri uri) =>
      launchUrl(uri, webOnlyWindowName: '_blank');
}
