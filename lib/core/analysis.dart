import 'dart:async';
import 'dart:io';

import 'package:countly_flutter/countly_config.dart';
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
    if (Platform.isAndroid || Platform.isIOS) {
      _enabled = true;
      final config = CountlyConfig(_url, _key)
          .setLoggingEnabled(debug)
          .enableCrashReporting();
      await Countly.initWithConfig(config);
      await Countly.start();
      await Countly.giveAllConsent();
    } else {
      Logger('COUNTLY')
          .info('Unsupported platform ${Platform.operatingSystem}');
    }
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
