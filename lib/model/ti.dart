///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
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

  List<String?>? options;
  String? question;
  List<dynamic>? answer;
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
}

List<Ti>? getTiList(dynamic data) {
  if (data == null) return null;
  List<Ti> tis = [];
  for (var ti in data) {
    tis.add(Ti.fromJson(ti));
  }
  return tis;
}
