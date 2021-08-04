import 'dart:async';
import 'dart:convert';

import 'package:simple_logger/simple_logger.dart';
import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/service/app_service.dart';

class TikuProvider extends BusyProvider {
  final _initialized = Completer();
  Future get initialized => _initialized.future;

  List<TikuIndex>? _tikuIndexes;
  List<TikuIndex>? get tikuIndex => _tikuIndexes;

  Future<void> loadLocalData() async {
    final store = locator<TikuStore>();
    _tikuIndexes = getTikuIndexList(store.index.fetch());
  }

  Future<void> refreshIndex() async {
    setBusyState(true);
    final tikuIndex = await AppService().getTikuIndex();
    _tikuIndexes = tikuIndex;

    final store = locator<TikuStore>();
    store.index.put(json.encode(_tikuIndexes));
    setBusyState(false);
  }

  Future<void> refreshUnit() async {
    setBusyState(true);
    if (_tikuIndexes == null) {
      Logger('TikuProvider')
          .info('tiku index is null, skip getting detailed data');
      return;
    }
    final store = await locator.getAsync<TikuStore>();
    for (var index in _tikuIndexes!) {
      for (var content in index.content!) {
        final unitData =
            await AppService().getUnitTi(index.id!, content!.data!);
        store.put(index.id!, content.data!, json.encode(unitData));
      }
    }
    setBusyState(false);
  }

  Future<void> refreshData() async {
    await refreshIndex();
    await refreshUnit();
  }
}
