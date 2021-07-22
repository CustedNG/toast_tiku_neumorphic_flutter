import 'package:get_it/get_it.dart';
import 'package:toast_tiku/data/setting_store.dart';
import 'package:toast_tiku/data/user_provider.dart';
import 'package:toast_tiku/data/user_store.dart';
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
}

Future<void> setupLocator() async {
  await setupLocatorForStores();
  setupLocatorForProviders();

  setupLocatorForServices();
}
