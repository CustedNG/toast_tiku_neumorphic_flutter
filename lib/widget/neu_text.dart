import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/color.dart';

/// Neumorphic风格文字
class NeuText extends StatelessWidget {
  final TextAlign? align;
  final String text;
  final NeumorphicStyle? style;
  final NeumorphicTextStyle? textStyle;

  const NeuText(
      {Key? key, this.align, required this.text, this.style, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicText(
      text,
      textAlign: align ?? TextAlign.center,
      style: style ?? NeumorphicStyle(color: mainColor.resolve(context)),
      textStyle: textStyle,
    );
  }
}
