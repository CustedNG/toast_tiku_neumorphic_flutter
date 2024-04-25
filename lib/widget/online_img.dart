import 'package:extended_image/extended_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'center_loading.dart';
import 'fade_in.dart';

/// 在线图片显示Widget
class OnlineImage extends StatelessWidget {
  /// 图片链接
  final String url;

  const OnlineImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      cache: true,
      fit: BoxFit.cover,
      loadStateChanged: (xState) {
        /// 根据状态返回视图
        final state = xState.extendedImageLoadState;
        switch (state) {
          /// 加载时返回加载中
          case LoadState.loading:
            return centerLoading;

          /// 加载失败，返回重试按钮
          case LoadState.failed:
            return Center(
                child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => xState.reLoadImage(),
            ),);

          /// 加载完成，显示图片
          case LoadState.completed:
            return FadeIn(
                child: ExtendedRawImage(
              image: xState.extendedImageInfo?.image,
            ),);

          /// 预料之外，显示出错
          default:
            return const Center(child: Icon(Icons.sync_problem));
        }
      },
    );
  }
}
