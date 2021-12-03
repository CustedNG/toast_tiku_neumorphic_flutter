import 'package:toast_tiku/model/ti.dart';

class ExamHistory {
/*
{
  "tis": [
    {}
  ],
  "chechState": [
    [
      {}
    ]
  ]
} 
*/

  late String date;
  late double correctRate;
  late List<Ti> tis;
  late List<List<Object>> chechState;

  ExamHistory(
    this.tis,
    this.chechState,
    this.date,
    this.correctRate,
  );

  ExamHistory.fromJson(Map<String, dynamic> json) {
    if (json['tis'] != null) {
      final v = json['tis'];
      final arr0 = <Ti>[];
      v.forEach((v) {
        arr0.add(Ti.fromJson(v));
      });
      tis = arr0;
    }
    if (json['chechState'] != null) {
      final v = json['chechState'];
      final arr0 = <List<Object>>[];
      v.forEach((v) {
        final arr1 = <Object>[];
        v.forEach((vv) {
          arr1.add(vv);
        });
        arr0.add(arr1);
      });
      chechState = arr0;
    }
    date = json['date'].toString();
    correctRate = json['correctRate'].toDouble();
  }
}
