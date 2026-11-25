import 'package:flutter/foundation.dart';

import 'result_models.dart';

/// 이번 방문에서 만든 결과와 저장한 결과 (Mock, 메모리)
///
/// - 저장하지 않은 결과는 새로고침하면 사라진다(Figma 안내 문구와 같음).
/// - 저장 API가 생기면 [save] · [remove] · [saved]를 서버 호출로 바꾼다.
class ResultStore extends ChangeNotifier {
  ResultStore._();

  static final instance = ResultStore._();

  final _results = <String, MaterialResult>{};

  MaterialResult? byId(String id) => _results[id];

  void put(MaterialResult result) {
    _results[result.id] = result;
    notifyListeners();
  }

  List<MaterialResult> get saved =>
      _results.values.where((r) => r.saved).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void save(MaterialResult result) {
    result.saved = true;
    _results[result.id] = result;
    notifyListeners();
  }

  void remove(MaterialResult result) {
    result.saved = false;
    notifyListeners();
  }

  String newId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);
}
