import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/page/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NeumorphicApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [Locale('zh')],
      title: 'Toast题库',
      themeMode: ThemeMode.system,
      darkTheme: NeumorphicThemeData(
          baseColor: Color.fromRGBO(17, 17, 17, 1),
          shadowLightColor: Colors.deepPurple,
          intensity: 0.37),
      home: HomePage(),
    );
  }
}
