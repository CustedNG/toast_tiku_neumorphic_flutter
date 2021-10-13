import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/data/store/setting.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/page/home.dart';

/// App入口
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 创建了一个可监听的、范型为bool的监听器，[locator<SettingStore>().blackBackground.listenable()]的所有变化，都会使视图刷新
    return ValueListenableBuilder<bool>(
      valueListenable: locator<SettingStore>().blackBackground.listenable(),
      builder: (_, value, __) {
        return NeumorphicApp(
          /// 不显示App右上角的debug调试条
          debugShowCheckedModeBanner: false,

          /// 使用本地化
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate],

          /// 设置支持的语言
          supportedLocales: const [Locale('zh')],

          /// App的标题
          title: 'Toast题库',

          /// App主色调
          color: NeumorphicTheme.baseColor(context),

          /// App主题模式，分为白天、黑夜和跟随系统模式
          themeMode: ThemeMode.system,

          /// 自定义夜间模式的参数
          darkTheme: NeumorphicThemeData(
              baseColor:
                  value ? Colors.black : const Color.fromRGBO(37, 37, 37, 1),
              shadowLightColor: Colors.deepPurple,
              intensity: 0.37),
          home: const HomePage(),
        );
      },
    );
  }
}
