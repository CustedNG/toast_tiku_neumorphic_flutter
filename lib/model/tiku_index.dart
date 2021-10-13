import 'dart:convert';

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class TikuIndexContent {
/*
{
  "title": "第一章 毛泽东思想及其历史地位",
  "radio": 30,
  "multiple": 18,
  "decide": 12,
  "fill": 0,
  "data": "1.json"
} 
*/

  /// 章节标题
  String? title;

  /// 单选题的数量
  int? radio;

  /// 多选题的数量
  int? multiple;

  /// 判断题的数量
  int? decide;

  /// 填空题的数量
  int? fill;

  /// 该章节数据的文件名
  String? data;

  TikuIndexContent({
    this.title,
    this.radio,
    this.multiple,
    this.decide,
    this.fill,
    this.data,
  });
  TikuIndexContent.fromJson(Map<String, dynamic> json) {
    title = json["title"]?.toString();
    radio = json["radio"]?.toInt();
    multiple = json["multiple"]?.toInt();
    decide = json["decide"]?.toInt();
    fill = json["fill"]?.toInt();
    data = json["data"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["radio"] = radio;
    data["multiple"] = multiple;
    data["decide"] = decide;
    data["fill"] = fill;
    data["data"] = this.data;
    return data;
  }
}

class TikuIndex {
/*
{
  "id": "maogai",
  "length": 18,
  "content": [
    {
      "title": "第一章 毛泽东思想及其历史地位",
      "radio": 30,
      "multiple": 18,
      "decide": 12,
      "fill": 0,
      "data": "1.json"
    }
  ],
  "chinese": "毛概"
} 
*/

  /// 科目id
  String? id;

  /// 科目章节数
  int? length;

  /// 科目章节数据
  List<TikuIndexContent?>? content;

  /// 科目的中文名
  String? chinese;

  TikuIndex({
    this.id,
    this.length,
    this.content,
    this.chinese,
  });
  TikuIndex.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    length = json["length"]?.toInt();
    if (json["content"] != null) {
      final v = json["content"];
      final arr0 = <TikuIndexContent>[];
      v.forEach((v) {
        arr0.add(TikuIndexContent.fromJson(v));
      });
      content = arr0;
    }
    chinese = json["chinese"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["length"] = length;
    if (content != null) {
      final v = content;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data["content"] = arr0;
    }
    data["chinese"] = chinese;
    return data;
  }
}

/// 从String或者List转为List<TikuIndex>?
List<TikuIndex>? getTikuIndexList(dynamic data) {
  if (data == null) return null;
  List<TikuIndex> ts = [];
  if (data is String) {
    data = json.decode(data);
    for (var t in data) {
      ts.add(TikuIndex.fromJson(t));
    }
  } else {
    for (var t in data['content']) {
      ts.add(TikuIndex.fromJson(t));
    }
  }

  return ts;
}

/// 从网络获取到的题库原始数据
class TikuIndexRaw {
  String version;
  List<TikuIndex>? tikuIndexes;

  TikuIndexRaw(this.version, this.tikuIndexes);
}
