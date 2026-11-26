import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../result_models.dart';

/// PDF 미리보기 (Figma `pdf preview` 889:3754)
///
/// #F2F4F6 바탕, radius 12, 안쪽 20, 쪽 사이 12. 쪽 하나 130.667 x 224.6,
/// 흰 바탕 · 0.2px #E9ECEF 테두리 · 그림자 0 4 10 rgba(0,0,0,.12).
///
/// 실제 PDF([buildResultPdf], result_pdf.dart)와 같은 구성의 축소 모양이다.
/// 1쪽 표지(이름 · 사진 · 소재 정보) · 2쪽 장면 · 3쪽 안내. (해외 사례 쪽은 정책상 제외)
class PdfPreview extends StatelessWidget {
  const PdfPreview({super.key, required this.result});

  final MaterialResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            Expanded(
              // 1440 기준 크기로 그리고 좁은 화면에서는 통째로 줄인다(넘침 방지)
              child: AspectRatio(
                aspectRatio: 130.667 / 224.6,
                child: FittedBox(
                  child: SizedBox(
                    width: 130.667,
                    height: 224.6,
                    child: _Page(result: result, page: i),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.result, required this.page});

  final MaterialResult result;
  final int page;

  @override
  Widget build(BuildContext context) {
    Widget line(double widthFactor, {double top = 3}) => Padding(
      padding: EdgeInsets.only(top: top),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(height: 2, color: AppColors.gray100),
      ),
    );
    const title = TextStyle(
      fontFamily: 'NotoSansKR',
      fontWeight: FontWeight.w700,
      fontSize: 6,
      height: 1.3,
      color: AppColors.gray900,
    );
    final cover = result.coverImage != null
        ? Image.memory(result.coverImage!.bytes, fit: BoxFit.cover)
        : result.coverAsset != null
        ? Image.asset(result.coverAsset!, fit: BoxFit.cover)
        : const ColoredBox(color: AppColors.gray100);

    final body = switch (page) {
      // 1쪽: 소재 이름 · 사진 · 소재 정보
      0 => [
        Text(
          result.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: title,
        ),
        line(0.7),
        const SizedBox(height: 4),
        SizedBox(
          height: 66,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1.6),
            child: SizedBox.expand(child: cover),
          ),
        ),
        const SizedBox(height: 4),
        for (var i = 0; i < 7; i++) line(i.isEven ? 0.9 : 0.75),
      ],
      // 2쪽: 장면 3개(사진 + 글)
      1 => [
        for (final s in result.scenes.take(3))
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(1.2),
                  child: SizedBox(
                    width: 48,
                    height: 32,
                    child: Image.asset(s.image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    children: [line(0.6, top: 0), line(1), line(0.8)],
                  ),
                ),
              ],
            ),
          ),
      ],
      // 3쪽: 다음 단계 · 안내
      _ => [for (var i = 0; i < 12; i++) line(i % 3 == 0 ? 0.5 : 0.95)],
    };

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gray100, width: 0.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 머리줄
          Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.gray900, width: 0.3),
              ),
            ),
            child: const Text(
              'ZAONE',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w900,
                fontSize: 2.2,
                color: AppColors.gray900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ...body,
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${page + 1} / 3',
              style: const TextStyle(
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w700,
                fontSize: 1.6,
                color: AppColors.gray400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
