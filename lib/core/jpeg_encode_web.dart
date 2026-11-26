import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<Uint8List?> encodeJpeg(
  Uint8List bytes, {
  required int maxSide,
  required double quality,
}) async {
  try {
    final bitmap = await web.window
        .createImageBitmap(web.Blob([bytes.toJS].toJS))
        .toDart;
    final w = bitmap.width, h = bitmap.height;
    final scale = maxSide / (w > h ? w : h);
    final tw = scale < 1 ? (w * scale).round() : w;
    final th = scale < 1 ? (h * scale).round() : h;

    final canvas = web.HTMLCanvasElement()
      ..width = tw
      ..height = th;
    final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
    // 투명한 PNG는 JPEG에서 검게 나오지 않도록 흰 바탕을 먼저 칠한다.
    ctx
      ..fillStyle = '#FFFFFF'.toJS
      ..fillRect(0, 0, tw, th)
      ..drawImage(bitmap, 0, 0, tw, th);
    bitmap.close();

    final url = canvas.toDataURL('image/jpeg', quality.toJS);
    final comma = url.indexOf(',');
    if (comma < 0) return null;
    return _base64(url.substring(comma + 1));
  } catch (_) {
    return null;
  }
}

Uint8List _base64(String data) {
  final binary = web.window.atob(data);
  final out = Uint8List(binary.length);
  for (var i = 0; i < binary.length; i++) {
    out[i] = binary.codeUnitAt(i);
  }
  return out;
}
