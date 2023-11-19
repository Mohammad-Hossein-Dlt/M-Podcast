import 'package:user/PageManager/pagemanager.dart';

abstract class MainScreenEvent {}

class GetMainScreenDataEvent implements MainScreenEvent {
  Function({required String message}) notification;
  GetMainScreenDataEvent({required this.notification});
}

class MainScreenDefaultEvent implements MainScreenEvent {}

class MainScreenSetAudioEvent implements MainScreenEvent {
  String name = "";
  String mainImage;
  PageManager curentAudio = PageManager(fileName: null, documentName: null);

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
