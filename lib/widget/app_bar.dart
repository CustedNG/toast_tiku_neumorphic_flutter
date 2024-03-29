import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// App顶部bar
class NeuAppBar extends StatelessWidget {
  final MediaQueryData media;
  final Widget child;

  const NeuAppBar({Key? key, required this.media, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Column(
        children: [
          SizedBox(
            height: media.padding.top,
          ),
          SizedBox(
            height: media.size.height * 0.11,
            width: media.size.width,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: media.size.width * 0.04),
              child: child,
            ),
          )
        ],
      ),
      style: const NeumorphicStyle(
          lightSource: LightSource.top,
          shadowLightColorEmboss: Colors.cyanAccent),
    );
  }
}
