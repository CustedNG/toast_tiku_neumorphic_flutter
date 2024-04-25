import 'package:hive_flutter/hive_flutter.dart';
import 'package:toast_tiku/model/check_state.dart';
import 'package:toast_tiku/model/ti.dart';

part 'exam_history.g.dart';

@HiveType(typeId: 1)
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

  @HiveField(1)
  late String date;
  @HiveField(2)
  late String subject;
  @HiveField(3)
  late String subjectId;
  @HiveField(4)
  late double correctRate;
  @HiveField(5)
  late List<Ti> tis;
  @HiveField(6)
  late CheckState checkState;

  ExamHistory(
    this.tis,
    this.checkState,
    this.date,
    this.correctRate,
    this.subject,
    this.subjectId,
  );

  String get id => '$subjectId$date';

  ExamHistory.fromJson(Map<String, dynamic> json) {
    if (json['tis'] != null) {
      final tis = json['tis'];
      final arr0 = <Ti>[];
      for (var ti in tis) {
        arr0.add(Ti.fromJson(ti));
      }
      this.tis = arr0;
    }
    if (json['checkState'] != null) {
      checkState = CheckState.from(toMap(json['checkState']));
    } else {
      checkState = CheckState.empty();
    }

    date = json['date'].toString();
    subject = json['subject'].toString();
    subjectId = json['subjectId'].toString();
    correctRate = json['correctRate'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    final arrTis = [];
    for (var v in tis) {
      arrTis.add(v.toJson());
    }
    data['tis'] = arrTis;
    data['checkState'] = checkState.state;
    data['date'] = date;
    data['correctRate'] = correctRate;
    data['subject'] = subject;
    data['subjectId'] = subjectId;
    return data;
  }
}
