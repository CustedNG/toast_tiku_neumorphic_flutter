import 'package:toast_tiku/core/persistant_store.dart';

/// 题库浏览历史储存库
class HistoryStore extends PersistentStore {
  StoreProperty<String> get lastViewedCourse => property('lastViewedCourse');

  void put(String courseId, String unitFile, List<int> finishItemCount) {
    box.put('$courseId-$unitFile', finishItemCount);
  }

  List<int> fetch(String courseId, String unitFile) {
    return box.get('$courseId-$unitFile', defaultValue: <int>[])!;
  }

  void putCheckState(
      String courseId, String unitFile, List<List<int>>? checkState) {
    box.put('$courseId-$unitFile-checkState', checkState);
  }

  List<List<int>>? fetchCheckState(String courseId, String unitFile) {
    final data = box.get('$courseId-$unitFile-checkState');
    if (data != null) {
      return List.from(data);
    }
  }
}
