import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/check_state.dart';

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
      String courseId, String unitFile, Map<String, List<Object>>? checkState) {
    box.put('$courseId-$unitFile-checkState', checkState);
  }

  Map<String, List<Object>>? fetchCheckState(String courseId, String unitFile) {
    final data = box.get('$courseId-$unitFile-checkState');
    return toMap(data);
  }
}
