import 'package:toast_tiku/core/persistant_store.dart';

class SettingStore extends PersistentStore {
  StoreProperty<bool> get receiveNotification =>
      property('notify', defaultValue: true);
  StoreProperty<bool> get autoUpdateTiku =>
      property('autoUpdateTiku', defaultValue: true);
  StoreProperty<bool> get blackBackground =>
      property('blackBackground', defaultValue: false);

  /// 第一次使用时的提醒，例如做题界面左右滑动切换题目
  StoreProperty<bool> get firstNotify =>
      property('firstNotify', defaultValue: false);
}
