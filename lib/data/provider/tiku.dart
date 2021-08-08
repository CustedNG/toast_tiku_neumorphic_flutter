import 'dart:async';
import 'dart:convert';

import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/service/app.dart';

class TikuProvider extends BusyProvider {
  final _initialized = Completer();
  Future get initialized => _initialized.future;

  List<TikuIndex>? _tikuIndexes;
  List<TikuIndex>? get tikuIndex => _tikuIndexes;
  // index下载状态用busyState获取，unit进度用downloadProgress
  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;
  late String indexVersion;

  Future<void> loadLocalData() async {
    final store = locator<TikuStore>();
    _tikuIndexes = getTikuIndexList(store.index.fetch());
  }

  Future<void> refreshIndex() async {
    setBusyState(true);
    final tikuIndexRaw = await AppService().getTikuIndex();
    if (tikuIndexRaw == null) {
      print('get tiku index failed');
      return;
    }
    _tikuIndexes = tikuIndexRaw.tikuIndexes;
    indexVersion = tikuIndexRaw.version;

    final store = locator<TikuStore>();
    store.index.put(json.encode(_tikuIndexes));
    setBusyState(false);
  }

  Future<void> refreshUnit() async {
    setBusyState(true);
    final store = await locator<TikuStore>();
    // 如果版本相同，跳过更新
    if (store.version.fetch() == indexVersion) {
      setBusyState(false);
      return;
    }
    // 索引数据为空，跳过更新
    if (_tikuIndexes == null) {
      setBusyState(false);
      print('tiku index is null, skip getting detailed data');
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
        final unitData =
            await AppService().getUnitTi(index.id!, content!.data!);
        store.put(index.id!, content.data!, unitData!);
        _downloadProgress = idx++ / length;
        notifyListeners();
      }
    }
    store.version.put(indexVersion);
    setBusyState(false);
  }

  Future<void> refreshData() async {
    await refreshIndex();
    await refreshUnit();
  }
}
