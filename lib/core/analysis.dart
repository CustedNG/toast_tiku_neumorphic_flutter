import 'dart:async';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:logging/logging.dart';

class Analysis {
  /// 后端URL
  static const _url = 'https://countly.xuty.cc';

  /// 依靠KEY，让后端知道是这个app
  static const _key = 'e8c747031e8bcd7bec293247e1b9ce7058ab6e16';

  static bool _enabled = false;

  /// 初始化Countly统计
  static Future<void> init(bool debug) async {
    if (_url.isEmpty || _key.isEmpty) {
      return;
    }

    _enabled = true;
    await Countly.setLoggingEnabled(debug);
    await Countly.init(_url, _key);
    await Countly.start();
    await Countly.enableCrashReporting();
    await Countly.giveAllConsent();
    Logger('COUNTLY').fine('Init successfully.');
  }

  /// 统计不同页面的使用次数
  static void recordView(String view) {
    if (!_enabled) return;
    Countly.recordView(view);
  }

  /// 记录exception
  static void recordException(Object exception, [bool fatal = false]) {
    if (!_enabled) return;
    Countly.logException(exception.toString(), !fatal, null);
  }
}
