import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakaozaone_fe/features/register/material_api.dart';
import 'package:kakaozaone_fe/features/register/register_models.dart';
import 'package:kakaozaone_fe/features/result/result_models.dart';
import 'package:kakaozaone_fe/features/result/result_pdf.dart';
import 'package:kakaozaone_fe/features/result/sample_results.dart';
import 'package:kakaozaone_fe/pages/home/home_assets.dart';

/// C3 'PDF로 받기' — 앱에서 직접 만드는 결과 PDF
void main() {
  int pageCount(List<int> bytes) =>
      RegExp(r'/Type\s*/Page[^s]').allMatches(latin1.decode(bytes)).length;

  testWidgets('샘플 결과로 여러 쪽 PDF를 만든다', (tester) async {
    final bytes = await tester.runAsync(
      () => buildResultPdf(SampleResults.all.first),
    );
    expect(bytes, isNotNull);
    expect(latin1.decode(bytes!.sublist(0, 5)), '%PDF-');
    // 표지 · 장면 · 안내 → 3쪽 이상
    expect(pageCount(bytes), greaterThanOrEqualTo(3));
  });

  testWidgets('앱 문구에 없는 글자(사용자 입력)와 소재 정보 표도 담는다', (tester) async {
    // Mock API의 Future.delayed는 테스트 가짜 시간에서 끝나지 않아 실제 시간으로 실행
    final bytes = await tester.runAsync(() async {
      final api = MockMaterialApi(delay: Duration.zero);
      final draft = MaterialDraft()..name = '뷁쀍 폐목재';
      final analysis = await api.analyze(draft);
      final result = MaterialResult(
        id: 'pdf-test',
        name: '뷁쀍 폐목재',
        source: '가구 공방 · 재단하고 남은 자투리',
        createdAt: DateTime(2026, 11, 27),
        scenes: [
          for (final m in PlayMode.values)
            await api.generateScene(draft, analysis, m),
        ],
        coverAsset: HomeAssets.paperTube[0],
        analysis: analysis,
      );
      return buildResultPdf(result);
    });
    expect(bytes, isNotNull);
    expect(pageCount(bytes!), greaterThanOrEqualTo(3));
  });

  test('파일 이름은 자원도감_{소재}_{날짜}.pdf, 파일에 못 쓰는 글자는 _', () {
    final result = SampleResults.all.first;
    expect(
      resultPdfFileName(result, DateTime(2026, 11, 17)),
      '자원도감_종이관_20261117.pdf',
    );
    final odd = MaterialResult(
      id: 'x',
      name: '종이 / 관?',
      source: '',
      createdAt: DateTime(2026),
      scenes: const [],
    );
    expect(
      resultPdfFileName(odd, DateTime(2026, 1, 2)),
      '자원도감_종이_관_20260102.pdf',
    );
  });
}
