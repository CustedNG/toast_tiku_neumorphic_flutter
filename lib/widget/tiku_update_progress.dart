import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../data/provider/tiku.dart';

/// 题库更新时，显示在Appbar下方的进度条
class TikuUpdateProgress extends StatelessWidget {
  const TikuUpdateProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TikuProvider>(builder: (_, tiku, __) {
      /// 如果正忙，则显示进度
      if (tiku.isBusy) {
        return NeumorphicProgress(
          percent: tiku.downloadProgress,
          height: 3,
        );
      }

      /// 不忙，下载完成，则显示空视图
      return const SizedBox(
        height: 3,
      );
    });
  }
}
