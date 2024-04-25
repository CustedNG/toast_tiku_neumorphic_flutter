import 'dart:io';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:logging/logging.dart';
import 'package:r_upgrade/r_upgrade.dart';

import '../data/provider/app.dart';
import '../locator.dart';
import '../res/build_data.dart';
import '../service/app.dart';
import 'utils.dart';

/// 设置Logger名称
final logger = Logger('UPDATE');

/// 开始尝试更新
Future<void> doUpdate(BuildContext context) async {
  if (isWeb) return;

  /// 调用[AppService.getUpdate()]，开始检查更新
  final update = await locator<AppService>().getUpdate();

  /// [AppProvider]设置最新版本号
  final newest = Platform.isAndroid ? update.androidbuild : update.iosbuild;
  locator<AppProvider>().setNewestBuild(newest);
  logger.info('Update: $newest, now: ${BuildData.build}');

  /// 如果版本不是最新，则跳过更新
  if (newest <= BuildData.build) {
    return;
  }

  /// 显示Snackbar，提示有更新
  showSnackBarWithAction(
      context, '${BuildData.name}有更新啦，Ver：$newest\n${update.changelog}', '更新',
      () async {
    if (Platform.isAndroid) {
      await RUpgrade.upgrade(update.android,
          fileName: update.android.split('/').last, isAutoRequestInstall: true,);
    } else if (Platform.isIOS) {
      await RUpgrade.upgradeFromAppStore(update.ios.split('id').last);
    }
  });
}
