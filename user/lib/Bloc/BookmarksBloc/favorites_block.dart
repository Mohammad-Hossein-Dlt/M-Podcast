import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/Bloc/BookmarksBloc/favorites_event.dart';
import 'package:user/Bloc/BookmarksBloc/favorites_state.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/GeneralWidgets/no_login.dart';
import 'package:user/MainScreen/main_screen.dart';
import 'package:user/Repository/user_data_repository.dart';
import 'package:user/User/user.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final IUserDataRepository rep = locator.get();
  FavoritesBloc() : super(FavoritesInitState()) {
    on<GetFavoritesEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(FavoritesLoadingState());
        emit(FavoritesDataState(
            bookmarksList: await rep.getFavorites(
                userData()!.token, event.offset, event.order)));
      } else {
        emit(NoLoginState());
      }
    });
    on<LoadMoreFavoritesEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(FavoritesDataState(
            bookmarksList: await rep.getFavorites(
                userData()!.token, event.offset, event.order)));
      } else {
        emit(NoLoginState());
      }
    });
    on<RemoveFromFavoritesEvent>((event, emit) async {
      if (isUserLogin()) {
        var isAddedToFavorites = await rep.addDocumentToFavorites(
            token: userData()!.token, documentId: event.id);
        isAddedToFavorites.fold((l) {
          Fluttertoast.showToast(
            msg: "خطایی رخ داد!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: red,
            textColor: white,
          );
          emit(FavoritesErrorState());
        }, (r) async {
          if (r) {
            Fluttertoast.showToast(
              msg: "این ملب به علاقه مندیهای تان اظافه شد.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER_RIGHT,
              backgroundColor: blue,
              textColor: Colors.white,
            );
          } else {
            Fluttertoast.showToast(
              msg: "این مطلب از علاقه مندیهای تان حذف شد.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER_RIGHT,
              backgroundColor: blue,
              textColor: Colors.white,
            );
          }
          BlocProvider.of<MainScreenBloc>(mainScreenContext.get())
              .add(MainScreenDefaultEvent());
        });
      } else {
        showModalBottomSheet(
            // isScrollControlled: true,
            context: event.ctx,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: NoLogin(),
                  ),
                ],
              );
            });
      }
    });
  }
}
