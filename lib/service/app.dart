import 'package:dio/dio.dart';
import 'package:toast_tiku/model/app_update.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/res/url.dart';

/// App服务
class AppService {
  /// 获取题库索引数据
  Future<TikuIndexRaw?> getTikuIndex() async {
    final resp = await Dio().get('$tikuResUrl/index.json');
    if (resp.statusCode == 200) {
      return TikuIndexRaw(resp.data['version'], getTikuIndexList(resp.data));
    }
  }

  /// 获取每个单元的题目
  Future<List<Ti>?> getUnitTi(String courseId, String unitFile) async {
    final resp = await Dio().get('$tikuResUrl/$courseId/$unitFile');
    if (resp.statusCode == 200) {
      return getTiList(resp.data);
    }
  }

  /// 获取App内通知
  Future<Map> getNotify() async {
    final resp = await Dio().get('$tikuResUrl/notify.json');
    return resp.data;
  }

  /// 获取更新数据
  Future<AppUpdate> getUpdate() async {
    final resp = await Dio().get('$tikuResUrl/update.json');
    return AppUpdate.fromJson(resp.data);
  }

  /// 获取贡献者名单
  Future<String> getContributor() async {
    final resp = await Dio().get('$tikuResUrl/contributor.txt');
    return resp.data;
  }
}
