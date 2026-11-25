import '../../core/image_pick/picked_image.dart';

/// 내 소재 등록 중 입력값 (B1 · B2)
class MaterialDraft {
  final photos = <PickedImage>[];
  String name = '';
  String description = '';
  String origin = '';
  String? material;
  String? shape;
  String extraNote = '';
  String constraints = '';

  static const materials = ['종이', '플라스틱', '천·섬유', '목재', '금속', '기타'];
  static const shapes = ['시트·판', '원통', '입체', '불규칙', '끈·띠', '조각'];

  /// 최대 5장
  static const maxPhotos = 5;

  bool get hasInput =>
      photos.isNotEmpty ||
      name.isNotEmpty ||
      description.isNotEmpty ||
      origin.isNotEmpty ||
      material != null ||
      shape != null ||
      extraNote.isNotEmpty ||
      constraints.isNotEmpty;
}
