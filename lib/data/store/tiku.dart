import 'package:toast_tiku/core/persistant_store.dart';

class TikuStore extends PersistentStore {
  StoreProperty<String> get index => property('index');

  void put(String courseId, int unitIdx, String jsonSource) {
    box.put('$courseId-$unitIdx', jsonSource);
  }

  String fetch(String courseId, int unitIdx) {
    return box.get('$courseId-$unitIdx');
  }
}
