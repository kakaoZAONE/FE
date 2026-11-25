import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'picked_image.dart';

Future<List<PickedImage>> pickImages({bool multiple = true}) async {
  final input = web.document.createElement('input') as web.HTMLInputElement
    ..type = 'file'
    ..accept = 'image/jpeg,image/png'
    ..multiple = multiple;

  final completer = Completer<List<PickedImage>>();
  input.onchange = ((web.Event _) {
    _read(input).then(completer.complete, onError: completer.completeError);
  }).toJS;
  input.click();
  return completer.future;
}

Future<List<PickedImage>> _read(web.HTMLInputElement input) async {
  final files = input.files;
  if (files == null) return const [];
  final result = <PickedImage>[];
  for (var i = 0; i < files.length; i++) {
    final file = files.item(i);
    if (file == null) continue;
    final buffer = await file.arrayBuffer().toDart;
    result.add(
      PickedImage(
        name: file.name,
        bytes: buffer.toDart.asUint8List(),
        mimeType: file.type,
      ),
    );
  }
  return result;
}
