import '../../core/persistant_store.dart';
import '../../model/check_state.dart';

/// 题库浏览历史储存库
class HistoryStore extends PersistentStore {
  StoreProperty<String> get lastViewedCourse => property('lastViewedCourse');

  void put(String courseId, String unitFile, List<int> finishItemCount) {
    box.put('$courseId-$unitFile', finishItemCount);
  }

  List<int> fetch(String courseId, String unitFile) {
    return box.get('$courseId-$unitFile', defaultValue: <int>[])!;
  }

  void putCheckState(String courseId, String unitFile, CheckState? checkState) {
    box.put('$courseId-$unitFile-checkState', checkState);
  }

  CheckState? fetchCheckState(String courseId, String unitFile) {
    return box.get('$courseId-$unitFile-checkState');
  }
}
