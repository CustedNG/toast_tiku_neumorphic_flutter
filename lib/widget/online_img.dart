import 'package:extended_image/extended_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/widget/center_loading.dart';
import 'package:toast_tiku/widget/fade_in.dart';

/// 在线图片显示Widget
class OnlineImage extends StatelessWidget {
  final String url;
  const OnlineImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      cache: true,
      fit: BoxFit.cover,
      loadStateChanged: (xState) {
        final state = xState.extendedImageLoadState;
        switch (state) {
          case LoadState.loading:
            return centerLoading;
          case LoadState.failed:
            return Center(
                child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => xState.reLoadImage(),
            ));
          case LoadState.completed:
            return FadeIn(
                child: ExtendedRawImage(
              image: xState.extendedImageInfo?.image,
            ));
          default:
            return const Center(child: Icon(Icons.sync_problem));
        }
      },
    );
  }
}
