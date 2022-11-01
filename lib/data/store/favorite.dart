import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/ti.dart';

/// 收藏题目的储存库
class FavoriteStore extends PersistentStore {
  void put(String courseId, Ti ti) {
    if (box.keys.contains(ti.id)) {
      return;
    }
    final old = fetch(courseId);
    old.add(ti);
    box.put(courseId, old);
  }

  List<Ti> fetch(String courseId) {
    return List<Ti>.from(box.get(courseId, defaultValue: <Ti>[])!);
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
    if (tis.contains(ti)) {
      tis.remove(ti);
      await box.put(courseId, tis);
      return true;
    }
    return false;
  }

  bool have(String courseId, Ti ti) => fetch(courseId).contains(ti);
}
