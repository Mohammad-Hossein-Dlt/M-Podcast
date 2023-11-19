import 'package:user/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:user/Bloc/MainScreenBloc/main_screen_state.dart';
import 'package:user/Dio/base_dio.dart';
import 'package:user/PageManager/pagemanager.dart';
import 'package:user/Repository/get_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Repository/user_data_repository.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final IGetDataRepository rep = locator.get();
  final IUserDataRepository userRep = locator.get();
  PageManager audio = PageManager(fileName: null, documentName: null);
  String priviusAudio = "";
  MainScreenBloc() : super(MainScreenInitState()) {
    on<GetMainScreenDataEvent>((event, emit) async {
      emit(MainScreenSplashState());
      await Future.delayed(
        const Duration(seconds: 2),
        () async {
          var metaData = await rep.metaData();
          metaData.fold((l) {
            emit(MainScreenErrorSplashState());
          }, (r) {
            emit(MainScreentMainState(uniqueKey: UniqueKey()));
            if (r.enable) {
              event.notification(message: r.message);
            }
          });
        },
      );
    });

    on<MainScreenDefaultEvent>((event, emit) async {
      if (await audio.playing() == false) {
        await audio.dispose();
        audio = PageManager(fileName: null, documentName: null);
      }
      emit(MainScreentMainState(uniqueKey: UniqueKey()));
    });
    on<MainScreenSetAudioEvent>((event, emit) async {
      audio.stop();
      audio = PageManager(fileName: null, documentName: null);

      audio = event.curentAudio;
      priviusAudio = event.name;
      emit(MainScreenAudioState(
        name: event.name,
        mainImage: event.mainImage,
        curentAudio: event.curentAudio,
      ));
    });
    on<MainScreenDisposeAudioEvent>((event, emit) async {
      if (event.name == priviusAudio) {
        emit(MainScreentMainState(uniqueKey: UniqueKey()));

        await audio.dispose();
        audio = PageManager(fileName: null, documentName: null);
      }
    });
  }
}
