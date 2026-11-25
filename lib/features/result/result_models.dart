import '../../core/image_pick/picked_image.dart';

/// 놀이 방향 3가지
enum PlayMode {
  explore('탐색'),
  transform('변형'),
  combine('조합');

  const PlayMode(this.label);
  final String label;
}

/// 놀이 장면 한 개
class PlayScene {
  const PlayScene({
    required this.mode,
    required this.title,
    required this.description,
    required this.traits,
    this.checks,
    required this.image,
  });

  final PlayMode mode;
  final String title;
  final String description;

  /// 활용한 특성
  final String traits;

  /// 활용 전 확인 (없으면 표시하지 않음)
  final String? checks;

  /// 장면 이미지 (에셋 경로). Mock 단계라 에셋을 쓴다.
  final String image;
}

/// 정보 표 한 줄 (라벨 · 값)
class InfoRow {
  InfoRow(this.label, this.value);

  final String label;
  String value;

  /// 사용자가 고쳤거나 입력했는지
  bool edited = false;
}

/// 소재 분석 결과 (B5)
class MaterialAnalysis {
  MaterialAnalysis({
    required this.entered,
    required this.estimated,
    required this.unknown,
  });

  /// 입력하신 정보
  final List<InfoRow> entered;

  /// AI가 사진에서 추정한 정보 (수정 가능)
  final List<InfoRow> estimated;

  /// 사진으로 확인할 수 없는 정보 (사용자 입력)
  final List<InfoRow> unknown;
}

/// 탐색 결과 한 건 (C1 · 샘플 상세 · 저장 기록 공통)
class MaterialResult {
  MaterialResult({
    required this.id,
    required this.name,
    required this.source,
    required this.createdAt,
    required this.scenes,
    this.coverAsset,
    this.coverImage,
    this.isSample = false,
    this.saved = false,
    this.analysis,
  });

  final String id;
  final String name;

  /// 발생처 · 설명 한 줄
  final String source;
  final DateTime createdAt;
  final List<PlayScene> scenes;
  final String? coverAsset;
  final PickedImage? coverImage;
  final bool isSample;
  bool saved;
  final MaterialAnalysis? analysis;

  String get createdLabel {
    final d = createdAt;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}.${two(d.month)}.${two(d.day)} 생성';
  }
}
