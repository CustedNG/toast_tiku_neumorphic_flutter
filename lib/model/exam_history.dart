import 'package:toast_tiku/model/check_state.dart';
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
  late String subject;
  late String subjectId;
  late double correctRate;
  late List<Ti> tis;
  late CheckState checkState;

  ExamHistory(this.tis, this.checkState, this.date, this.correctRate,
      this.subject, this.subjectId);

  ExamHistory.fromJson(Map<String, dynamic> json) {
    if (json['tis'] != null) {
      final _tis = json['tis'];
      final arr0 = <Ti>[];
      for (var _ti in _tis) {
        arr0.add(Ti.fromJson(_ti));
      }
      tis = arr0;
    }
    if (json['checkState'] != null) {
      checkState = CheckState.from(toMap(json['checkState'])!);
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
