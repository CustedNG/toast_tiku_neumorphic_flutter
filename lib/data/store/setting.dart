import 'package:toast_tiku/core/persistant_store.dart';

class SettingStore extends PersistentStore {
  StoreProperty<bool> get receiveNotification => property('notify');
  StoreProperty<bool> get autoAddWrongTi2Favrorite =>
      property('autoAddWrongTi', defaultValue: true);
  StoreProperty<bool> get autoUpdateTiku =>
      property('autoUpdateTiku', defaultValue: true);
}
