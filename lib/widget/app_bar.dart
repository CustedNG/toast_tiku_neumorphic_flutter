import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

/// App顶部bar
class NeuAppBar extends StatelessWidget {
  final MediaQueryData media;
  final Widget child;

  const NeuAppBar({super.key, required this.media, required this.child});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
          lightSource: LightSource.top,
          shadowLightColorEmboss: Colors.cyanAccent),
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
    );
  }
}
