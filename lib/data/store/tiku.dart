import 'dart:convert';

import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/ti.dart';

class TikuStore extends PersistentStore<String> {
  StoreProperty<String> get index => property('index');

  void put(String courseId, String unitFile, String jsonSource) {
    box.put('$courseId-$unitFile', jsonSource);
  }

  List<Ti>? fetch(String courseId, String unitFile) {
    return getTiList(
        json.decode(box.get('$courseId-$unitFile', defaultValue: '')!));
  }
}
