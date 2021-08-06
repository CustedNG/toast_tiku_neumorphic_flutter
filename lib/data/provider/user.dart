import 'dart:async';

import 'package:toast_tiku/core/provider_base.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/user.dart';
import 'package:toast_tiku/locator.dart';

class UserProvider extends BusyProvider {
  final _initialized = Completer();
  Future get initialized => _initialized.future;

  bool? _loggedIn = false;
  bool? get loggedIn => _loggedIn;
  String? _un = '';
  String? get un => _un;
  String? _pwd = '';
  String? get pwd => _pwd;
  String? _cookie = '';
  String? get cookie => _cookie;

  Future<void> loadLocalData() async {
    final store = locator<UserStore>();
    _loggedIn = store.loggedIn.fetch();
    _un = store.username.fetch();
    _pwd = store.password.fetch();
    _cookie = store.cookie.fetch();
  }

  Future<void> login(un, pwd, cookies) async {
    _un = un;
    _pwd = pwd;
    _cookie = cookies;
    final userStore = locator<UserStore>();
    userStore.username.put(un);
    userStore.password.put(pwd);
    userStore.cookie.put(cookies);
    userStore.loggedIn.put(true);
    await busyRun(() async {
      await _setLoginState(true);
    });
  }

  Future<void> logout() async {
    unawaited(_setLoginState(false));
    notifyListeners();
  }

  Future<void> _setLoginState(bool state) async {
    _loggedIn = state;
    final userData = await locator.getAsync<UserStore>();
    unawaited(userData.loggedIn.put(state));
  }
}
