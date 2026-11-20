import 'package:flutter/gestures.dart';
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

    // 히어로 슬라이드 타이머 정리
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('아래 섹션은 스크롤해서 화면에 들어오면 나타난다', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    double opacityOf(String text) => tester
        .widget<FadeTransition>(
          find
              .ancestor(
                of: find.text(text),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;

    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(opacityOf('소재별 결과를 먼저 확인해 보세요'), 0);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -1200),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(opacityOf('소재별 결과를 먼저 확인해 보세요'), 1);

    // 히어로 슬라이드 타이머 정리
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('마우스 휠 한 칸은 2배 거리로 부드럽게, 작은 입력은 그대로 스크롤된다', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    final scrollable = find.byType(Scrollable).first;
    double pixels() =>
        tester.state<ScrollableState>(scrollable).position.pixels;
    final center = tester.getCenter(scrollable);

    Future<void> frames(int count) async {
      for (var i = 0; i < count; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
    }

    Future<void> wheel(double dy) => tester.sendEventToBinding(
      PointerScrollEvent(position: center, scrollDelta: Offset(0, dy)),
    );

    // 휠 한 칸(100) → 200 이동, 한 번에 점프하지 않고 프레임마다 조금씩
    await wheel(100);
    await frames(3);
    expect(pixels(), inExclusiveRange(0, 200));
    await frames(60);
    expect(pixels(), 200);

    // 연속으로 두 칸 굴리면 목표가 이어서 쌓임 → 200 + 400
    await wheel(100);
    await frames(2);
    await wheel(100);
    await frames(60);
    expect(pixels(), 600);

    // 트랙패드처럼 작은 입력(10) → 그대로 10
    await wheel(10);
    await tester.pump();
    expect(pixels(), 610);

    await tester.pumpWidget(const SizedBox());
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

    // 히어로 슬라이드 타이머 정리
    await tester.pumpWidget(const SizedBox());
  });
}
