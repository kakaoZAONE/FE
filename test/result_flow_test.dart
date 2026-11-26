import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakaozaone_fe/app/app_routes.dart';
import 'package:kakaozaone_fe/features/auth/auth_state.dart';
import 'package:kakaozaone_fe/features/register/material_api.dart';
import 'package:kakaozaone_fe/features/register/register_models.dart';
import 'package:kakaozaone_fe/features/result/result_dialogs.dart';
import 'package:kakaozaone_fe/features/result/result_models.dart';
import 'package:kakaozaone_fe/features/result/result_store.dart';
import 'package:kakaozaone_fe/pages/home/home_assets.dart';

/// C 결과 화면 흐름: 저장 · 로그인/회원가입 · 재탐색 · 창 넘침
void main() {
  late MaterialResult result;
  final api = MockMaterialApi(delay: Duration.zero);

  setUp(() async {
    MaterialApi.instance = api;
    final draft = MaterialDraft()..name = '종이관';
    final analysis = await api.analyze(draft);
    result = MaterialResult(
      id: 'test-${DateTime.now().microsecondsSinceEpoch}',
      name: '종이관',
      source: '섬유 제조사 · 원단을 감는 데 쓰고 남은 지관',
      createdAt: DateTime(2026, 11, 30),
      scenes: [
        for (final m in PlayMode.values)
          await api.generateScene(draft, analysis, m),
      ],
      coverAsset: HomeAssets.paperTube[0],
      analysis: analysis,
    );
    ResultStore.instance.put(result);
  });

  tearDown(AuthState.instance.signOut);

  Widget app() => MaterialApp(
    initialRoute: AppRoutes.resultPath(result.id),
    onGenerateRoute: AppRoutes.onGenerateRoute,
  );

  void desktop(WidgetTester tester, {double width = 1440}) {
    tester.view.physicalSize = Size(width, 4200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  /// 알림(4초)이 사라질 때까지 흘려보낸다 — 테스트 끝에 타이머가 남지 않게
  Future<void> flushToast(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  testWidgets('로그인 전 저장하기 → 저장용 로그인 창 → 로그인하면 저장 완료와 알림', (tester) async {
    desktop(tester);
    await tester.pumpWidget(app());
    expect(
      find.text(
        '아직 저장되지 않은 결과입니다. 저장하지 않으면 일정 시간이 지난 뒤 삭제됩니다. '
        'PDF로는 언제든 받아 둘 수 있습니다.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('저장하기'));
    await tester.pumpAndSettle();
    // D1 (1100:8260)
    expect(find.text('결과를 저장하려면 로그인해 주세요'), findsOneWidget);
    expect(result.saved, isFalse);

    await tester.enterText(find.byType(TextField).at(0), 'qa@zaone.org');
    await tester.enterText(find.byType(TextField).at(1), 'pass1234');
    await tester.pump();
    await tester.tap(find.text('로그인').last);
    await tester.pumpAndSettle();

    expect(result.saved, isTrue);
    expect(find.text('저장 완료'), findsOneWidget);
    expect(find.text('내 탐색 기록에 저장했습니다'), findsOneWidget);
    expect(find.text('보러 가기'), findsOneWidget);
    expect(
      find.text('내 탐색 기록에 저장된 결과입니다. 같은 소재로 언제든 새 탐색을 시작할 수 있습니다.'),
      findsOneWidget,
    );
    // 로그인 후 배너: Contact 하나, 제목 변경 (C1-1)
    expect(find.text('내 소재로 놀이 장면을 보고싶다면'), findsNothing);
    expect(find.text('마음에 드는 소재를 발견하셨나요? ZAONE LAB에 문의해 보세요.'), findsOneWidget);

    await flushToast(tester);
    expect(find.text('내 탐색 기록에 저장했습니다'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('저장 로그인 창을 취소하면 저장되지 않는다', (tester) async {
    desktop(tester);
    await tester.pumpWidget(app());
    await tester.tap(find.text('저장하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(result.saved, isFalse);
    expect(find.text('저장하기'), findsOneWidget);
    expect(find.text('내 탐색 기록에 저장했습니다'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('계정 만들기는 결과 화면 위 창(D2)으로 열리고, 가입하면 이메일을 채운 로그인 창(D2-2) → 저장', (
    tester,
  ) async {
    desktop(tester);
    await tester.pumpWidget(app());
    await tester.tap(find.text('저장하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('계정 만들기'));
    await tester.pumpAndSettle();

    // 페이지 이동이 아니라 창 — 결과 화면은 그대로 아래에 있다
    expect(find.text('계정 만들기'), findsOneWidget);
    expect(find.text('기업명'), findsOneWidget);
    expect(find.text('종이관'), findsWidgets);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '자원');
    await tester.enterText(fields.at(1), 'new@zaone.org');
    await tester.enterText(fields.at(2), 'abcd1234');
    await tester.tap(find.bySemanticsLabel('서비스 이용 안내와 AI·데이터 처리 안내 동의'));
    await tester.pump();
    await tester.tap(find.text('가입하고 시작하기'));
    await tester.pumpAndSettle();

    // D2-2: 가입만 하고 아직 로그인 전, 이메일이 채워진 로그인 창
    expect(AuthState.instance.isSignedIn, isFalse);
    expect(find.text('로그인'), findsWidgets);
    expect(find.text('new@zaone.org'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'abcd1234');
    await tester.pump();
    await tester.tap(find.text('로그인').last);
    await tester.pumpAndSettle();

    expect(AuthState.instance.isSignedIn, isTrue);
    expect(AuthState.instance.name, '자원');
    expect(result.saved, isTrue);
    await flushToast(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('다시 탐색 창(C2) 문구와 완료 알림(C2_a-2)', (tester) async {
    desktop(tester);
    await tester.pumpWidget(app());
    await tester.tap(find.text('다시 탐색'));
    await tester.pumpAndSettle();

    expect(find.text('새 조건에 맞춰 탐색·변형·조합 세 장면을 모두 새로 생성됩니다.'), findsOneWidget);
    expect(find.text('추가 조건을 자유롭게 입력해 주세요.'), findsOneWidget);
    expect(
      find.text('기존 결과는 저장되지 않으며 새 탐색은 내 탐색 기록에서 ‘탐색 2’로 따로 저장됩니다.'),
      findsOneWidget,
    );

    await tester.tap(find.text('새로 만들기'));
    await tester.pumpAndSettle();
    expect(find.text('입력하신 정보를 바탕으로 재탐색을 완료했어요'), findsOneWidget);
    await flushToast(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('이 장면만 다시 생성(C2_b-1) 창은 장면 이름을 보여 주고 완료 알림(C2_b-2)', (
    tester,
  ) async {
    desktop(tester);
    await tester.pumpWidget(app());
    await tester.tap(find.text('이 장면만 다시 생성').first);
    await tester.pumpAndSettle();

    expect(find.text('새로운 조건에 맞춰 탐색 장면이 새로 생성됩니다.'), findsOneWidget);
    expect(find.text('이전 탐색 장면은 저장되지 않습니다.'), findsOneWidget);

    await tester.tap(find.text('다시 생성'));
    await tester.pumpAndSettle();
    expect(find.text('입력하신 정보를 바탕으로 [탐색]장면을 다시 생성했어요'), findsOneWidget);
    await flushToast(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('장면 생성이 실패하면 완료 알림 대신 실패 안내를 보이고 기존 장면을 남긴다', (tester) async {
    MaterialApi.instance = _FailingApi();
    desktop(tester);
    await tester.pumpWidget(app());
    final before = result.scenes.first.title;

    await tester.tap(find.text('이 장면만 다시 생성').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('다시 생성'));
    await tester.pumpAndSettle();

    expect(find.textContaining('다시 생성했어요'), findsNothing);
    expect(find.text('장면을 다시 만들지 못했어요. 기존 장면은 그대로 남아 있어요'), findsOneWidget);
    expect(result.scenes.first.title, before);
    await flushToast(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('자원랩 문의 창(C4) → PDF로 받기 창(C3)으로 이어진다', (tester) async {
    desktop(tester);
    await tester.pumpWidget(app());
    await tester.tap(find.text('자원랩에 문의하기'));
    await tester.pumpAndSettle();
    expect(find.text('소재명과 발생 공정'), findsOneWidget);
    expect(find.text('자원랩으로 이동'), findsOneWidget);

    await tester.tap(find.text('PDF로 받기').last);
    await tester.pumpAndSettle();
    expect(find.text('“AI가 만든 가상 장면” 안내 문구가 포함됩니다'), findsOneWidget);
    expect(find.text('다운로드'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final width in const [390.0, 768.0, 1024.0, 1440.0, 1920.0]) {
    testWidgets('폭 ${width.toInt()}px 에서 결과 화면과 창이 넘치지 않는다', (tester) async {
      tester.view.physicalSize = Size(width, 4200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(app());
      expect(tester.takeException(), isNull);

      final context = tester.element(find.text('종이관').first);
      for (final open in <Future<void> Function()>[
        () => showReExploreDialog(context),
        () => showReExploreDialog(context, mode: PlayMode.combine),
        () => showPdfDialog(context, result),
        () => showContactDialog(context, result),
        () => showAnalysisDetailDialog(context, result),
      ]) {
        open();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        Navigator.of(context).pop();
        await tester.pumpAndSettle();
      }
      await tester.pumpWidget(const SizedBox());
    });
  }
}

class _FailingApi implements MaterialApi {
  @override
  Future<MaterialAnalysis> analyze(MaterialDraft draft) =>
      Future.error(StateError('fail'));

  @override
  Future<PlayScene> generateScene(
    MaterialDraft draft,
    MaterialAnalysis analysis,
    PlayMode mode,
  ) => Future.error(StateError('fail'));
}
