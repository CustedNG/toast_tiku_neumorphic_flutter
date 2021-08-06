import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/app.dart';
import 'package:toast_tiku/data/provider/history.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/provider/user.dart';
import 'package:toast_tiku/locator.dart';

Future<void> initApp() async {
  await Hive.initFlutter();
  await setupLocator();
  await locator<TikuProvider>().refreshIndex();
  await locator<HistoryProvider>().loadLocalData();
}

Future<void> main() async {
  await initApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
        ChangeNotifierProvider(create: (_) => locator<TikuProvider>()),
        ChangeNotifierProvider(create: (_) => locator<HistoryProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}
