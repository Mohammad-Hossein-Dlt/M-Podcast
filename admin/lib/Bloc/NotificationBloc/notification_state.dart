import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class NotificationState {}

class NotificationInitState implements NotificationState {}

class NotificationLoadingState implements NotificationState {}

class NotificationEditState implements NotificationState {}

class NotificationDataState implements NotificationState {
  Either<String, NotificationDataModel> data;
  NotificationDataState({required this.data});
}

class InitUploadNotificationDataState implements NotificationState {}

class UploadNotificationDataState implements NotificationState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  UploadNotificationDataState(
      {required this.uploadProgress, required this.error});
}
