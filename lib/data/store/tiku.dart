import 'dart:convert';

import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/ti.dart';

/// 题库数据储存库
class TikuStore extends PersistentStore<String> {
  /// 题库索引数据
  StoreProperty<String> get index => property('index');

  /// 题库索引版本号
  StoreProperty<String> get version => property('version');

  void put(String courseId, String unitFile, List<Ti> tis) {
    box.put('$courseId-$unitFile', json.encode(tis));
  }

  List<Ti>? fetch(String courseId, String unitFile) {
    return getTiList(
        json.decode(box.get('$courseId-$unitFile', defaultValue: '[]')!));
  }
}
