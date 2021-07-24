import 'package:toast_tiku/core/persistant_store.dart';

class HistoryStore extends PersistentStore {
  void put(String courseId, int unitIdx, int finishItemCount) {
    box.put('$courseId-$unitIdx', finishItemCount);
  }

  int fetch(String courseId, int unitIdx) {
    return box.get('$courseId-$unitIdx', defaultValue: 0);
  }
}