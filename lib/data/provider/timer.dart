import 'dart:async';

import 'package:toast_tiku/core/provider_base.dart';

class TimerProvider extends BusyProvider {
  Timer? _timer;
  late String leftTime = '';

  void start(DateTime endTime) {
    if (_timer != null) _timer!.cancel();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _timer = timer;
      final duration = endTime.difference(DateTime.now());
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds - 60 * minutes;
      leftTime = '$minutes分$seconds秒';
      notifyListeners();
    });
  }
}
