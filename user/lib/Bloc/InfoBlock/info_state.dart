import 'package:dartz/dartz.dart';

abstract class InfoState {}

class InfoInitState implements InfoState {}

class InfoLoadingState implements InfoState {}

class InfoDataState implements InfoState {
  Either<String, List> infoData;
  InfoDataState({
    required this.infoData,
  });
}
