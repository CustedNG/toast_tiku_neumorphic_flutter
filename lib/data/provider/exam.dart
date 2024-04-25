import 'dart:async';
import 'dart:math';

import '../../core/provider_base.dart';
import '../../locator.dart';
import '../../model/ti.dart';
import '../store/tiku.dart';
import 'tiku.dart';

class ExamProvider extends BusyProvider {
  /// 所有题目
  late List<List<Ti>> _tis;

  /// 条件筛选后的题目
  late List<Ti> result;

  /// 加载题目到Provider
  Future<void> loadTi(
      String courseId, List<String> units, List<double> counts,) async {
    setBusyState(true);

    /// 初始化空数据
    _tis = [[], [], [], []];
    result = [];

    /// 获取题库内该科目的所有题目
    final allTis = <Ti>[];
    final tikuStore = locator<TikuStore>();
    for (var subject in locator<TikuProvider>().tikuIndex!) {
      if (subject.id != courseId) {
        continue;
      }
      for (var content in subject.content!) {
        allTis.addAll(tikuStore.fetch(subject.id!, content!.data!));
      }
    }

    /// 选出题目type为0的题
    _tis[0] = allTis.where((element) => element.type == 0).toList();

    /// 选出题目type为1的题
    _tis[1] = allTis.where((element) => element.type == 1).toList();

    /// 选出题目type为2的题
    _tis[2] = allTis.where((element) => element.type == 2).toList();

    /// 选出题目type为3的题
    _tis[3] = allTis.where((element) => element.type == 3).toList();

    /// 在题目数量内，随机抽取一道题，添加进[result]
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

    /// 清空所有题目List
    _tis = [];
    setBusyState(false);
  }
}
