import 'package:dio/dio.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/model/tiku_index.dart';

class AppService {
  static const tikuRes = 'https://v2.custed.lolli.tech/res/tiku';
  final logger = Logger('AppService');

  Future<List<TikuIndex>?> getTikuIndex() async {
    final resp = await Dio().get('$tikuRes/index.json');
    logger.info('get index: ${resp.statusCode}');
    if (resp.statusCode == 200) {
      return getTikuIndexList(resp.data);
    }
  }

  Future<List<Ti>?> getUnitTi(String courseId, String unitFile) async {
    final resp = await Dio().get('$tikuRes/$courseId/$unitFile');
    logger.info('get unit ti: $courseId, $unitFile, ${resp.statusCode}');
    if (resp.statusCode == 200) {
      return getTiList(resp.data);
    }
  }
}
