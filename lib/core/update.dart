import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:logging/logging.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/service/app.dart';

/// 设置Logger名称
final logger = Logger('UPDATE');

/// 判断更新文件是否可用
Future<bool> isFileAvailable(String url) async {
  try {
    /// 通过HTTP HEAD判断
    final resp = await Dio().head(url);

    /// HTTP状态码为200即文件可用
    return resp.statusCode == 200;
  } catch (e) {
    logger.warning('update file not available: $e');
    return false;
  }
}

/// 开始尝试更新, [force]是否强制更新
Future<void> doUpdate(BuildContext context, {bool force = false}) async {
  final update = await locator<AppService>().getUpdate();

  /// [AppProvider]设置最新版本号
  locator<AppProvider>().setNewestBuild(update.newest);

  /// 如果不是强制更新，且版本不是最新，则跳过更新
  if (!force && update.newest <= BuildData.build) {
    logger.info('Update ignored due to current: ${BuildData.build}, '
        'update: ${update.newest}');
    return;
  }
  logger.fine('Update available: ${update.newest}');

  /// 如果为Android且更新文件不可用，则跳过
  if (Platform.isAndroid && !await isFileAvailable(update.android)) {
    return;
  }

  /// 显示Snackbar，提示有更新
  showSnackBarWithAction(
      context,
      '${BuildData.name}有更新啦，Ver：${update.newest}\n${update.changelog}',
      '更新',
      () => openUrl(Platform.isAndroid ? update.android : update.ios));
}
