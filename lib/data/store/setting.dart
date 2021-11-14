import 'package:flutter/material.dart';
import 'package:toast_tiku/core/persistant_store.dart';

class SettingStore extends PersistentStore {
  /// 是否启用通知
  StoreProperty<bool> get receiveNotification =>
      property('notify', defaultValue: true);

  /// 是否自动更新题库数据
  StoreProperty<bool> get autoUpdateTiku =>
      property('autoUpdateTiku', defaultValue: true);

  /// 第一次使用时的提醒，例如做题界面左右滑动切换题目
  StoreProperty<bool> get firstNotify =>
      property('firstNotify', defaultValue: false);

  /// App强调色
  StoreProperty<int> get appPrimaryColor =>
      property('appPrimaryColor', defaultValue: Colors.blueAccent.value);

  /// 选下选项后，是否自动显示答案
  StoreProperty<bool> get autoDisplayAnswer =>
      property('autoDisplayAnswer', defaultValue: true);
}
