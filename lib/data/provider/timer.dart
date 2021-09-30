import 'dart:async';

import 'package:toast_tiku/core/provider_base.dart';

class TimerProvider extends BusyProvider {
  Timer? _timer;
  late String leftTime = '';
  bool finish = false;

  void start(DateTime endTime) {
    finish = false;
    if (_timer != null) _timer!.cancel();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _timer = timer;
      final duration = endTime.difference(DateTime.now());
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds - 60 * minutes;
      if (seconds < 0) {
        leftTime = '考试已结束';
        finish = true;
        notifyListeners();
        _timer!.cancel();
        _timer == null;
      } else {
        leftTime = '$minutes分$seconds秒';
      }
      notifyListeners();
    });
  }

  void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer == null;
    }
    leftTime = '考试已结束';
    notifyListeners();
  }
}
