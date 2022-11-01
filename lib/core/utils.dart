import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../data/provider/tiku.dart';
import '../data/store/tiku.dart';
import '../locator.dart';
import '../model/ti.dart';
import '../widget/neu_dialog.dart';

/// 不等待
void unawaited(Future<void> future) {}

/// 判断是否为夜间模式
bool isDarkMode(BuildContext context) =>
    NeumorphicTheme.of(context)?.isUsingDark ?? false;

/// 显示Snackbar，[child]显示的widget，[context]背景
void showSnackBar(BuildContext context, Widget child) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: child));

/// 显示带有action的Snackbar
/// [content]snackbar内容，[action]snackbar按钮文字，[onTap]点击按钮后的操作
void showSnackBarWithAction(BuildContext context, String content, String action,
    GestureTapCallback onTap) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    action: SnackBarAction(
      label: action,
      onPressed: onTap,
    ),
  ));
}

/// 打开链接
Future<bool> openUrl(String url) async {
  if (!await canLaunchUrlString(url)) {
    return false;
  }
  return await launchUrlString(url, mode: LaunchMode.inAppWebView);
}

/// 获取本地题库的所有题目
List<Ti> getAllTi() {
  final tiku = locator<TikuProvider>();
  final store = locator<TikuStore>();
  final tis = <Ti>[];

  /// 先获取题库索引
  if (tiku.tikuIndex == null) {
    return tis;
  }

  /// 根据索引，循环获取每一章节数据
  for (var item in tiku.tikuIndex!) {
    for (var unit in item.content!) {
      tis.addAll(store.fetch(item.id!, unit!.data!));
    }
  }
  return tis;
}

Future<T?> showNeuDialog<T>(
    BuildContext context, String title, Widget child, Widget actions,
    {EdgeInsets? padding}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return NeuDialog(
          title: Text(title),
          content: child,
          actions: actions,
          margin: padding,
        );
      });
}

void setSystemBottomNavigationBarColor(BuildContext context) {
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]); // Enable Edge-to-Edge on Android 10+
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Colors.transparent, // Setting a transparent navigation bar color
      systemNavigationBarContrastEnforced: true, // Default
      systemNavigationBarIconBrightness: isDarkMode(context)
          ? Brightness.light
          : Brightness.dark, // This defines the color of the scrim
    ));
  }
}

double getRemainHeight(MediaQueryData media) =>
    media.size.height * 0.89 - media.padding.top - 3;
