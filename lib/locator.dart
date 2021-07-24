import 'package:get_it/get_it.dart';
import 'package:toast_tiku/data/store/history.dart';
import 'package:toast_tiku/data/store/setting.dart';
import 'package:toast_tiku/data/provider/user.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/data/store/user.dart';
import 'package:toast_tiku/service/app_service.dart';

GetIt locator = GetIt.instance;

void setupLocatorForServices() {
  locator.registerLazySingleton(() => AppService());
}

void setupLocatorForProviders() {
  locator.registerSingleton(UserProvider());
}

Future<void> setupLocatorForStores() async {
  final setting = SettingStore();
  await setting.init();
  locator.registerSingleton(setting);

  locator.registerSingletonAsync<UserStore>(() async {
    final store = UserStore();
    await store.init(boxName: 'user');
    return store;
  });

  locator.registerSingletonAsync<TikuStore>(() async {
    final store = TikuStore();
    await store.init(boxName: 'tiku');
    return store;
  });

  locator.registerSingletonAsync<HistoryStore>(() async {
    final store = HistoryStore();
    await store.init(boxName: 'history');
    return store;
  });
}

Future<void> setupLocator() async {
  await setupLocatorForStores();
  setupLocatorForProviders();

  setupLocatorForServices();
}
