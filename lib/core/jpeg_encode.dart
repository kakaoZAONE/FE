import 'dart:typed_data';

import 'jpeg_encode_stub.dart'
    if (dart.library.js_interop) 'jpeg_encode_web.dart'
    as impl;

/// 이미지(PNG · JPEG · WebP 등)를 긴 변 [maxSide] 이하로 줄여 JPEG로 바꾼다.
///
/// 웹은 브라우저 캔버스로 바꾼다(빠름). 웹이 아니거나 실패하면 null.
/// PDF에 픽셀 그대로(RGBA) 넣으면 pdf 패키지가 Dart로 압축하는데, 웹(JS)에서는
/// 사진 몇 장에 수십 초가 걸려서 JPEG로 바꿔 넣는다.
Future<Uint8List?> encodeJpeg(
  Uint8List bytes, {
  int maxSide = 1200,
  double quality = 0.85,
}) => impl.encodeJpeg(bytes, maxSide: maxSide, quality: quality);
