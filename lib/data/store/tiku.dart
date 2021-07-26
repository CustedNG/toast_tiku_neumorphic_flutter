import 'package:simple_logger/simple_logger.dart';
import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/ti.dart';

class TikuStore extends PersistentStore<String> {
  StoreProperty<String> get index => property('index');

  void put(String courseId, String unitFile, String jsonSource) {
    Logger('put').info('$courseId-$unitFile');
    box.put('$courseId-$unitFile', jsonSource);
  }

  List<Ti>? fetch(String courseId, String unitFile) {
    Logger('put').info('$courseId-$unitFile');
    return getTiList(box.get('$courseId-$unitFile', defaultValue: null));
  }
}
