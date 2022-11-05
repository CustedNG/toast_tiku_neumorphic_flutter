import '../../core/provider_base.dart';
import '../../service/app.dart';

class AppProvider extends BusyProvider {
  /// App通知
  Map? _notify;
  Map? get notify => _notify;

  /// 最新版本号
  int? _newestBuild;
  int? get newestBuild => _newestBuild;

  /// 贡献者名单
  List<String> _contributors = ['Made with ❤️', '欢迎参与题库贡献', '此处将会展示贡献者'];
  List<String> get contributors => _contributors;

  /// 加载数据
  Future<void> loadData() async {
    setBusyState(true);

    final service = AppService();
    _notify = await service.getNotify();
    final _contributorsRaw = await service.getContributor();
    final _contributorList = _contributorsRaw.trim().split(',');
    _contributorList.shuffle();
    _contributors = _contributorList;

    setBusyState(false);
    notifyListeners();
  }

  ///设置最新版本号
  void setNewestBuild(int build) {
    _newestBuild = build;
    notifyListeners();
  }
}
