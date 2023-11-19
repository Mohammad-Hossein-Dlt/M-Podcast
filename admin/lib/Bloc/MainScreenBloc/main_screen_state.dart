import 'package:admin/PageManager/pagemanager.dart';
import 'package:dartz/dartz.dart';

abstract class MainScreenState {}

class MainScreenInitState implements MainScreenState {}

class MainScreenLoadingState implements MainScreenState {}

class MainScreenDefaultState implements MainScreenState {}

class NotificationState implements MainScreenState {
  Either<String, Map> notificationData;
  NotificationState({required this.notificationData});
}

class MainScreenAudioState implements MainScreenState {
  String name = "";
  String mainImage;
  PageManager curentAudio = PageManager(audioPath: "", source: AudioSource.url);
  MainScreenAudioState({
    required this.name,
    required this.mainImage,
    required this.curentAudio,
  });
}
