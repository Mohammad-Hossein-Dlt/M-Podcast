import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/Bloc/ProfileBloc/profile_event.dart';
import 'package:user/Bloc/ProfileBloc/profile_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/Repository/user_data_repository.dart';
import 'package:user/User/user.dart';

class Profilebloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserDataRepository rep = locator.get();
  Profilebloc() : super(ProfileInitState(onWating: false)) {
    on<ProfileDataEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(ProfileDataState());
      } else {
        emit(NoLoginState());
      }
    });
    on<GetValidCodeEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(ProfileInitState(onWating: true));
        Map? validCodeData =
            await rep.signInValidCode(userData()!.phone, event.setTimer);
        if (validCodeData != null) {
          if (validCodeData["error"] == false) {
            emit(ProfileInitState(onWating: false));
            emit(ProfileValidCodeState(onWating: false));
          }
          if (validCodeData["error"] == true) {
            emit(ProfileInitState(onWating: false));
            Fluttertoast.showToast(
              msg: validCodeData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER_RIGHT,
              backgroundColor: red,
              textColor: Colors.white,
            );
          }
        } else {
          emit(ProfileInitState(onWating: false));
        }
      }
    });
    on<ChangeInfoEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(ProfileInitState(onWating: true));
        await rep.changeInfo(
            userData()!.token,
            userData()!.phone,
            userData()!.password,
            event.nameAndFamily,
            event.email,
            event.saveData);
        emit(ProfileInitState(onWating: false));
      } else {
        emit(NoLoginState());
      }
    });
    on<ChangePasswordEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(ProfileValidCodeState(onWating: true));

        await rep.changePassword(userData()!.token, userData()!.phone,
            event.password, event.newpassword, event.saveData);
        emit(ProfileValidCodeState(onWating: false));
      } else {
        emit(NoLoginState());
      }
    });
    on<GetChangeUserNameValidCodeEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(ProfileInitState(onWating: true));
        Map? validCodeData = await rep.changeUserNameValidCode(
            userData()!.phone, event.newUserName, event.setTimer);
        if (validCodeData != null) {
          if (validCodeData["error"] == false) {
            emit(ProfileInitState(onWating: false));
            emit(ProfileValidCodeState(onWating: false));
          }
          if (validCodeData["error"] == true) {
            emit(ProfileInitState(onWating: false));
            Fluttertoast.showToast(
              msg: validCodeData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER_RIGHT,
              backgroundColor: red,
              textColor: Colors.white,
            );
          }
        } else {
          emit(ProfileInitState(onWating: false));
        }
      }
    });
    on<ChangeUserNameEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(ProfileValidCodeState(onWating: true));

        await rep.changeUserName(userData()!.phone, event.newUserName,
            event.validCode, event.saveData);
        emit(ProfileValidCodeState(onWating: false));
      } else {
        emit(NoLoginState());
      }
    });
  }
}
