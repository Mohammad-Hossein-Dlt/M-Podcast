import 'package:admin/PageManager/pagemanager.dart';
import 'package:flutter/cupertino.dart';

abstract class MainScreenEvent {}

class GetMainScreenDataEvent implements MainScreenEvent {
  BuildContext ctx;
  GetMainScreenDataEvent({required this.ctx});
}

class MainScreenDefaultEvent implements MainScreenEvent {}

class MainScreenSetAudioEvent implements MainScreenEvent {
  String name = "";
  String mainImage;
  PageManager curentAudio = PageManager(audioPath: "", source: AudioSource.url);
  MainScreenSetAudioEvent({
    required this.name,
    required this.mainImage,
    required this.curentAudio,
  });
}

class MainScreenDisposeAudioEvent implements MainScreenEvent {
  String name;
  MainScreenDisposeAudioEvent({required this.name});
}
