import 'package:toast_tiku/model/ti.dart';

extension TiX on Ti {
  ///  返回题目类型的中文名
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

  /// 返回题目的答案String
  String get answerStr {
    const answerConst = '\n答案：';
    switch (type) {
      case 3:
        if (options == null) {
          return '$answerConst${answer![0] == 0 ? "对" : "错"}';
        }
        return '$answerConst${options![answer![0]]}';
      case 2:
        return '$answerConst${answer!.join(",")}';
      case 0:
      case 1:
        final answers = <String>[];
        for (var item in answer!) {
          if (item is int) {
            answers.add(String.fromCharCode(65 + item));
          }
        }
        return answerConst + answers.join(',');
      default:
        return '无法解析答案';
    }
  }
}
