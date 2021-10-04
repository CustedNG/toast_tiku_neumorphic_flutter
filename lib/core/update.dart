import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:logging/logging.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/service/app.dart';

final logger = Logger('UPDATE');

Future<bool> isFileAvailable(String url) async {
  try {
    final resp = await Dio().head(url);
    return resp.statusCode == 200;
  } catch (e) {
    logger.warning('update file not available: $e');
    return false;
  }
}

Future<void> doUpdate(BuildContext context, {bool force = false}) async {
  final update = await locator<AppService>().getUpdate();

  locator<AppProvider>().setNewestBuild(update.newest);

  if (!force && update.newest <= BuildData.build) {
    logger.info('Update ignored due to current: ${BuildData.build}, '
        'update: ${update.newest}');
    return;
  }
  logger.fine('Update available: ${update.newest}');

  if (Platform.isAndroid && !await isFileAvailable(update.android)) {
    return;
  }

  showSnackBarWithAction(
      context,
      '${BuildData.name}有更新啦，Ver：${update.newest}\n${update.changelog}',
      '更新',
      () => openUrl(Platform.isAndroid ? update.android : update.ios));
}
