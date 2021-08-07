import 'package:toast_tiku/model/ti.dart';

extension TiX on Ti {
  String get typeChinese {
    switch (type) {
      case 0:
        return '单选';
      case 1:
        return '多选';
      case 2:
        return '填空';
      case 3:
        return '判断';
      default:
        return '未知类型';
    }
  }
}
