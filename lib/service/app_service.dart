import 'package:dio/dio.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/res/url.dart';

class AppService {
  final logger = Logger('AppService');

  Future<TikuIndexRaw?> getTikuIndex() async {
    final resp = await Dio().get('$tikuResUrl/index.json');
    logger.info('get index: ${resp.statusCode}');
    if (resp.statusCode == 200) {
      return TikuIndexRaw(resp.data['version'], getTikuIndexList(resp.data));
    }
  }

  Future<List<Ti>?> getUnitTi(String courseId, String unitFile) async {
    final resp = await Dio().get('$tikuResUrl/$courseId/$unitFile');
    logger.info('get unit ti: $courseId, $unitFile, ${resp.statusCode}');
    if (resp.statusCode == 200) {
      return getTiList(resp.data);
    }
  }
}
