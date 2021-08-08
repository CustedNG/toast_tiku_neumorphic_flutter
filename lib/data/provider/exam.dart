import 'dart:async';
import 'dart:math';

import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';

class ExamProvider extends BusyProvider {
  late List<List<Ti>> _tis;
  late List<Ti> result;
  late Timer timer;

  Future<void> loadTi(
      String courseId, List<String> units, List<double> counts) async {
    setBusyState(true);
    _tis = [[], [], [], []];
    result = [];
    final _tikuStore = locator<TikuStore>();
    final allTis = <Ti>[];
    for (var item in units) {
      allTis.addAll(_tikuStore.fetch(courseId, item) ?? []);
    }
    _tis[0] = allTis.where((element) => element.type == 0).toList();
    _tis[1] = allTis.where((element) => element.type == 1).toList();
    _tis[2] = allTis.where((element) => element.type == 2).toList();
    _tis[3] = allTis.where((element) => element.type == 3).toList();

    for (int typeIdx = 0; typeIdx < 4; typeIdx++) {
      List<int> vals = [];
      for (int idx = 0; idx < counts[typeIdx].toInt(); idx++) {
        int randIdx = Random().nextInt(_tis[typeIdx].length);
        if (!vals.contains(randIdx)) {
          vals.add(randIdx);
        } else {
          idx--;
        }
      }
      for (var item in vals) {
        result.add(_tis[typeIdx][item]);
      }
    }
    _tis = [];
    setBusyState(false);
  }
}
