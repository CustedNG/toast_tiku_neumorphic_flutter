// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ti.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TiAdapter extends TypeAdapter<Ti> {
  @override
  final int typeId = 2;

  @override
  Ti read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ti(
      options: (fields[1] as List?)?.cast<String>(),
      question: fields[2] as String?,
      answer: (fields[3] as List?)?.cast<dynamic>(),
      type: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Ti obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.options)
      ..writeByte(2)
      ..write(obj.question)
      ..writeByte(3)
      ..write(obj.answer)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
