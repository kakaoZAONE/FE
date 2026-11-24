import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app_routes.dart';
import 'theme/app_text_styles.dart';

void main() {
  // 주소에 '#' 없이 /samples 처럼 쓰기 (Vercel rewrites로 새로고침 지원)
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '자원도감',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppFonts.pretendard,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
