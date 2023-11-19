import 'package:flutter/material.dart';
import 'package:user/PageManager/pagemanager.dart';
import 'package:dartz/dartz.dart';

abstract class MainScreenState {}

class MainScreenInitState implements MainScreenState {}

class MainScreenLoadingState implements MainScreenState {}

class MainScreenSplashState implements MainScreenState {}

class MainScreenErrorSplashState implements MainScreenState {}

class MainScreentMainState implements MainScreenState {
  UniqueKey uniqueKey;
  MainScreentMainState({required this.uniqueKey});
}

class NotificationState implements MainScreenState {
  Either<String, Map> notificationData;
  NotificationState({required this.notificationData});
}

class MainScreenAudioState implements MainScreenState {
  String name = "";
  String mainImage;
  PageManager curentAudio = PageManager(fileName: null, documentName: null);

  MainScreenAudioState({
    required this.name,
    required this.mainImage,
    required this.curentAudio,
  });
}
