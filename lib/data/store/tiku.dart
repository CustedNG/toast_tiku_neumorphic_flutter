import '../../core/persistant_store.dart';
import '../../model/ti.dart';

/// 题库数据储存库
class TikuStore extends PersistentStore {
  void put(String courseId, String unitFile, List<Ti> tis) {
    box.put('$courseId-$unitFile', tis);
  }

  List<Ti> fetch(String courseId, String unitFile) {
    return List.from(box.get('$courseId-$unitFile', defaultValue: <Ti>[]));
  }
}
