import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakaozaone_fe/app/app_routes.dart';
import 'package:kakaozaone_fe/features/register/register_page.dart';
import 'package:kakaozaone_fe/pages/guide/guide_page.dart';
import 'package:kakaozaone_fe/widgets/login_dialog.dart';

/// A3 · A4 · A5 안내 페이지 안의 링크와 버튼, 로그인/회원가입 창 넘침
void main() {
  Widget route(String path) => MaterialApp(
    initialRoute: path,
    onGenerateRoute: AppRoutes.onGenerateRoute,
  );

  void size(WidgetTester tester, double width) {
    tester.view.physicalSize = Size(width, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('A5 \'이용방법 보기\' → 이용 안내, \'내 소재 등록하기\' → 등록', (tester) async {
    size(tester, 1440);
    await tester.pumpWidget(route(AppRoutes.dataPolicy));
    await tester.tap(find.text('이용방법 보기'));
    await tester.pumpAndSettle();
    expect(find.byType(GuidePage), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(route(AppRoutes.dataPolicy));
    await tester.tap(find.text('내 소재 등록하기').last);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('A4 \'자원도감 시작하기\' → 등록', (tester) async {
    size(tester, 1440);
    await tester.pumpWidget(route(AppRoutes.about));
    await tester.tap(find.text('자원도감 시작하기'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('A3 \'로그인 하러가기\' → 로그인 창', (tester) async {
    size(tester, 1440);
    await tester.pumpWidget(route(AppRoutes.guide));
    await tester.tap(find.text('로그인 하러가기'));
    await tester.pumpAndSettle();
    expect(find.text('이메일'), findsOneWidget);
    expect(find.text('계정 만들기'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final width in const [390.0, 1440.0]) {
    testWidgets('폭 ${width.toInt()}px 에서 로그인 · 회원가입 창이 넘치지 않는다', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(route(AppRoutes.guide));
      final context = tester.element(find.byType(GuidePage));
      showLoginDialog(context, title: '결과를 저장하려면 로그인해 주세요');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('계정 만들기'));
      await tester.pumpAndSettle();
      expect(find.text('기업명'), findsOneWidget);
      expect(tester.takeException(), isNull);

      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    });
  }
}
