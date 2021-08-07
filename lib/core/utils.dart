import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';

void unawaited(Future<void> future) {}

bool isDarkMode(BuildContext context) =>
    NeumorphicTheme.of(context)!.isUsingDark;

void showSnackBar(BuildContext context, Widget child) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: child));

Future<bool> openUrl(String url) async {
  print('openUrl $url');

  if (!await canLaunch(url)) {
    print('canLaunch false');
    return false;
  }

  final ok = await launch(url, forceSafariVC: false);

  if (ok == true) {
    return true;
  }

  print('launch $url failed');

  return false;
}