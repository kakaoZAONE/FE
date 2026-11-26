import 'dart:typed_data';

/// 사용자가 고른 사진 한 장 (브라우저 메모리에만 있음)
class PickedImage {
  const PickedImage({
    required this.name,
    required this.bytes,
    required this.mimeType,
  });

  final String name;
  final Uint8List bytes;
  final String mimeType;

  int get size => bytes.lengthInBytes;

  /// 장당 최대 10MB
  static const maxBytes = 10 * 1024 * 1024;
  static const allowedTypes = {'image/jpeg', 'image/png'};

  bool get isAllowedType {
    if (allowedTypes.contains(mimeType)) return true;
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  bool get isValid => isAllowedType && size <= maxBytes;
}
