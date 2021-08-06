import 'package:toast_tiku/core/persistant_store.dart';

class UserStore extends PersistentStore {
  StoreProperty<String> get username => property('username');
  StoreProperty<String> get password => property('password');
  StoreProperty<String> get cookie => property('cookie');
  StoreProperty<bool> get loggedIn => property('loggedIn', defaultValue: false);
  StoreProperty<List<String>> get favorite =>
      property('favorite', defaultValue: <String>[]);
}
