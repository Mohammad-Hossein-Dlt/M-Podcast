abstract class UserManagementEvent {}

class GetUserInfoEvent implements UserManagementEvent {
  String userName;
  GetUserInfoEvent({required this.userName});
}

class DeleteUserAcountEvent implements UserManagementEvent {
  String userName;
  DeleteUserAcountEvent({required this.userName});
}
