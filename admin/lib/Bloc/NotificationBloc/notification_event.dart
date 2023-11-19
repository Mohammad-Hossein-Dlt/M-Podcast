import 'package:admin/DataModel/data_model.dart';

abstract class NotificationEvent {}

class GetNotificationData implements NotificationEvent {}

class NotificationEditEvent implements NotificationEvent {}

class InitUploadNotificationEvent implements NotificationEvent {}

class UploadNotificationEvent implements NotificationEvent {
  NotificationDataModel notificationData;
  UploadNotificationEvent({required this.notificationData});
}
