import 'dart:convert';

import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/ti.dart';

/// 收藏题目的储存库
class FavoriteStore extends PersistentStore<String> {
  void put(String courseId, Ti ti) {
    final tis = fetch(courseId);
    if (!have(courseId, ti)) tis.add(ti);
    box.put(courseId, json.encode(tis));
  }

  List<Ti> fetch(String courseId) {
    return getTiList(json.decode(box.get(courseId, defaultValue: '[]')!))!;
  }

  void delete(String courseId, Ti ti) {
    final tis = fetch(courseId);
    tis.removeWhere((element) => element.question == ti.question);
    box.put(courseId, json.encode(tis));
  }

  bool have(String courseId, Ti ti) => fetch(courseId)
      .where((element) => element.question == ti.question)
      .isNotEmpty;
}
