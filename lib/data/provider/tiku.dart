import 'dart:async';

import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/tiku_index.dart';

class UserProvider extends BusyProvider {
  final _initialized = Completer();
  Future get initialized => _initialized.future;

  List<TikuIndex>? _tikuIndexes;
  List<TikuIndex>? get tikuIndex => _tikuIndexes;

  Future<void> loadLocalData() async {
    final store = locator<TikuStore>();
    _tikuIndexes = getTikuIndexList(store.index.fetch());
  }
}
