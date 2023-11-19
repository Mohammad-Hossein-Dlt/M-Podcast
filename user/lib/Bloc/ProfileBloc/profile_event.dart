abstract class ProfileEvent {}

class ProfileDataEvent implements ProfileEvent {}

class GetValidCodeEvent implements ProfileEvent {
  Function() setTimer;
  GetValidCodeEvent({
    required this.setTimer,
  });
}

class ChangeInfoEvent implements ProfileEvent {
  String nameAndFamily;
  String email;
  Function() saveData;
  ChangeInfoEvent({
    required this.nameAndFamily,
    required this.email,
    required this.saveData,
  });
}

class ChangePasswordEvent implements ProfileEvent {
  String password;
  String newpassword;
  Function() saveData;
  ChangePasswordEvent({
    required this.password,
    required this.newpassword,
    required this.saveData,
  });
}

class GetChangeUserNameValidCodeEvent implements ProfileEvent {
  String newUserName;
  Function() setTimer;
  GetChangeUserNameValidCodeEvent({
    required this.newUserName,
    required this.setTimer,
  });
}

class ChangeUserNameEvent implements ProfileEvent {
  String newUserName;
  String validCode;
  Function() saveData;
  ChangeUserNameEvent({
    required this.newUserName,
    required this.validCode,
    required this.saveData,
  });
}
