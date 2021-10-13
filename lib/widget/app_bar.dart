import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// App顶部bar
class NeuAppBar extends StatelessWidget {
  final MediaQueryData media;
  final Widget child;

  const NeuAppBar({Key? key, required this.media, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pad = media.size.width * 0.04;
    return Neumorphic(
      child: Padding(
          padding: EdgeInsets.fromLTRB(pad, pad + media.padding.top, pad, pad),
          child: child),
      style: const NeumorphicStyle(
          lightSource: LightSource.top,
          shadowLightColorEmboss: Colors.cyanAccent),
    );
  }
}
