import 'dart:async';

import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/history.dart';
import 'package:toast_tiku/locator.dart';

class HistoryProvider extends BusyProvider {
  final _initialized = Completer();
  late HistoryStore _store;
  Future get initialized => _initialized.future;

  String? get lastViewed => _lastViewed;
  String? _lastViewed;

  Future<void> loadLocalData() async {
    _store = locator<HistoryStore>();
    _lastViewed = _store.lastViewedCourse.fetch();
  }

  void setLastViewed(String courseId, String unitFile) {
    final data = '$courseId-$unitFile';
    _store.lastViewedCourse.put(data);
    _lastViewed = data;
    notifyListeners();
  }
}
