import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'core/utils.dart';
import 'data/store/setting.dart';
import 'locator.dart';
import 'page/home.dart';

/// App入口
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    setSystemBottomNavigationBarColor(context);

    // ignore: avoid_print
    print(r'''
    
 _____               _  _____ _ _          
|_   _|__   __ _ ___| ||_   _(_) | ___   _ 
  | |/ _ \ / _` / __| __|| | | | |/ / | | |
  | | (_) | (_| \__ \ |_ | | | |   <| |_| |
  |_|\___/ \__,_|___/\__||_| |_|_|\_\\__,_|

              题库已装载完毕!        
    ''');

    /// 返回了一个可监听的、泛型为bool的构建器。
    /// [locator<SettingStore>().appPrimaryColor]的所有变化，都会使视图刷新
    return ValueListenableBuilder<int>(
      valueListenable: locator<SettingStore>().appPrimaryColor.listenable(),
      builder: (_, value, __) {
        final primaryColor = Color(value);
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

          /// App主题模式，三种参数分为白天、黑夜和跟随系统模式，这里是跟随系统
          themeMode: ThemeMode.system,

          /// 自定义白天模式主题的参数
          theme: NeumorphicThemeData(
              accentColor: primaryColor,
              variantColor: primaryColor.withOpacity(0.47),
              shadowLightColor: primaryColor,
              intensity: 0.33,),

          /// 自定义夜间模式主题的参数
          darkTheme: NeumorphicThemeData(
              baseColor: const Color.fromRGBO(37, 37, 37, 1),
              accentColor: primaryColor,
              variantColor: primaryColor.withOpacity(0.47),
              shadowLightColor: primaryColor,
              intensity: 0.43,),

          /// App视图入口
          home: const HomePage(),
        );
      },
    );
  }
}
