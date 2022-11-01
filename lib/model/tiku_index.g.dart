// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiku_index.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TikuIndexContentAdapter extends TypeAdapter<TikuIndexContent> {
  @override
  final int typeId = 3;

  @override
  TikuIndexContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TikuIndexContent(
      title: fields[1] as String?,
      radio: fields[2] as int?,
      multiple: fields[3] as int?,
      decide: fields[4] as int?,
      fill: fields[5] as int?,
      data: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TikuIndexContent obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.radio)
      ..writeByte(3)
      ..write(obj.multiple)
      ..writeByte(4)
      ..write(obj.decide)
      ..writeByte(5)
      ..write(obj.fill)
      ..writeByte(6)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TikuIndexContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TikuIndexAdapter extends TypeAdapter<TikuIndex> {
  @override
  final int typeId = 4;

  @override
  TikuIndex read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TikuIndex(
      id: fields[1] as String?,
      length: fields[2] as int?,
      content: (fields[3] as List?)?.cast<TikuIndexContent?>(),
      chinese: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TikuIndex obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.length)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.chinese);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TikuIndexAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TikuIndexRawAdapter extends TypeAdapter<TikuIndexRaw> {
  @override
  final int typeId = 5;

  @override
  TikuIndexRaw read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TikuIndexRaw(
      fields[1] as String,
      (fields[2] as List?)?.cast<TikuIndex>(),
    );
  }

  @override
  void write(BinaryWriter writer, TikuIndexRaw obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.tikuIndexes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TikuIndexRawAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
