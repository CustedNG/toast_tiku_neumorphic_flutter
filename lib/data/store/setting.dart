import 'package:toast_tiku/core/persistant_store.dart';

class SettingStore extends PersistentStore {
  StoreProperty<String> get receiveNotification => property('notify');
}
