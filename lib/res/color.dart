import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/setting.dart';
import 'package:toast_tiku/locator.dart';

Color get primaryColor => Color(locator<SettingStore>().appPrimaryColor.fetch()!);

class DynamicColor {
  Color light;
  Color dark;

  /// [白天模式显示的颜色],[暗黑模式显示的颜色]
  DynamicColor(this.light, this.dark);

  resolve(BuildContext context) => isDarkMode(context) ? dark : light;
}

/// 主文字颜色
final mainTextColor = DynamicColor(Colors.black87, Colors.white70);
