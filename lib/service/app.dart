import 'package:dio/dio.dart';
import 'package:toast_tiku/model/app_update.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/res/url.dart';

class AppService {
  Future<TikuIndexRaw?> getTikuIndex() async {
    final resp = await Dio().get('$tikuResUrl/index.json');
    if (resp.statusCode == 200) {
      return TikuIndexRaw(resp.data['version'], getTikuIndexList(resp.data));
    }
  }

  Future<List<Ti>?> getUnitTi(String courseId, String unitFile) async {
    final resp = await Dio().get('$tikuResUrl/$courseId/$unitFile');
    if (resp.statusCode == 200) {
      return getTiList(resp.data);
    }
  }

  Future<Map> getNotify() async {
    final resp = await Dio().get('$tikuResUrl/notify.json');
    return resp.data;
  }

  Future<AppUpdate> getUpdate() async {
    final resp = await Dio().get('$tikuResUrl/update.json');
    return AppUpdate.fromJson(resp.data);
  }
}
