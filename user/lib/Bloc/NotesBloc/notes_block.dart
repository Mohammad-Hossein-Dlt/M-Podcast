import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Bloc/NotesBloc/notes_event.dart';
import 'package:user/Bloc/NotesBloc/notes_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/MainScreen/main_screen.dart';
import 'package:user/Repository/user_data_repository.dart';
import 'package:user/User/user.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final IUserDataRepository rep = locator.get();
  NotesBloc() : super(NotesInitState()) {
    on<GetNotesEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(NotesLoadingState());
        emit(NotesDataState(
            notes: await rep.getNotes(
                userData()!.token, event.offset, event.order)));
      } else {
        emit(NoLoginState());
      }
    });
    on<LoadMoreNotesEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(NotesDataState(
            notes: await rep.getNotes(
                userData()!.token, event.offset, event.order)));
      } else {
        emit(NoLoginState());
      }
    });
    on<RemoveNoteEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(NotesLoadingState());

        var isBookmarked = await rep.noting(
            token: userData()!.token,
            itemId: event.itemId,
            documentId: event.documentId);
        isBookmarked.fold((l) {
          emit(RemoveErrorState());
        }, (r) {
          if (r) {
            Fluttertoast.showToast(
              msg: "این متن به یادداشت ها اظافه شد.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER_RIGHT,
              backgroundColor: blue,
              textColor: Colors.white,
            );
          } else {
            Fluttertoast.showToast(
              msg: "این متن از یادداشت ها حذف شد.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER_RIGHT,
              backgroundColor: blue,
              textColor: Colors.white,
            );
          }
          BlocProvider.of<MainScreenBloc>(mainScreenContext.get())
              .add(MainScreenDefaultEvent());
        });
      }
    });
  }
}
