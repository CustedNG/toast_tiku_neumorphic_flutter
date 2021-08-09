import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/utils.dart';

class DynamicColor {
  /// 白天模式显示的颜色
  Color light;
  /// 暗黑模式显示的颜色
  Color dark;

  DynamicColor(this.light, this.dark);

  resolve(BuildContext context) => isDarkMode(context) ? dark : light;
}

final mainColor = DynamicColor(Colors.black87, Colors.white70);