// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingsData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsDataAdapter extends TypeAdapter<SettingsData> {
  @override
  final int typeId = 1;

  @override
  SettingsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsData(
      autoDownload: fields[0] as bool,
      autoPlyaNextAudio: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.autoDownload)
      ..writeByte(1)
      ..write(obj.autoPlyaNextAudio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
