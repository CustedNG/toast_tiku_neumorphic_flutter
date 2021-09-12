import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/data/provider/tiku.dart';

class TikuUpdateProgress extends StatelessWidget {
  const TikuUpdateProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TikuProvider>(builder: (_, tiku, __) {
      if (tiku.isBusy) {
        return NeumorphicProgress(
          percent: tiku.downloadProgress,
          height: 3,
        );
      }
      return const SizedBox();
    });
  }
}
