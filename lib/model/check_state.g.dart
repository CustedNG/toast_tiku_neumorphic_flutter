// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckStateAdapter extends TypeAdapter<CheckState> {
  @override
  final int typeId = 6;

  @override
  CheckState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckState(
      (fields[1] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<Object>())),
    );
  }

  @override
  void write(BinaryWriter writer, CheckState obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
