import 'package:toast_tiku/res/url.dart';

import '../../core/persistant_store.dart';

class SettingStore extends PersistentStore {
  /// 是否启用通知
  StoreProperty<bool> get receiveNotification =>
      property('notify', defaultValue: true);

  /// App强调色
  StoreProperty<int> get appPrimaryColor =>
      property('appPrimaryColor', defaultValue: 4281352095);

  /// 选下选项后，是否自动显示答案
  StoreProperty<bool> get autoDisplayAnswer =>
      property('autoDisplayAnswer', defaultValue: true);

  /// 单元模式下，是否以前选择的选项（答案）
  StoreProperty<bool> get saveAnswer =>
      property('saveAnswer', defaultValue: true);

  /// 单元模式下，选择正确时，自动跳转下一题
  StoreProperty<bool> get autoSlide2NextWhenCorrect =>
      property('autoSlide2NextWhenCorrect', defaultValue: true);

  /// 背题模式：在单元测试里，直接显示答案
  StoreProperty<bool> get directlyShowAnswer =>
      property('directlyShowAnswer', defaultValue: false);

  /// 多选全部选项选出后，才显示答案
  StoreProperty<bool> get showAnswerWhenAllSelected =>
      property('showAnswerWhenAllSelected', defaultValue: false);

  /// 内部储存数据的格式的版本
  StoreProperty<int> get storeVersion =>
      property('storeVersion', defaultValue: 0);

  StoreProperty<String> get backendUrl =>
      property('backendUrl', defaultValue: defaultBackendUrl);
}
