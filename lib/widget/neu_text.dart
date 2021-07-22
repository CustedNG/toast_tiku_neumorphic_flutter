import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/color.dart';

class NeuText extends StatelessWidget {
  final TextAlign? align;
  final String text;

  const NeuText({Key? key, this.align, required this.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return NeumorphicText(
      text, 
      textAlign: align ?? TextAlign.center,
      style: const NeumorphicStyle(color: mainColor),
    );
  }
}
