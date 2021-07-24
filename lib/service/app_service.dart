import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/model/tiku_index.dart';

class AppService {
  static const tikuRes = 'https://v2.custed.lolli.tech/res/tiku';

  Future<List<TikuIndex>?> getTikuIndex() async {
    final resp = await Dio().get('$tikuRes/index.json');
    if (resp.statusCode == 200) {
      return getTikuIndexList(json.decode(resp.data));
    }
  }

  Future<List<Ti>?> getUnitTi(String courseId, int unitIdx) async {
    final resp = await Dio().get('$tikuRes/$courseId/$unitIdx.json');
    if (resp.statusCode == 200) {
      return getTiList(json.decode(resp.data));
    }
  }
}
