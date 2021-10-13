import 'package:flutter/material.dart';

/// App页面间跳转的路由
class AppRoute {
  final Widget page;

  AppRoute(this.page);

  /// 调用即跳转
  void go(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
