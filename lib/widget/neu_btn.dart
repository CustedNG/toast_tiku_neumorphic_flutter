import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/color.dart';

class NeuIconBtn extends StatelessWidget {
  final IconData icon;
  final Function()? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final NeumorphicBoxShape? boxShape;

  const NeuIconBtn(
      {Key? key,
      required this.icon,
      this.onTap,
      this.margin,
      this.padding,
      this.boxShape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: margin ?? const EdgeInsets.all(9),
      padding: padding ?? const EdgeInsets.all(9),
      child: NeumorphicIcon(
        icon,
        style: const NeumorphicStyle(color: mainColor),
      ),
      onPressed: onTap,
      style: NeumorphicStyle(
          boxShape: boxShape ??
              NeumorphicBoxShape.roundRect(
                  const BorderRadius.all(Radius.circular(7)))),
    );
  }
}
