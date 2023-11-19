import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/Bloc/LoginBloc/login_event.dart';
import 'package:user/Bloc/LoginBloc/login_state.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/Repository/user_data_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IUserDataRepository rep = locator.get();
  LoginBloc() : super(EnterLoginDataState(onWating: false)) {
    on<SinInValidCodeEvent>((event, emit) async {
      emit(EnterLoginDataState(onWating: true));
      // await rep.sinIn(event.userName, event.password, event.saveData);
      Map? validCodeData =
          await rep.signInValidCode(event.userName, event.function);
      if (validCodeData != null) {
        if (validCodeData["error"] == false) {
          emit(EnterLoginDataState(onWating: false));
          emit(ValidCodeState(onWating: false));
        }
        if (validCodeData["error"] == true) {
          emit(EnterLoginDataState(onWating: false));
          Fluttertoast.showToast(
            msg: validCodeData["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: red,
            textColor: Colors.white,
          );
        }
      } else {
        emit(EnterLoginDataState(onWating: false));
      }
    });
    on<SinInEvent>((event, emit) async {
      emit(ValidCodeState(onWating: true));
      Map? result =
          await rep.signIn(event.userName, event.validCode, event.saveData);
      if (result != null) {
        if (result["error"]) {
          emit(ValidCodeState(onWating: false, error: result["error"]));
        }
      }
    });

    on<SinUpValidCodeEvent>((event, emit) async {
      emit(EnterLoginDataState(onWating: true));
      Map? validCodeData =
          await rep.signUpValidCode(event.userName, event.function);
      if (validCodeData != null) {
        if (validCodeData["error"] == false) {
          emit(EnterLoginDataState(onWating: false));
          emit(ValidCodeState(
              validCode: validCodeData["validCode"].toString(),
              onWating: false));
        }
        if (validCodeData["error"] == true) {
          emit(EnterLoginDataState(onWating: false));
          Fluttertoast.showToast(
            msg: validCodeData["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: red,
            textColor: Colors.white,
          );
        }
      } else {
        emit(EnterLoginDataState(onWating: false));
      }
    });
    on<SinUpEvent>((event, emit) async {
      emit(ValidCodeState(onWating: true));
      Map? result = await rep.signUp(
          event.nameAndFamily, event.userName, event.password, event.saveData);
      print(
          "                   erg                                                  rbrtb                               rbrebreb");
      print(result);
      if (result != null) {
        if (result["error"]) {
          emit(ValidCodeState(onWating: false, error: result["error"]));
        }
      }
    });
  }
}
