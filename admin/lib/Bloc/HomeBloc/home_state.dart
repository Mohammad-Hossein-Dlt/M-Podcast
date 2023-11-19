import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeState {}

class HomeInitState implements HomeState {}

class HomeLoadingState implements HomeState {}

class HomeDefaultState implements HomeState {}

class HomeDataState implements HomeState {
  Either<String, HomeDataModel> data;
  HomeDataState({required this.data});
}
