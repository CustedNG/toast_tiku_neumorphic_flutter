import 'package:get_it/get_it.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/data/provider/history.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/store/favorite.dart';
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
  locator.registerSingleton(AppProvider());
  locator.registerSingleton(UserProvider());
  locator.registerSingleton(TikuProvider());
  locator.registerSingleton(HistoryProvider());
}

Future<void> setupLocatorForStores() async {
  final setting = SettingStore();
  await setting.init(boxName: 'setting');
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

  locator.registerSingletonAsync<FavoriteStore>(() async {
    final store = FavoriteStore();
    await store.init(boxName: 'favorite');
    return store;
  });
}

Future<void> setupLocator() async {
  await setupLocatorForStores();
  setupLocatorForProviders();
  setupLocatorForServices();
}
