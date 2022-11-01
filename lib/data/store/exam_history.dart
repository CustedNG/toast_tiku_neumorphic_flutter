import '../../core/persistant_store.dart';
import '../../model/exam_history.dart';

/// 题库浏览历史储存库
class ExamHistoryStore extends PersistentStore<ExamHistory> {
  void add(ExamHistory history) {
    box.put(history.id, history);
  }

  ExamHistory? fetch(String id) {
    return box.get(id);
  }

  List<ExamHistory> fetchAll() {
    final list = <ExamHistory>[];
    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null) {
        list.add(item);
      }
    }
    return list;
  }

  Future<void> del(ExamHistory history) async {
    await box.delete(history.id);
  }

  Future<void> clear() async {
    await box.deleteAll(box.keys);
  }
}
