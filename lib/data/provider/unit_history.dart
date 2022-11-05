import 'dart:async';

import '../../core/provider_base.dart';
import '../../locator.dart';
import '../store/unit_history.dart';

class HistoryProvider extends BusyProvider {
  final _initialized = Completer();
  Future get initialized => _initialized.future;

  late HistoryStore _store;

  /// 上次浏览的科目和章节
  String? get lastViewed => _lastViewed;
  String? _lastViewed;

  /// 加载数据到Provider
  Future<void> loadLocalData() async {
    _store = locator<HistoryStore>();
    _lastViewed = _store.lastViewedCourse.fetch();
  }

  /// 设置上次浏览的数据
  void setLastViewed(String courseId, String unitFile) {
    final data = '$courseId-$unitFile';
    _store.lastViewedCourse.put(data);
    _lastViewed = data;
    notifyListeners();
  }
}
