abstract class SubGroupsEvent {}

class GetSubGroupsData implements SubGroupsEvent {
  String mainGroupId;
  GetSubGroupsData({required this.mainGroupId});
}
