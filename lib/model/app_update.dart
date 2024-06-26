///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class AppUpdate {
/*
{
  "newest": 33,
  "android": "https://v2.custed.lolli.tech/res/tiku/apk/33.apk",
  "ios": "https://",
  "min": 30,
  "changelog": ""
} 
*/

  /// Android 最新版本号
  late int newest;

  /// Android 最新版本下载地址
  late String android;

  /// iOS App Store 链接
  late String ios;

  /// 最小版本，低于此版本会强制提醒升级
  late int min;

  /// iOS 最新版本号
  late int iosbuild;

  /// Android 最新版本号
  late int androidbuild;

  /// 当前最新版本的更新日志
  late String changelog;

  AppUpdate({
    required this.newest,
    required this.android,
    required this.ios,
    required this.min,
    required this.iosbuild,
    required this.androidbuild,
    required this.changelog,
  });
  AppUpdate.fromJson(Map<String, dynamic> json) {
    newest = json['newest']?.toInt();
    android = json['android'].toString();
    ios = json['ios'].toString();
    min = json['min'].toInt();
    iosbuild = json['iosbuild'].toInt();
    changelog = json['changelog'].toString();
    androidbuild = json['androidbuild'].toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['newest'] = newest;
    data['android'] = android;
    data['ios'] = ios;
    data['min'] = min;
    data['iosbuild'] = iosbuild;
    data['changelog'] = changelog;
    data['androidbuild'] = androidbuild;
    return data;
  }
}
