import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final NeumorphicStyle? style;

  const ClayCard(
      {Key? key, required this.child, this.padding, this.margin, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: child,
      margin: margin ?? const EdgeInsets.all(9),
      padding: padding ?? const EdgeInsets.all(11),
      style: style,
    );
  }
}
