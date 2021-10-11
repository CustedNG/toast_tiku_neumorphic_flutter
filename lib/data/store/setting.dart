import 'package:toast_tiku/core/persistant_store.dart';

class SettingStore extends PersistentStore {
  StoreProperty<bool> get receiveNotification =>
      property('notify', defaultValue: true);
  StoreProperty<bool> get autoUpdateTiku =>
      property('autoUpdateTiku', defaultValue: true);
  StoreProperty<bool> get blackBackground =>
      property('blackBackground', defaultValue: false);
}
