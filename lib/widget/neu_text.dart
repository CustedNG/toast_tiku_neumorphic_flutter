import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../res/color.dart';

/// Neumorphic风格文字
class NeuText extends StatelessWidget {
  /// 文字对齐
  final TextAlign? align;

  /// 文字内容
  final String text;

  /// Neumorphic风格
  final NeumorphicStyle? style;

  /// 文字风格（字体）
  final NeumorphicTextStyle? textStyle;

  const NeuText(
      {Key? key, this.align, required this.text, this.style, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicText(
      text,
      textAlign: align ?? TextAlign.center,
      style: style ?? NeumorphicStyle(color: mainTextColor.resolve(context)),
      textStyle: textStyle,
    );
  }
}
