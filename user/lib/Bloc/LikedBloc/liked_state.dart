import 'package:dartz/dartz.dart';
import 'package:user/DataModel/data_model.dart';

abstract class LikedState {}

class LikedInitState implements LikedState {}

class LikedLoadingState implements LikedState {}

class LikedErrorState implements LikedState {}

class LikedDataState implements LikedState {
  Either<String, PageinationDataModel> bookmarksList;

  LikedDataState({required this.bookmarksList});
}

class NoLoginState implements LikedState {}
