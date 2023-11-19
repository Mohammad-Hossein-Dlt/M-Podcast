import 'package:admin/Bloc/SendMessageBloc/sendmessage_event.dart';
import 'package:admin/Bloc/SendMessageBloc/sendmessage_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  IUploadDataRepository uploadRep = locator.get();
  ValueNotifier sendProgress = ValueNotifier(false);
  ValueNotifier error = ValueNotifier(false);
  SendMessageBloc() : super(SendMessageInitState()) {
    on<SendMessageDataEvent>((event, emit) async {
      sendProgress = ValueNotifier(false);
      error = ValueNotifier(false);
      emit(SentMessageState(sendProgress: sendProgress, error: error));
      await uploadRep.sendMessage(event.messageText, sendProgress, error);
    });
    on<MessageEditEvent>((event, emit) async {
      emit(MessageEditState());
    });
  }
}
