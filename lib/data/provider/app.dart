import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/service/app.dart';

class AppProvider extends BusyProvider {
  Map? _notify;
  Map? get notify => _notify;

  Future<void> loadData() async {
    setBusyState(true);
    final service = AppService();
    _notify = await service.getNotify();
    setBusyState(false);
    notifyListeners();
  }
}
