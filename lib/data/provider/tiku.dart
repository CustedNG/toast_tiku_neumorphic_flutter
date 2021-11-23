import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/service/app.dart';

/// 题库结构为[题库=题库索引+题库每个章节的数据]，题库索引中记录了每个章节的链接，从该链接获取题库每个章节的数据
class TikuProvider extends BusyProvider {
  final logger = Logger('TIKU');

  final _initialized = Completer();
  Future get initialized => _initialized.future;

  late TikuStore _store;

  /// 题库索引数据
  List<TikuIndex>? _tikuIndexes;
  List<TikuIndex>? get tikuIndex => _tikuIndexes;

  // [题库数据下载进度]，index下载状态用busyState获取，unit下载进度用downloadProgress获取
  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;

  /// 题库索引的版本号
  late String indexVersion;

  /// 加载数据到Provider
  Future<void> loadLocalData() async {
    _store = locator<TikuStore>();
    _tikuIndexes = getTikuIndexList(_store.index.fetch());
  }

  /// 刷新题库索引数据
  Future<void> refreshIndex() async {
    setBusyState(true);
    final tikuIndexRaw = await AppService().getTikuIndex();
    if (tikuIndexRaw == null) {
      logger.warning('get tiku index failed');
      return;
    }
    _tikuIndexes = tikuIndexRaw.tikuIndexes;
    indexVersion = tikuIndexRaw.version;

    _store.index.put(json.encode(_tikuIndexes));
    setBusyState(false);
  }

  /// 刷新题库每个章节的数据
  Future<void> refreshUnit() async {
    setBusyState(true);
    // 如果版本相同，跳过更新
    if (_store.version.fetch() == indexVersion) {
      setBusyState(false);
      return;
    }
    // 索引数据为空，跳过更新
    if (_tikuIndexes == null) {
      setBusyState(false);
      logger.warning('tiku index is null, skip getting detailed data');
      return;
    }
    // 获取进度百分比
    int length = _tikuIndexes!.length;
    int idx = 0;
    for (var index in _tikuIndexes!) {
      length += index.content!.length;
    }
    for (var index in _tikuIndexes!) {
      for (var content in index.content!) {
        /// 获取每个章节的数据
        final unitData =
            await AppService().getUnitTi(index.id!, content!.data!);
        if (unitData == null) {
          logger.warning('get unit data failed');
          continue;
        }
        unitData.sort((a, b) => a.type!.compareTo(b.type!));
        _store.put(index.id!, content.data!, unitData);

        /// 更新进度
        _downloadProgress = idx++ / length;
        notifyListeners();
      }
    }
    _store.version.put(indexVersion);
    setBusyState(false);
  }

  /// 刷新题库所有数据
  Future<void> refreshData() async {
    await refreshIndex();
    await refreshUnit();
  }
}
