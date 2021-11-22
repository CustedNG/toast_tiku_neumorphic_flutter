import 'dart:io';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:logging/logging.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/service/app.dart';

/// 设置Logger名称
final logger = Logger('UPDATE');

/// 开始尝试更新, [force]是否强制更新
Future<void> doUpdate(BuildContext context) async {
  /// 调用[AppService.getUpdate()]，开始检查更新
  final update = await locator<AppService>().getUpdate();

  /// [AppProvider]设置最新版本号
  locator<AppProvider>().setNewestBuild(update.newest);

  /// 如果版本不是最新，则跳过更新
  if (update.newest <= BuildData.build) {
    logger.info('Update ignored due to current: ${BuildData.build}, '
        'update: ${update.newest}');
    return;
  }
  logger.fine('Update available: ${update.newest}');

  /// 显示Snackbar，提示有更新
  showSnackBarWithAction(
      context,
      '${BuildData.name}有更新啦，Ver：${update.newest}\n${update.changelog}',
      '更新', () async {
    if (Platform.isAndroid) {
      await RUpgrade.upgrade(update.android, fileName: update.android.split('/').last, isAutoRequestInstall: true);
    } else if (Platform.isIOS) {
      await RUpgrade.upgradeFromAppStore(update.ios.split('id').last);
    }
  });
}
