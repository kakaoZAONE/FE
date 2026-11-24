import 'package:flutter/material.dart';

import '../features/sample_result/sample_result_page.dart';
import '../pages/home/home_page.dart';

/// 웹 주소(path) 기반 라우팅.
///
/// 브라우저 주소창·뒤로가기·새로고침이 일반 웹사이트처럼 동작하도록
/// 화면마다 고정 경로를 둔다. 아직 만들지 않은 화면의 경로는
/// 화면을 구현할 때 이곳에 추가한다. (docs/DEVELOPMENT_PLAN.md 참고)
abstract final class AppRoutes {
  static const home = '/';
  static const samples = '/samples';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final page = switch (_normalize(settings.name)) {
      samples => const SampleResultPage(),
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
