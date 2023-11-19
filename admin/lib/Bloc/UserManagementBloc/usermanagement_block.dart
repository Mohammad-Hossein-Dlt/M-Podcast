import 'package:admin/Bloc/UserManagementBloc/usermanagement_event.dart';
import 'package:admin/Bloc/UserManagementBloc/usermanagement_state.dart';
import 'package:admin/Constants/colors.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/delete_repository.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  final IGetDataRepository rep = locator.get();
  IDeleteDataRepository deleteRep = locator.get();
  ValueNotifier progress = ValueNotifier(false);
  ValueNotifier error = ValueNotifier(false);
  UserManagementBloc() : super(UserManagementInitState()) {
    on<GetUserInfoEvent>((event, emit) async {
      emit(UserManagementLoadingState());
      var data = await rep.userInfo(userName: event.userName);
      emit(UserInfoDataState(data: data, state: UserManagementS.default_));
    });

    on<DeleteUserAcountEvent>((event, emit) async {
      emit(UserInfoDefaultState(
        state: UserManagementS.deleteUser,
        onReload: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: SpinKitThreeBounce(
                color: green,
                duration: const Duration(milliseconds: 800),
                size: 16,
                // strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "درحال حذف این حساب کاربری",
              style: TextStyle(color: black),
            ),
          ],
        ),
      ));
      var data = await deleteRep.userDeleteAcount(userName: event.userName);
      data.fold((l) {}, (r) {
        emit(UserInfoDefaultState(
          state: UserManagementS.default_,
          onReload: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: green,
              ),
              const SizedBox(width: 4),
              Text(
                "این حساب با موفقیت حذف شد",
                style: TextStyle(color: black),
              ),
            ],
          ),
        ));
      });
    });
  }
}
