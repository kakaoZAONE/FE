import 'picked_image.dart';
import 'image_picker_stub.dart'
    if (dart.library.js_interop) 'image_picker_web.dart'
    as impl;

export 'picked_image.dart';

/// 브라우저 파일 선택 창을 열어 JPG·PNG 사진을 고른다.
/// 웹이 아닌 환경(테스트 등)에서는 빈 목록을 돌려준다.
Future<List<PickedImage>> pickImages({bool multiple = true}) =>
    impl.pickImages(multiple: multiple);
