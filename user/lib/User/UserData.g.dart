// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      nameAndFamily: fields[0] as String,
      phone: fields[1] as String,
      password: fields[2] as String,
      token: fields[3] as String,
      email: fields[4] == null ? '' : fields[4] as String,
      haveSubscription: fields[5] as bool,
      subscription: fields[6] as double,
      remainingSubscription: fields[7] as double,
      haveSpecialSubscription: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.nameAndFamily)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.haveSubscription)
      ..writeByte(6)
      ..write(obj.subscription)
      ..writeByte(7)
      ..write(obj.remainingSubscription)
      ..writeByte(8)
      ..write(obj.haveSpecialSubscription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
