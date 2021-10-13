import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/color.dart';

/// Neumorphic风格图标按钮
class NeuIconBtn extends StatelessWidget {
  /// 图标
  final IconData icon;

  /// 按下后的操作
  final Function()? onTap;

  /// 外间距
  final EdgeInsets? margin;

  /// 内间距
  final EdgeInsets? padding;

  /// 按钮形状
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
        style: NeumorphicStyle(color: mainTextColor.resolve(context)),
      ),
      onTap: onTap,
      boxShape: boxShape,
    );
  }
}

/// Neumorphic风格按钮
class NeuBtn extends StatelessWidget {
  /// 注释同[NeuIconBtn]
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
      style: style ??
          NeumorphicStyle(
              boxShape: boxShape ??
                  NeumorphicBoxShape.roundRect(
                      const BorderRadius.all(Radius.circular(7)))),
    );
  }
}
