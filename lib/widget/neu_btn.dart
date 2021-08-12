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
    return NeuBtn(
      margin: margin ?? const EdgeInsets.all(9),
      padding: padding ?? const EdgeInsets.all(9),
      child: NeumorphicIcon(
        icon,
        style: NeumorphicStyle(color: mainColor.resolve(context)),
      ),
      onTap: onTap,
      boxShape: boxShape,
    );
  }
}

class NeuBtn extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final NeumorphicBoxShape? boxShape;
  final NeumorphicStyle? style;

  const NeuBtn(
      {Key? key,
      required this.child,
      this.onTap,
      this.margin,
      this.padding,
      this.boxShape, 
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: margin ?? const EdgeInsets.all(9),
      margin: padding ?? const EdgeInsets.all(9),
      child: child,
      onPressed: onTap,
      style: style ?? NeumorphicStyle(
          boxShape: boxShape ??
              NeumorphicBoxShape.roundRect(
                  const BorderRadius.all(Radius.circular(7)))),
    );
  }
}
