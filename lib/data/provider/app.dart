import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/service/app.dart';

class AppProvider extends BusyProvider {
  /// App通知
  Map? _notify;
  Map? get notify => _notify;

  /// 最新版本号
  int? _newestBuild;
  int? get newestBuild => _newestBuild;

  /// 加载数据
  Future<void> loadData() async {
    setBusyState(true);

    final service = AppService();
    _notify = await service.getNotify();

    setBusyState(false);
    notifyListeners();
  }

  ///设置最新版本号
  void setNewestBuild(int build) {
    _newestBuild = build;
    notifyListeners();
  }
}
