import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class CategoriesState {}

class CategoriesInitState implements CategoriesState {}

class CategoriesLoadingState implements CategoriesState {}

class CategoriesDataState implements CategoriesState {
  Either<String, CategoriesDataModel> data;
  CategoriesDataState({required this.data});
}
