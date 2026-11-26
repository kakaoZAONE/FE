import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

String? downloadFile(Uint8List bytes, String fileName, String mimeType) {
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: mimeType));
  // '파일보기'로 다시 열 수 있게 주소는 해제하지 않는다(탭을 닫으면 사라짐).
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName
    ..style.display = 'none';
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return url;
}

void openFileUrl(String url) => web.window.open(url, '_blank');
