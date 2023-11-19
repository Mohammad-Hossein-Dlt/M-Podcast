import 'package:dartz/dartz.dart';
import 'package:user/DataModel/data_model.dart';

abstract class FavoritesState {}

class FavoritesInitState implements FavoritesState {}

class FavoritesLoadingState implements FavoritesState {}

class FavoritesErrorState implements FavoritesState {}

class FavoritesDataState implements FavoritesState {
  Either<String, PageinationDataModel> bookmarksList;

  FavoritesDataState({required this.bookmarksList});
}

class NoLoginState implements FavoritesState {}
