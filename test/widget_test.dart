import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakaozaone_fe/app/app_routes.dart';
import 'package:kakaozaone_fe/features/auth/auth_state.dart';
import 'package:kakaozaone_fe/features/register/register_page.dart';
import 'package:kakaozaone_fe/features/sample_result/sample_result_page.dart';
import 'package:kakaozaone_fe/main.dart';
import 'package:kakaozaone_fe/pages/home/home_page.dart';
import 'package:kakaozaone_fe/pages/home/sections/sample_section.dart';

void main() {
  testWidgets('헤더의 샘플 둘러보기 메뉴가 결과 페이지(/samples)를 연다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    expect(
      tester.takeException(),
      isNull,
      reason: 'home screen should not overflow',
    );

    await tester.tap(find.text('샘플 둘러보기').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(SampleResultPage), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'sample result screen should not overflow',
    );

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('소재별 결과의 전체보기 버튼이 결과 페이지를 연다', (tester) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(
          body: SingleChildScrollView(child: SampleSection()),
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
    await tester.tap(find.text('전체보기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(SampleResultPage), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('샘플 사진을 누르면 해당 소재 상세(결과 화면)가 열린다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: SampleResultPage(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
    await tester.tap(find.text('종이관'));
    await tester.pumpAndSettle();
    expect(find.text('관으로 소리 주고받기'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('지퍼 자투리'));
    await tester.pumpAndSettle();
    expect(find.text('지퍼의 색과 길이 탐색하기'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('메인 페이지 주요 섹션이 렌더링된다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    expect(find.text('자원도감은 이런 과정을 거칩니다'), findsOneWidget);
    expect(find.text('소재별 결과를 먼저 확인해 보세요'), findsOneWidget);
    expect(find.text('원래 쓰임에서는 떠올리기 어려운 활용을 제안합니다'), findsOneWidget);
    expect(find.text('마음에 드는 소재를 발견하셨나요? ZAONE LAB에 문의해 보세요.'), findsOneWidget);

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

  testWidgets('로그인을 누르면 로그인 창이 뜨고 취소로 닫힌다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('이메일'), findsOneWidget);
    expect(find.text('비밀번호'), findsOneWidget);

    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(find.text('이메일'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('메인 섹션은 최종 Figma 순서(샘플 → 과정 → 활용 → 문의)로 놓인다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    // 스크롤 등장 애니메이션(아래 40px → 제자리)이 끝난 뒤 위치 비교
    await tester.pumpAndSettle();
    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    final sample = top('소재별 결과를 먼저 확인해 보세요');
    final process = top('자원도감은 이런 과정을 거칩니다');
    final scene = top('원래 쓰임에서는 떠올리기 어려운 활용을 제안합니다');
    final contact = top('마음에 드는 소재를 발견하셨나요? ZAONE LAB에 문의해 보세요.');
    expect(sample, lessThan(process));
    expect(process, lessThan(scene));
    expect(scene, lessThan(contact));
    // 피그마: 샘플 섹션 제목 y = 110(header) + 680(hero) + 106
    expect(sample, 896);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('해외 실제 사례 관련 문구·배지가 메인과 샘플 결과에 없다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final overseas = find.textContaining('해외');
    await tester.pumpWidget(const MyApp());
    expect(overseas, findsNothing);

    await tester.pumpWidget(const MaterialApp(home: SampleResultPage()));
    expect(overseas, findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('주소로 바로 들어와도 해당 화면이 열리고, 모르는 주소는 메인으로 간다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    Widget app(String initial) => MaterialApp(
      key: ValueKey(initial),
      initialRoute: initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );

    await tester.pumpWidget(app('/samples'));
    expect(find.byType(SampleResultPage), findsOneWidget);
    // 새로고침한 /samples 에서도 뒤로가기는 메인으로
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    expect(navigator.canPop(), isTrue);

    await tester.pumpWidget(app('/samples/'));
    expect(find.byType(SampleResultPage), findsOneWidget);

    await tester.pumpWidget(app('/no-such-page'));
    expect(find.byType(HomePage), findsWidgets);
    expect(find.byType(SampleResultPage), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('메인 샘플 카드를 누르면 해당 소재 상세가 열린다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('지퍼 자투리'));
    await tester.pumpAndSettle();
    expect(find.text('지퍼의 색과 길이 탐색하기'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('내 소재 등록하기를 누르면 사진 등록 화면이 열린다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('내 소재 등록하기').first);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.text('소재 사진을 등록해 주세요'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('헤더 메뉴로 이용 안내 · 자원랩 소개 화면이 열린다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('이용 안내').first);
    await tester.pumpAndSettle();
    expect(find.text('부담없이 시작해보세요!'), findsOneWidget);

    await tester.tap(find.text('자원랩 소개').first);
    await tester.pumpAndSettle();
    expect(find.text('자원과 자원랩, 무엇이 다른가요?'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('로그인하면 헤더에 내 탐색기록이 보인다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(AuthState.instance.signOut);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'zaone@company.com');
    await tester.enterText(find.byType(TextField).at(1), 'pass1234');
    await tester.pump();
    await tester.tap(find.text('로그인').last);
    await tester.pumpAndSettle();

    expect(find.text('내 탐색기록'), findsOneWidget);
    expect(find.text('Log in'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('잘못된 이메일로 로그인하면 오류 문구가 보인다', (tester) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'zaonedogamswu.ac.kr');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.pump();
    await tester.tap(find.text('로그인').last);
    await tester.pumpAndSettle();

    expect(find.text('올바른 이메일 주소를 입력해주세요.'), findsOneWidget);
    expect(AuthState.instance.isSignedIn, isFalse);

    await tester.pumpWidget(const SizedBox());
  });

  const widths = [390.0, 768.0, 1024.0, 1280.0, 1440.0, 1920.0];
  Widget route(String path) => MaterialApp(
    initialRoute: path,
    onGenerateRoute: AppRoutes.onGenerateRoute,
  );
  final pages = <String, Widget>{
    '메인': const MyApp(),
    '샘플 결과': const MaterialApp(home: SampleResultPage()),
    '샘플 상세': route(AppRoutes.resultPath('sample-1')),
    '이용 안내': route(AppRoutes.guide),
    '자원랩 소개': route(AppRoutes.about),
    '데이터 처리 안내': route(AppRoutes.dataPolicy),
    '회원가입': route(AppRoutes.signup),
    '서비스 안내': route(AppRoutes.serviceInfo),
    '내 소재 등록': route(AppRoutes.register),
    '탐색 기록(로그아웃)': route(AppRoutes.history),
  };
  for (final width in widths) {
    for (final page in pages.entries) {
      testWidgets('폭 ${width.toInt()}px 에서 ${page.key} 화면이 넘치지 않는다', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 6000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(page.value);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
