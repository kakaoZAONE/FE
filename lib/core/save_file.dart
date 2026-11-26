import 'dart:typed_data';

import 'save_file_stub.dart'
    if (dart.library.js_interop) 'save_file_web.dart'
    as impl;

/// 파일을 브라우저 다운로드로 저장한다.
///
/// 성공하면 그 파일을 다시 열 수 있는 주소(blob URL)를, 웹이 아니면 null을 돌려준다.
String? downloadFile(Uint8List bytes, String fileName, String mimeType) =>
    impl.downloadFile(bytes, fileName, mimeType);

/// [downloadFile]이 돌려준 주소를 새 탭으로 연다 ('파일보기').
void openFileUrl(String url) => impl.openFileUrl(url);
