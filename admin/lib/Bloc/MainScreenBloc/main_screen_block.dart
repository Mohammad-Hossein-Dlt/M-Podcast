import 'package:admin/Bloc/MainScreenBloc/main_screen_event.dart';
import 'package:admin/Bloc/MainScreenBloc/main_screen_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/PageManager/pagemanager.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final IGetDataRepository rep = locator.get();
  PageManager audio = PageManager(audioPath: null, source: AudioSource.url);
  String priviusAudio = "";
  MainScreenBloc() : super(MainScreenInitState()) {
    on<GetMainScreenDataEvent>((event, emit) async {
      var data = await rep.getNotification();
      data.fold((l) {}, (r) {
        if (r.enable) {
          showDialog(
            barrierDismissible: false,
            context: event.ctx,
            builder: (context) => AlertDialog(
              // alignment: Alignment.bottomCenter,
              backgroundColor: const Color(0xffF0F0F2),
              elevation: 2,
              content: Text(
                r.message,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff4BCB81),
                          ),
                          onPressed: () {
                            Navigator.of(event.ctx).pop();
                          },
                          child: const Text("بعدا")),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4BCB81),
                          ),
                          onPressed: () {
                            Navigator.of(event.ctx).pop();
                          },
                          child: const Text("باشه")),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      });
    });

    on<MainScreenDefaultEvent>((event, emit) {
      emit(MainScreenDefaultState());
    });
    // on<MainScreenSetAudioEvent>((event, emit) async {
    //   audio.stop();
    //   audio = PageManager(audioPath: null, source: AudioSource.url);
    //   audio = event.curentAudio;
    //   priviusAudio = event.name;
    //   emit(MainScreenAudioState(
    //     name: event.name,
    //     mainImage: event.mainImage,
    //     curentAudio: event.curentAudio,
    //   ));
    // });
    // on<MainScreenDisposeAudioEvent>((event, emit) async {
    //   if (event.name == priviusAudio) {
    //     emit(MainScreenDefaultState());
    //     await audio.dispose();
    //     audio = PageManager(audioPath: null, source: AudioSource.url);
    //   }
    // });
  }
}
