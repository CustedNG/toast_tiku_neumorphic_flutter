import 'dart:async';

import 'package:flutter/widgets.dart';

/// 从Provider获取的值，在通过notifyListener方法后，所有赋值便会刷新
class ProviderBase with ChangeNotifier {
  void setState(void Function() callback) {
    callback();
    notifyListeners();
  }
}

enum ProviderState {
  idle,
  busy,
}

/// 相比于基础Provider多了setBusyState，busyRun方法
class BusyProvider extends ProviderBase {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  setBusyState([bool isBusy = true]) {
    _isBusy = isBusy;
    notifyListeners();
  }

  FutureOr<T> busyRun<T>(FutureOr<T> Function() func) async {
    setBusyState(true);
    try {
      return await Future.sync(func);
    } catch (e) {
      rethrow;
    } finally {
      setBusyState(false);
    }
  }
}
