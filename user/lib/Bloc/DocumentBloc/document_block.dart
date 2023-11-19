import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:user/Bloc/DocumentBloc/document_event.dart';
import 'package:user/Bloc/DocumentBloc/document_state.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_block.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/DataModel/data_model.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/GeneralWidgets/no_login.dart';
import 'package:user/MainScreen/main_screen.dart';
import 'package:user/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/User/user.dart';

import '../../Repository/user_data_repository.dart';

class DocumentOnlineBloc
    extends Bloc<DocumentOnlineEvent, DocumentOnlineState> {
  IGetDataRepository getRep = locator.get();
  IUserDataRepository userrep = locator.get();
  DocumentDataModel document = DocumentDataModel(
    name: "",
    mainimage: "",
    body: [],
    isSubscription: false,
    labels: [],
    group: "",
    subGroup: "",
    groupId: "",
    subGroupId: "",
    creationDate: {},
    likes: "0",
    id: 0,
    permission: false,
    isLiked: false,
    isBookmarked: false,
    audioList: [],
    recommended: [],
  );
  DocumentOnlineBloc() : super(DocumentInitState()) {
    on<GetOrdinaryDocumentEvent>((event, emit) async {
      emit(DocumentLoadingState());
      var data = await getRep.getDocument(id: event.id);
      data.fold((l) => null, (r) {
        document = r;
      });
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(DocumentDataState(data: data));
        },
      );
    });

    on<LikeDocumentEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(DocumentOnRefreshState(
          onRefresh: OnRefresh.like,
        ));
        var isLiked = await userrep.likeDocument(
            token: userData()!.token, documentId: event.id);
        isLiked.fold((l) {
          Fluttertoast.showToast(
            msg: "خطایی رخ داد!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }, (r) async {
          document.isLiked = r!["liked"] ?? false;
          document.likes = r["likes"] ?? 0;
          emit(DocumentRefreshState(
            document: document,
          ));
          BlocProvider.of<MainScreenBloc>(mainScreenContext.get())
              .add(MainScreenDefaultEvent());
        });
      } else {
        Get.bottomSheet(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: NoLogin(reload: () {
                  BlocProvider.of<DocumentOnlineBloc>(event.ctx)
                      .add(GetOrdinaryDocumentEvent(id: event.id));
                  Get.back();
                }),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        );
      }
    });
    on<AddDocumentToFavoritesEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(DocumentOnRefreshState(
          onRefresh: OnRefresh.addToFavorites,
        ));
        var isAddedToFavorites = await userrep.addDocumentToFavorites(
            token: userData()!.token, documentId: event.id);
        isAddedToFavorites.fold((l) {
          Fluttertoast.showToast(
            msg: "خطایی رخ داد!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }, (r) async {
          document.isBookmarked = r;
          emit(DocumentRefreshState(
            document: document,
          ));
          BlocProvider.of<MainScreenBloc>(mainScreenContext.get())
              .add(MainScreenDefaultEvent());
        });
      } else {
        Get.bottomSheet(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: NoLogin(reload: () {
                  BlocProvider.of<DocumentOnlineBloc>(event.ctx)
                      .add(GetOrdinaryDocumentEvent(id: event.id));
                  Get.back();
                }),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        );
      }
    });

    on<NoteEvent>((event, emit) async {
      if (isUserLogin()) {
        emit(DocumentOnRefreshState(
          onRefresh: OnRefresh.noting,
        ));
        var isNoted = await userrep.noting(
            token: userData()!.token,
            itemId: event.itemId,
            documentId: event.id);
        var data = await getRep.getDocument(id: event.id);

        isNoted.fold((l) {
          Fluttertoast.showToast(
            msg: "خطایی رخ داد!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }, (liked) async {
          if (liked) {
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
        data.fold((l) async {
          emit(DocumentErrorState());
        }, (r) async {
          document = r;
          emit(DocumentRefreshState(
            document: document,
          ));
        });
      } else {
        Get.bottomSheet(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: NoLogin(reload: () {
                  BlocProvider.of<DocumentOnlineBloc>(event.ctx)
                      .add(GetOrdinaryDocumentEvent(id: event.id));
                  Get.back();
                }),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        );
      }
    });
  }
}
