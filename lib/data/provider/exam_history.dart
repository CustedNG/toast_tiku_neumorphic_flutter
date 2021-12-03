import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/exam_history.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/exam_history.dart';

class ExamHistoryProvider extends BusyProvider {
  List<ExamHistory> histories = [];
  late ExamHistoryStore _store;

  /// 加载数据
  Future<void> loadData() async {
    setBusyState(true);

    _store = locator<ExamHistoryStore>();
    histories = _store.fetch();

    setBusyState(false);
    notifyListeners();
  }

  void addHistory(ExamHistory history) {
    histories.add(history);
    _store.add(history);
    notifyListeners();
  }

  void delHistory(ExamHistory history) {
    histories.remove(history);
    _store.del(history);
    notifyListeners();
  }

  void delAllHistory() {
    histories.clear();
    _store.clear();
    notifyListeners();
  }
}
