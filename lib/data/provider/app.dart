import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/service/app_service.dart';

class AppProvider extends BusyProvider {
  Map? _notify;
  Map? get notify => _notify;

  Future<void> loadData() async {
    final service = AppService();
    _notify = await service.getNotify();
  }
}
