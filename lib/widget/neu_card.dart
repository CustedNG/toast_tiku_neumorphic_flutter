import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final NeumorphicStyle? style;

  const NeuCard(
      {Key? key, required this.child, this.padding, this.margin, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: child,
      padding: margin ?? const EdgeInsets.all(9),
      margin: padding ?? const EdgeInsets.all(11),
      style: style,
    );
  }
}