import 'dart:async';

import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/history.dart';
import 'package:toast_tiku/locator.dart';

class HistoryProvider extends BusyProvider {
  final _initialized = Completer();
  Future get initialized => _initialized.future;

  String? get lastViewed => _lastViewed;
  String? _lastViewed;

  Future<void> loadLocalData() async {
    final store = locator<HistoryStore>();
    _lastViewed = store.lastViewedCourse.fetch();
  }

  void setLastViewed(String courseId, String unitFile) {
    final data = '$courseId-$unitFile';
    final store = locator<HistoryStore>();
    store.lastViewedCourse.put(data);
    _lastViewed = data;
    notifyListeners();
  }
}
