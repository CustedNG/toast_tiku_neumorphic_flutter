import 'dart:convert';

import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/model/exam_history.dart';

/// 题库浏览历史储存库
class ExamHistoryStore extends PersistentStore {
  void add(ExamHistory history) {
    final old = fetch();
    old.add(history);
    box.put('all', json.encode(old));
  }

  List<ExamHistory> fetch() {
    final data = box.get('all', defaultValue: [])!;
    final histories = <ExamHistory>[];
    for (var item in data) {
      histories.add(ExamHistory.fromJson(item));
    }
    return histories;
  }

  bool del(ExamHistory history) {
    final old = fetch();
    final index =
        old.indexWhere((item) => item.chechState == history.chechState);
    if (index == -1) {
      return false;
    }
    old.removeAt(index);
    box.put('all', json.encode(old));
    return true;
  }

  void clear() {
    box.delete('all');
  }
}
