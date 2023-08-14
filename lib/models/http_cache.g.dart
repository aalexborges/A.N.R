// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HttpCacheAdapter extends TypeAdapter<HttpCache> {
  @override
  final int typeId = 1;

  @override
  HttpCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HttpCache(
      id: fields[0] as String,
      url: fields[1] as String,
      body: fields[2] as String,
      method: fields[3] as String,
      statusCode: fields[4] as int,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HttpCache obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.method)
      ..writeByte(4)
      ..write(obj.statusCode)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HttpCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
