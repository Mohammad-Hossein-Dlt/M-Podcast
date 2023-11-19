import 'package:hive_flutter/hive_flutter.dart';
import 'package:user/User/UserData.dart';

String _boxName = "UserData";
Box<UserData> _userBox = Hive.box<UserData>("User");

UserData? userData() => _userBox.get(_boxName);
void userLogin(UserData userData) {
  _userBox.put(_boxName, userData);
}

void userLogout() {
  _userBox.delete(_boxName);
}

bool isUserLogin() {
  if (userData() != null) {
    if (_userBox.containsKey(_boxName)) {
      if (userData()!.phone.isNotEmpty &&
          double.tryParse(userData()!.phone) != null &&
          userData()!.phone.length == 11) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}
