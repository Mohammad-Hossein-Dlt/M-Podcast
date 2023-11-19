abstract class LoginEvent {}

class SinInValidCodeEvent implements LoginEvent {
  String userName;
  Function() function;

  SinInValidCodeEvent({
    required this.userName,
    required this.function,
  });
}

class SinInEvent implements LoginEvent {
  String userName;
  String validCode;
  Function() saveData;
  SinInEvent({
    required this.userName,
    required this.validCode,
    required this.saveData,
  });
}

class SinUpValidCodeEvent implements LoginEvent {
  String userName;
  Function() function;

  SinUpValidCodeEvent({
    required this.userName,
    required this.function,
  });
}

class SinUpEvent implements LoginEvent {
  String nameAndFamily;
  String userName;
  String password;
  Function() saveData;
  SinUpEvent({
    required this.nameAndFamily,
    required this.userName,
    required this.password,
    required this.saveData,
  });
}
