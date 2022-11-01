import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:toast_tiku/widget/center_loading.dart';
import 'package:toast_tiku/widget/fade_in.dart';

/// 在线图片显示Widget
class OnlineImage extends StatelessWidget {
  /// 图片链接
  final String url;

  const OnlineImage({Key? key, required this.url}) : super(key: key);

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
            ));

          /// 加载完成，显示图片
          case LoadState.completed:
            return FadeIn(
                child: ExtendedRawImage(
              image: xState.extendedImageInfo?.image,
            ));

          /// 预料之外，显示出错
          default:
            return const Center(child: Icon(Icons.sync_problem));
        }
      },
    );
  }
}
