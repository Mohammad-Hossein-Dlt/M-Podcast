import 'package:hive/hive.dart';
part 'UserData.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  UserData({
    required this.nameAndFamily,
    required this.phone,
    required this.password,
    required this.token,
    required this.email,
    required this.haveSubscription,
    required this.subscription,
    required this.remainingSubscription,
    required this.haveSpecialSubscription,
  });
  @HiveField(0)
  String nameAndFamily;
  @HiveField(1)
  String phone;
  @HiveField(2)
  String password;
  @HiveField(3)
  String token;
  @HiveField(4, defaultValue: "")
  String email = "";
  @HiveField(5)
  bool haveSubscription;
  @HiveField(6)
  double subscription;
  @HiveField(7)
  double remainingSubscription;
  @HiveField(8)
  bool haveSpecialSubscription;
}
