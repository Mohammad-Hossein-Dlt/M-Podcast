import 'package:admin/Bloc/NotificationBloc/notification_event.dart';
import 'package:admin/Bloc/NotificationBloc/notification_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  IUploadDataRepository uploadRep = locator.get();
  IGetDataRepository getRep = locator.get();
  ValueNotifier uploadProgress = ValueNotifier(false);
  ValueNotifier error = ValueNotifier(false);
  NotificationBloc() : super(NotificationInitState()) {
    on<GetNotificationData>((event, emit) async {
      emit(NotificationLoadingState());
      var data = await getRep.getNotification();
      emit(NotificationDataState(data: data));
    });

    on<UploadNotificationEvent>((event, emit) async {
      uploadProgress = ValueNotifier(false);
      error = ValueNotifier(false);
      emit(UploadNotificationDataState(
          uploadProgress: uploadProgress, error: error));
      await uploadRep.uploadNotification(
          event.notificationData, uploadProgress, error);
    });

    on<InitUploadNotificationEvent>((event, emit) async {
      emit(InitUploadNotificationDataState());
    });
    on<NotificationEditEvent>((event, emit) async {
      emit(NotificationEditState());
    });
  }
}
