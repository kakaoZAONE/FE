import 'package:flutter/material.dart';

import 'pages/home/home_page.dart';
import 'theme/app_text_styles.dart';

void main() {
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
      home: const HomePage(),
    );
  }
}
