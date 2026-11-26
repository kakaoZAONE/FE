import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/external_links.dart';
import '../../core/jpeg_encode.dart';
import 'result_models.dart';

/// 결과 PDF (C3 'PDF로 받기') — 프론트엔드에서 직접 만든다.
///
/// 구성은 [PdfPreview]와 같다.
/// 1쪽: 소재 이름 · 발생처 · 사진 · 소재 정보(입력 / AI 추정 / 확인할 수 없음 구분)
/// 2쪽~: 탐색 · 변형 · 조합 장면
/// 마지막: 안내(AI 가상 장면 · 자원랩 공식 문의)
/// 모든 쪽 아래에 'AI가 생성한 장면은 가상의 예시…' 문구와 쪽 번호가 들어간다.
///
/// 글꼴은 `assets/pdf_fonts`(한글 전체 · tool/pdf_fonts.sh). 앱 폰트는 서브셋이라
/// 사용자가 입력한 글자를 담지 못해서 따로 둔다. PDF를 만들 때만 불러온다.
Future<Uint8List> buildResultPdf(MaterialResult result) async {
  final regular = pw.Font.ttf(
    await rootBundle.load('assets/pdf_fonts/NotoSansKR-Regular.ttf'),
  );
  final bold = pw.Font.ttf(
    await rootBundle.load('assets/pdf_fonts/NotoSansKR-Bold.ttf'),
  );

  final cover = result.coverImage != null
      ? await _image(result.coverImage!.bytes)
      : result.coverAsset != null
      ? await _assetImage(result.coverAsset!)
      : null;
  final sceneImages = [
    for (final s in result.scenes) await _assetImage(s.image),
  ];

  final doc = pw.Document(
    title: '자원도감 · ${result.name}',
    author: '자원도감',
    creator: '자원도감',
  );
  final theme = pw.ThemeData.withFont(base: regular, bold: bold);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(48, 40, 48, 36),
        theme: theme,
      ),
      header: (context) => _header(result),
      footer: _footer,
      build: (context) => [
        ..._coverSection(result, cover),
        pw.NewPage(),
        _heading('놀이 장면'),
        for (var i = 0; i < result.scenes.length; i++)
          _scene(result.scenes[i], sceneImages[i]),
        pw.NewPage(),
        ..._noticeSection(),
      ],
    ),
  );
  return doc.save();
}

/// 파일 이름: `자원도감_{소재 이름}_{yyyyMMdd}.pdf` (Figma C3-1 예: 자원도감_종이관_20261117.pdf)
String resultPdfFileName(MaterialResult result, DateTime date) {
  String two(int v) => v.toString().padLeft(2, '0');
  final name = result.name
      .replaceAll(RegExp(r'[\\/:*?"<>|\s]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return '자원도감_${name}_${date.year}${two(date.month)}${two(date.day)}.pdf';
}

// ---------------------------------------------------------------- 색

const _ink = PdfColor.fromInt(0xFF1A1E22); // gray/900
const _muted = PdfColor.fromInt(0xFF65696D); // gray/600
const _subtle = PdfColor.fromInt(0xFF979B9F); // gray/400
const _rule = PdfColor.fromInt(0xFFE9ECEF); // gray/100
const _panel = PdfColor.fromInt(0xFFF2F4F6); // gray/50
const _purple = PdfColor.fromInt(0xFF633DC7);
const _error = PdfColor.fromInt(0xFFE00052);

pw.TextStyle _text(
  double size, {
  bool bold = false,
  PdfColor color = _ink,
  double height = 1.5,
}) => pw.TextStyle(
  fontSize: size,
  fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  color: color,
  lineSpacing: size * (height - 1),
);

// ---------------------------------------------------------------- 머리 · 꼬리

pw.Widget _header(MaterialResult result) => pw.Container(
  margin: const pw.EdgeInsets.only(bottom: 20),
  padding: const pw.EdgeInsets.only(bottom: 6),
  decoration: const pw.BoxDecoration(
    border: pw.Border(bottom: pw.BorderSide(color: _ink, width: 0.6)),
  ),
  child: pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text('ZAONE LAB · 자원도감', style: _text(8, bold: true)),
      pw.Text(result.createdLabel, style: _text(8, color: _muted)),
    ],
  ),
);

pw.Widget _footer(pw.Context context) => pw.Container(
  margin: const pw.EdgeInsets.only(top: 16),
  padding: const pw.EdgeInsets.only(top: 6),
  decoration: const pw.BoxDecoration(
    border: pw.Border(top: pw.BorderSide(color: _rule, width: 0.6)),
  ),
  child: pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        'AI가 생성한 장면은 가상의 예시이며 실제 사용 적합성은 별도 검토가 필요합니다.',
        style: _text(7, color: _subtle),
      ),
      pw.Text(
        '${context.pageNumber} / ${context.pagesCount}',
        style: _text(7, bold: true, color: _subtle),
      ),
    ],
  ),
);

pw.Widget _heading(String text, {PdfColor color = _ink}) => pw.Padding(
  padding: const pw.EdgeInsets.only(bottom: 10),
  child: pw.Text(text, style: _text(13, bold: true, color: color)),
);

// ---------------------------------------------------------------- 1쪽

List<pw.Widget> _coverSection(MaterialResult result, pw.ImageProvider? cover) {
  final analysis = result.analysis;
  return [
    pw.Text(result.name, style: _text(26, bold: true, height: 1.3)),
    if (result.source.isNotEmpty) ...[
      pw.SizedBox(height: 4),
      pw.Text(result.source, style: _text(11, color: _muted)),
    ],
    pw.SizedBox(height: 16),
    if (cover != null)
      pw.ClipRRect(
        horizontalRadius: 2,
        verticalRadius: 2,
        child: pw.SizedBox(
          height: 220,
          width: double.infinity,
          child: pw.Image(cover, fit: pw.BoxFit.cover),
        ),
      ),
    if (analysis != null) ...[
      pw.SizedBox(height: 22),
      _infoTable('입력하신 정보', analysis.entered),
      _infoTable('AI가 사진에서 추정한 정보', analysis.estimated, color: _purple),
      _infoTable('사진으로 확인할 수 없는 정보', analysis.unknown, color: _error),
    ],
  ];
}

pw.Widget _infoTable(String title, List<InfoRow> rows, {PdfColor? color}) {
  if (rows.isEmpty) return pw.SizedBox();
  // Container는 쪽을 넘겨 나뉘지 않는다 → 제목과 표가 같은 쪽에 놓인다.
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 14),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(title, style: _text(10, bold: true, color: color ?? _ink)),
        pw.SizedBox(height: 6),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: const pw.BoxDecoration(color: _panel),
          child: pw.Column(
            children: [
              for (var i = 0; i < rows.length; i++)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  decoration: i == 0
                      ? null
                      : const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: _rule, width: 0.6),
                          ),
                        ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 90,
                        child: pw.Text(
                          rows[i].label,
                          style: _text(9, bold: true, color: _muted),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          rows[i].value.trim().isEmpty ? '-' : rows[i].value,
                          style: _text(9),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------- 장면

pw.Widget _scene(PlayScene scene, pw.ImageProvider? image) {
  pw.Widget row(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 4),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 62,
          child: pw.Text(label, style: _text(8.5, color: _subtle)),
        ),
        pw.Expanded(
          child: pw.Text(value, style: _text(8.5, color: _muted)),
        ),
      ],
    ),
  );

  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 16),
    padding: const pw.EdgeInsets.all(14),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _rule, width: 0.8),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 5,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                color: _ink,
                child: pw.Text(
                  scene.mode.label,
                  style: _text(8, bold: true, color: PdfColors.white),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(scene.title, style: _text(13, bold: true, height: 1.3)),
              pw.SizedBox(height: 6),
              pw.Text(scene.description, style: _text(9)),
              pw.SizedBox(height: 6),
              row('활용한 특성', scene.traits),
              if (scene.checks != null && scene.checks!.isNotEmpty)
                row('활용 전 확인', scene.checks!),
            ],
          ),
        ),
        if (image != null) ...[
          pw.SizedBox(width: 14),
          pw.Expanded(
            flex: 6,
            child: pw.SizedBox(
              height: 150,
              child: pw.Image(image, fit: pw.BoxFit.cover),
            ),
          ),
        ],
      ],
    ),
  );
}

// ---------------------------------------------------------------- 안내

List<pw.Widget> _noticeSection() => [
  pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(18),
    color: _ink,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'AI가 만든 장면은 새로운 가능성을 상상하는 예시입니다.',
          style: _text(12, bold: true, color: PdfColors.white),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          '생성 이미지로 소재의 강도·위생·안전성·교육 현장 적합성을 판단하지 않습니다. '
          '실제 제공과 활용은 자원랩과 별도로 협의합니다.',
          style: _text(9, color: PdfColors.white),
        ),
      ],
    ),
  ),
  pw.SizedBox(height: 16),
  pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(18),
    color: _panel,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('ZAONE LAB과 함께하고 싶다면', style: _text(12, bold: true)),
        pw.SizedBox(height: 6),
        pw.Text(
          '자원도감의 장면은 AI가 만든 가상 예시예요. '
          '실제 소재 제공과 교육 활용은 자원랩의 공식 협의로 진행돼요.',
          style: _text(9),
        ),
        pw.SizedBox(height: 8),
        pw.UrlLink(
          destination: ExternalLinks.zaoneLab.toString(),
          child: pw.Text(
            ExternalLinks.zaoneLab.toString(),
            style: _text(
              9,
              color: _muted,
            ).copyWith(decoration: pw.TextDecoration.underline),
          ),
        ),
      ],
    ),
  ),
];

// ---------------------------------------------------------------- 이미지

/// 긴 변 1200으로 줄여 넣는다. 실패하면 null(사진 없이 만든다).
///
/// 웹: 브라우저 캔버스로 JPEG로 바꿔 그대로 넣는다([encodeJpeg], 빠름).
/// 그 밖(테스트 등): Flutter 디코더로 RGBA를 넣는다.
Future<pw.ImageProvider?> _image(Uint8List bytes) async {
  final jpeg = await encodeJpeg(bytes);
  if (jpeg != null) return pw.MemoryImage(jpeg);
  try {
    // 웹은 ImageDescriptor.encoded를 지원하지 않아서, 한 번 디코딩해 크기를 보고
    // 크면 줄여서 다시 디코딩한다.
    const maxSide = 1200;
    var codec = await ui.instantiateImageCodec(bytes);
    var image = (await codec.getNextFrame()).image;
    final w = image.width, h = image.height;
    final scale = maxSide / (w > h ? w : h);
    if (scale < 1) {
      image.dispose();
      codec.dispose();
      codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: (w * scale).round(),
        targetHeight: (h * scale).round(),
      );
      image = (await codec.getNextFrame()).image;
    }
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final provider = pw.RawImage(
      bytes: data!.buffer.asUint8List(),
      width: image.width,
      height: image.height,
    );
    image.dispose();
    codec.dispose();
    return provider;
  } catch (_) {
    return null;
  }
}

Future<pw.ImageProvider?> _assetImage(String path) async {
  try {
    final data = await rootBundle.load(path);
    return _image(data.buffer.asUint8List());
  } catch (_) {
    return null;
  }
}
