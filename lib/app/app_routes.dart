import 'package:flutter/material.dart';

import '../features/auth/service_info_page.dart';
import '../features/auth/signup_page.dart';
import '../features/history/history_page.dart';
import '../features/register/register_page.dart';
import '../features/result/result_page.dart';
import '../features/sample_result/sample_result_page.dart';
import '../pages/about/about_page.dart';
import '../pages/guide/guide_page.dart';
import '../pages/home/home_page.dart';
import '../pages/policy/data_policy_page.dart';

/// 웹 주소(path) 기반 라우팅.
///
/// 브라우저 주소창·뒤로가기·새로고침이 일반 웹사이트처럼 동작하도록
/// 화면마다 고정 경로를 둔다. 아직 만들지 않은 화면의 경로는
/// 화면을 구현할 때 이곳에 추가한다. (docs/DEVELOPMENT_PLAN.md 참고)
abstract final class AppRoutes {
  static const home = '/';
  static const samples = '/samples';
  static const guide = '/guide';
  static const about = '/about';
  static const dataPolicy = '/data-policy';
  static const signup = '/signup';
  static const serviceInfo = '/service-info';
  static const register = '/register';
  static const history = '/my/history';
  static const my = '/my';

  /// 결과 화면: /result/<id>
  static String resultPath(String id) => '/result/$id';

  /// 탐색 기록 상세: /my/history/<id>
  static String historyPath(String id) => '$history/$id';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final path = _normalize(settings.name);
    if (path.startsWith('$history/')) {
      final id = path.substring(history.length + 1);
      return MaterialPageRoute<void>(
        builder: (_) => HistoryDetailPage(resultId: id),
        settings: settings,
      );
    }
    if (path.startsWith('/result/')) {
      final id = path.substring('/result/'.length);
      return MaterialPageRoute<void>(
        builder: (_) => ResultPage(resultId: id),
        settings: settings,
      );
    }
    final page = switch (path) {
      samples => const SampleResultPage(),
      guide => const GuidePage(),
      about => const AboutPage(),
      dataPolicy => const DataPolicyPage(),
      signup => const SignupPage(),
      serviceInfo => const ServiceInfoPage(),
      register => const RegisterPage(),
      history => const HistoryPage(),
      my => const HistoryPage(),
      // 알 수 없는 주소는 메인으로
      _ => const HomePage(),
    };
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }

  /// '/samples/' · '/samples?x=1' 처럼 들어와도 같은 화면으로 본다.
  static String _normalize(String? name) {
    if (name == null || name.isEmpty) return home;
    var path = Uri.tryParse(name)?.path ?? name;
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path.isEmpty ? home : path;
  }
}
