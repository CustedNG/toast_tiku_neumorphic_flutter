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

  late int newest;
  late String android;
  late String ios;
  late int min;
  late String changelog;

  AppUpdate({
    required this.newest,
    required this.android,
    required this.ios,
    required this.min,
    required this.changelog,
  });
  AppUpdate.fromJson(Map<String, dynamic> json) {
    newest = json["newest"]?.toInt();
    android = json["android"].toString();
    ios = json["ios"].toString();
    min = json["min"].toInt();
    changelog = json["changelog"].toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["newest"] = newest;
    data["android"] = android;
    data["ios"] = ios;
    data["min"] = min;
    data["changelog"] = changelog;
    return data;
  }
}
