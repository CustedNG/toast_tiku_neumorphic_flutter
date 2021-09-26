import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/page/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('zh')],
      title: 'Toast题库',
      color: NeumorphicTheme.baseColor(context),
      themeMode: ThemeMode.system,
      darkTheme: const NeumorphicThemeData(
          baseColor: Color.fromRGBO(37, 37, 37, 1),
          shadowLightColor: Colors.deepPurple,
          intensity: 0.37),
      home: const HomePage(),
    );
  }
}
