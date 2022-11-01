import 'package:flutter/material.dart';
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
  final BorderRadius? borderRadius;

  const NeuIconBtn(
      {Key? key,
      required this.icon,
      this.onTap,
      this.margin,
      this.padding,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuBtn(
      margin: margin ?? const EdgeInsets.all(9),
      padding: padding ?? const EdgeInsets.all(9),
      child: Icon(
        icon,
        color: mainTextColor.resolve(context),
      ),
      onTap: onTap,
      borderRadius: borderRadius,
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
  final BorderRadius? borderRadius;

  const NeuBtn(
      {Key? key,
      required this.child,
      this.onTap,
      this.margin,
      this.padding,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding ?? const EdgeInsets.all(9), child: child),
      ),
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(7)),
    );
  }
}
