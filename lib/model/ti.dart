import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'ti.g.dart';

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
@HiveType(typeId: 2)
class Ti {
/*
{
  "options": [
    "粟裕"
  ],
  "question": "下面哪一位是共和国十大将军之一(　　)",
  "answer": 0,
  "type": 0
} 
*/

  /// 题目的选项
  @HiveField(1)
  List<String>? options;

  /// 题目的问题
  @HiveField(2)
  String? question;

  /// 题目的答案
  @HiveField(3)
  List<dynamic>? answer;

  /// 题目的类型
  @HiveField(4)
  int? type;

  Ti({
    this.options,
    this.question,
    this.answer,
    this.type,
  });
  Ti.fromJson(Map<String, dynamic> json) {
    if (json["options"] != null) {
      final v = json["options"];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      options = arr0;
    }
    question = json["question"]?.toString();
    if (json["answer"] is int) {
      answer = [json["answer"]];
    } else {
      answer = json["answer"];
    }

    type = json["type"]?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (options != null) {
      final v = options;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v);
      }
      data["options"] = arr0;
    }
    data["question"] = question;
    data["answer"] = answer;
    data["type"] = type;
    return data;
  }

  String get id => md5.convert(utf8.encode(question ?? '')).toString();
}

/// 将List转为List<Ti>
List<Ti>? getTiList(dynamic data) {
  if (data == null) return null;
  List<Ti> tis = [];
  for (var ti in data) {
    tis.add(Ti.fromJson(ti));
  }
  return tis;
}
