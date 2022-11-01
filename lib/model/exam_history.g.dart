// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamHistoryAdapter extends TypeAdapter<ExamHistory> {
  @override
  final int typeId = 1;

  @override
  ExamHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamHistory(
      (fields[5] as List).cast<Ti>(),
      fields[6] as CheckState,
      fields[1] as String,
      fields[4] as double,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExamHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.subjectId)
      ..writeByte(4)
      ..write(obj.correctRate)
      ..writeByte(5)
      ..write(obj.tis)
      ..writeByte(6)
      ..write(obj.checkState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
