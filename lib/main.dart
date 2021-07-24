import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/app.dart';
import 'package:toast_tiku/data/provider/user.dart';
import 'package:toast_tiku/locator.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await GetIt.instance.allReady();
  await setupLocator();
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
