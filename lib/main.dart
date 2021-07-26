import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/app.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/provider/user.dart';
import 'package:toast_tiku/locator.dart';

Future<void> initApp() async {
  await Hive.initFlutter();
  await setupLocator();
  await locator<TikuProvider>().refreshIndex();
}

Future<void> main() async {
  await initApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}
