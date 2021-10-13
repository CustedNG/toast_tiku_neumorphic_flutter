import 'dart:async';

import 'package:flutter/widgets.dart';

/// 从Provider获取的值，在通过notifyListener方法后，所有赋值便会刷新
class ProviderBase with ChangeNotifier {
  void setState(void Function() callback) {
    callback();
    notifyListeners();
  }
}

/// Provider状态，分为[idle]和[busy]
enum ProviderState {
  idle,
  busy,
}

/// 相比于[ProviderBase]多了[setBusyState]，[busyRun]方法
class BusyProvider extends ProviderBase {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  /// 设置当前Provider的状态
  setBusyState([bool isBusy = true]) {
    _isBusy = isBusy;
    notifyListeners();
  }

  /// 执行[func]，并自动设置[isBusy]状态
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
