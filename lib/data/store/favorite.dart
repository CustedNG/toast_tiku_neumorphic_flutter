import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/ti.dart';

/// 收藏题目的储存库
class FavoriteStore extends PersistentStore<List<Ti>> {
  void put(String courseId, Ti ti) {
    if (box.keys.contains(ti.id)) {
      return;
    }
    final old = fetch(courseId);
    if (old == null) {
      box.put(courseId, [ti]);
    } else {
      old.add(ti);
      box.put(courseId, old);
    }
  }

  List<Ti>? fetch(String courseId) {
    return box.get(courseId);
  }

  List<Ti> fetchAll(String courseId) {
    final tis = <Ti>[];
    for (final key in box.keys) {
      final item = box.get(key);
      if (item != null) {
        tis.addAll(item);
      }
    }
    return tis;
  }

  Future<bool> delete(String courseId, Ti ti) async {
    final tis = fetch(courseId);
    if (tis != null) {
      tis.remove(ti);
      await box.put(courseId, tis);
      return true;
    }
    return false;
  }

  bool? have(String courseId, Ti ti) => fetch(courseId)?.contains(ti);
}
