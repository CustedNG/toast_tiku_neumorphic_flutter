import 'package:toast_tiku/core/persistant_store.dart';

class HistoryStore extends PersistentStore {
  StoreProperty<String> get lastViewedCourse => property('lastViewedCourse');

  void put(String courseId, String unitFile, List<int> finishItemCount) {
    box.put('$courseId-$unitFile', finishItemCount);
  }

  List<int> fetch(String courseId, String unitFile) {
    return box.get('$courseId-$unitFile', defaultValue: <int>[])!;
  }
}