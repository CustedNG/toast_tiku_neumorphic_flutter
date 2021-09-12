import 'dart:async';

import 'package:countly_flutter/countly_flutter.dart';

class Analysis {
  static const _url = 'https://countly.xuty.cc';
  static const _key = 'e8c747031e8bcd7bec293247e1b9ce7058ab6e16';

  static bool _enabled = false;

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
    print('Countly init successfully.');
  }

  static void recordView(String view) {
    if (!_enabled) return;
    Countly.recordView(view);
  }

  static void recordException(Object exception, [bool fatal = false]) {
    if (!_enabled) return;
    Countly.logException(exception.toString(), !fatal, null);
  }
}
