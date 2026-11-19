import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakaozaone_fe/main.dart';

void main() {
  testWidgets('메인 페이지 주요 섹션이 렌더링된다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    expect(find.text('자원도감은 이런 과정을 거칩니다'), findsOneWidget);
    expect(find.text('소재별 결과를 먼저 확인해 보세요'), findsOneWidget);
    expect(find.text('원래 쓰임에서는 떠올리기 어려운 활용을 제안합니다'), findsOneWidget);
    expect(find.text('결과가 마음에 드신다면'), findsOneWidget);
  });

  testWidgets('로그인을 누르면 로그인 창이 뜨고 나가기로 닫힌다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();

    expect(find.text('기업명'), findsOneWidget);
    expect(find.text('비밀번호'), findsOneWidget);

    await tester.tap(find.text('나가기'));
    await tester.pumpAndSettle();
    expect(find.text('기업명'), findsNothing);
  });
}
