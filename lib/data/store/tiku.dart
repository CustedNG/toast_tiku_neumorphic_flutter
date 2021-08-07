import 'dart:convert';

import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/ti.dart';

class TikuStore extends PersistentStore<String> {
  StoreProperty<String> get index => property('index');
  StoreProperty<String> get version => property('version');

  void put(String courseId, String unitFile, List<Ti> tis) {
    box.put('$courseId-$unitFile', json.encode(tis));
  }

  List<Ti>? fetch(String courseId, String unitFile) {
    return getTiList(
        json.decode(box.get('$courseId-$unitFile', defaultValue: '')!));
  }
}
