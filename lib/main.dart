import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/app.dart';
import 'package:toast_tiku/core/analysis.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/data/provider/debug.dart';
import 'package:toast_tiku/data/provider/exam.dart';
import 'package:toast_tiku/data/provider/exam_history.dart';
import 'package:toast_tiku/data/provider/unit_history.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/provider/timer.dart';
import 'package:toast_tiku/locator.dart';

/// 初始化App
Future<void> initApp() async {
  /// 加载Hive数据库
  await Hive.initFlutter();
  await setupLocator();

  // 等待store加载完成
  await GetIt.I.allReady();

  /// Provider初始化数据
  await locator<TikuProvider>().loadLocalData();
  await locator<HistoryProvider>().loadLocalData();
  await locator<ExamHistoryProvider>().loadData();

  ///设置Logger
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[${record.loggerName}][${record.level.name}]: ${record.message}');
  });
}

/// 在空间内运行
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
