import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:url_launcher/url_launcher.dart';

void unawaited(Future<void> future) {}

bool isDarkMode(BuildContext context) =>
    NeumorphicTheme.of(context)!.isUsingDark;

void showSnackBar(BuildContext context, Widget child) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: child));

void showSnackBarWithAction(
    BuildContext context, String content, String action, Function onTap) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    action: SnackBarAction(
      label: action,
      onPressed: () => onTap,
    ),
  ));
}

Future<bool> openUrl(String url) async {
  if (!await canLaunch(url)) {
    return false;
  }
  return await launch(url, forceSafariVC: false);
}

List<Ti> getAllTi() {
  final tiku = locator<TikuProvider>();
  final store = locator<TikuStore>();
  if (tiku.tikuIndex == null) {
    return <Ti>[];
  }
  final tis = <Ti>[];
  for (var item in tiku.tikuIndex!) {
    for (var unit in item.content!) {
      tis.addAll(store.fetch(item.id!, unit!.data!)!);
    }
  }
  return tis;
}
