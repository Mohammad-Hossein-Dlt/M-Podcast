// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DocumentModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentModelAdapter extends TypeAdapter<DocumentModel> {
  @override
  final int typeId = 1;

  @override
  DocumentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentModel(
      name: fields[0] as String,
      creationDate: fields[2] as String,
    )
      ..mainImage = fields[1] as String
      ..category = (fields[3] as Map).cast<dynamic, dynamic>()
      ..audios = (fields[4] as List).cast<dynamic>()
      ..body = (fields[5] as List).cast<dynamic>()
      ..labels = (fields[6] as List).cast<dynamic>()
      ..isSubscription = fields[7] as bool
      ..deletedFiles = (fields[8] as List).cast<dynamic>();
  }

  @override
  void write(BinaryWriter writer, DocumentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mainImage)
      ..writeByte(2)
      ..write(obj.creationDate)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.audios)
      ..writeByte(5)
      ..write(obj.body)
      ..writeByte(6)
      ..write(obj.labels)
      ..writeByte(7)
      ..write(obj.isSubscription)
      ..writeByte(8)
      ..write(obj.deletedFiles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
