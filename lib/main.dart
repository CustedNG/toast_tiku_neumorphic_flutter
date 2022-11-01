import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/data/store/exam_history.dart';
import 'package:toast_tiku/data/store/favorite.dart';
import 'package:toast_tiku/data/store/setting.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/data/store/tiku_index.dart';
import 'package:toast_tiku/data/store/unit_history.dart';

import 'app.dart';
import 'core/analysis.dart';
import 'data/provider/app.dart';
import 'data/provider/debug.dart';
import 'data/provider/exam.dart';
import 'data/provider/tiku.dart';
import 'data/provider/timer.dart';
import 'data/provider/unit_history.dart';
import 'locator.dart';
import 'model/check_state.dart';
import 'model/exam_history.dart';
import 'model/ti.dart';
import 'model/tiku_index.dart';
import 'res/app.dart';

/// 初始化App
Future<void> initApp() async {
  await initHive();
  await setupLocator();

  // 等待store加载完成
  await GetIt.I.allReady();
  await doDbUpgrade();

  /// Provider初始化数据
  await locator<TikuProvider>().loadLocalData();
  await locator<HistoryProvider>().loadLocalData();

  ///设置Logger
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[${record.loggerName}][${record.level.name}]: ${record.message}');
  });
}

Future<void> doDbUpgrade() async {
  final nowStoreVersion = locator<SettingStore>().storeVersion;
  if (nowStoreVersion.fetch()! < storeVersion) {
    // 数据库升级
    final stores = [
      locator<FavoriteStore>(),
      locator<TikuStore>(),
      locator<TikuIndexStore>(),
      locator<HistoryStore>(),
      locator<ExamHistoryStore>()
    ];
    for (final store in stores) {
      await store.box.deleteAll(store.box.keys);
    }
    locator<SettingStore>().storeVersion.put(storeVersion);
  }
}

Future<void> initHive() async {
  /// 加载Hive数据库
  await Hive.initFlutter();

  Hive.registerAdapter(ExamHistoryAdapter());
  Hive.registerAdapter(CheckStateAdapter());
  Hive.registerAdapter(TiAdapter());
  Hive.registerAdapter(TikuIndexAdapter());
  Hive.registerAdapter(TikuIndexContentAdapter());
  Hive.registerAdapter(TikuIndexRawAdapter());
}

void runInZone(dynamic Function() body) {
  final zoneSpec = ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      parent.print(zone, line);
      // This is a hack to avoid
      // `setState() or markNeedsBuild() called during build`
      // error.
      Future.delayed(const Duration(milliseconds: 1), () {
        final debugProvider = locator<DebugProvider>();
        debugProvider.addText(line);
      });
    },
  );

  runZonedGuarded(
    body,
    onError,
    zoneSpecification: zoneSpec,
  );
}

/// 发生错误时，执行的操作
void onError(Object obj, StackTrace stack) {
  Logger('MAIN').warning('error: $obj');
  Analysis.recordException(obj);
  final debugProvider = locator<DebugProvider>();
  debugProvider.addError(obj);
  debugProvider.addError(stack);
}

/// 程序入口
Future<void> main() async {
  runInZone(() async {
    await initApp();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<AppProvider>()),
          ChangeNotifierProvider(create: (_) => locator<ExamProvider>()),
          ChangeNotifierProvider(create: (_) => locator<TikuProvider>()),
          ChangeNotifierProvider(create: (_) => locator<DebugProvider>()),
          ChangeNotifierProvider(create: (_) => locator<TimerProvider>()),
          ChangeNotifierProvider(create: (_) => locator<HistoryProvider>()),
        ],
        child: const MyApp(),
      ),
    );
  });
}
