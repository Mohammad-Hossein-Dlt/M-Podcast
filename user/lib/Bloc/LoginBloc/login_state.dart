abstract class LoginState {}

class EnterLoginDataState implements LoginState {
  bool onWating = false;
  EnterLoginDataState({required this.onWating});
}

class ValidCodeState implements LoginState {
  String validCode = "";
  bool onWating = false;
  bool error = false;
  ValidCodeState({
    required this.onWating,
    this.validCode = "",
    this.error = false,
  });
}
