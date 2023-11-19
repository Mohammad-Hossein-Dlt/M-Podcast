import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class InfoState {}

class InfoInitState implements InfoState {}

class InfoLoadingState implements InfoState {}

class InfoEditState implements InfoState {}

class InfoDataState implements InfoState {
  Either<String, List> infoData;
  InfoDataState({
    required this.infoData,
  });
}

class InitInfoUploadState implements InfoState {}

class OnUploadInfoDataState implements InfoState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  OnUploadInfoDataState({
    required this.uploadProgress,
    required this.error,
  });
}
