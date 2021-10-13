import 'dart:async';

import 'package:toast_tiku/core/provider_base.dart';

/// 考试时间计时器的实现
class TimerProvider extends BusyProvider {
  /// 计时器
  Timer? _timer;

  /// 剩余时间
  late String leftTime = '';

  /// 考试是否结束
  bool finish = false;

  /// 开始考试计时
  void start(DateTime endTime) {
    finish = false;

    /// 如果[_timer]已经被初始化，则取消之前的[_timer]
    if (_timer != null) _timer!.cancel();

    /// 每隔一秒钟，刷新一次剩余时间
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

  /// 结束计时，考试结束
  void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer == null;
    }
    leftTime = '考试已结束';
    notifyListeners();
  }
}
