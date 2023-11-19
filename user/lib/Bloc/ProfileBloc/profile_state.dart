abstract class ProfileState {}

class ProfileInitState implements ProfileState {
  bool onWating = false;
  ProfileInitState({required this.onWating});
}

class ProfileValidCodeState implements ProfileState {
  String validCode = "";
  bool onWating = false;
  bool error = false;
  ProfileValidCodeState({
    required this.onWating,
    this.validCode = "",
    this.error = false,
  });
}

class ProfileDataState implements ProfileState {}

class NoLoginState implements ProfileState {}
