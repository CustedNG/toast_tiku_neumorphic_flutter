import 'package:get_it/get_it.dart';

import 'data/provider/app.dart';
import 'data/provider/debug.dart';
import 'data/provider/exam.dart';
import 'data/provider/tiku.dart';
import 'data/provider/timer.dart';
import 'data/provider/unit_history.dart';
import 'data/store/exam_history.dart';
import 'data/store/favorite.dart';
import 'data/store/setting.dart';
import 'data/store/tiku.dart';
import 'data/store/tiku_index.dart';
import 'data/store/unit_history.dart';
import 'service/app.dart';

/// Locator，教程可见: https://pub.dev/packages/get_it, https://blog.csdn.net/unicorn97/article/details/100769418
GetIt locator = GetIt.instance;

/// 注册服务
void setupLocatorForServices() {
  locator.registerLazySingleton(() => AppService());
}

/// 注册Provider
void setupLocatorForProviders() {
  locator.registerSingleton(AppProvider());
  locator.registerSingleton(ExamProvider());
  locator.registerSingleton(TikuProvider());
  locator.registerSingleton(DebugProvider());
  locator.registerSingleton(TimerProvider());
  locator.registerSingleton(HistoryProvider());
}

/// 注册持久化储存
Future<void> setupLocatorForStores() async {
  final setting = SettingStore();
  await setting.init(boxName: 'setting');
  locator.registerSingleton(setting);

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

  locator.registerSingletonAsync<ExamHistoryStore>(() async {
    final store = ExamHistoryStore();
    await store.init(boxName: 'exam_history');
    return store;
  });

  locator.registerSingletonAsync<TikuIndexStore>(() async {
    final store = TikuIndexStore();
    await store.init(boxName: 'tiku_index');
    return store;
  });
}

/// 初始化locator
Future<void> setupLocator() async {
  await setupLocatorForStores();
  setupLocatorForProviders();
  setupLocatorForServices();
}
