import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuDialog extends Dialog {
  final EdgeInsets? margin;
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const NeuDialog(
      {Key? key,
      required this.title,
      required this.content,
      required this.actions,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Neumorphic(
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
              const BorderRadius.all(Radius.circular(37)))),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: size.height * 0.5, maxWidth: size.width * 0.7),
        child: Padding(
          padding: margin ?? const EdgeInsets.fromLTRB(24, 17, 24, 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              content,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              )
            ],
          ),
        ),
      ),
    );
  }
}
