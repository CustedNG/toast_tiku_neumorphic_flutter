import 'package:flutter/material.dart';

/// Neumorphic风格卡片
class NeuCard extends StatelessWidget {
  /// 内容
  final Widget child;

  /// 内间距
  final EdgeInsets? padding;

  /// 外间距
  final EdgeInsets? margin;

  /// 风格
  final BorderRadius? borderRadius;

  const NeuCard(
      {Key? key, required this.child, this.padding, this.margin, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(7)),
    );
  }
}
