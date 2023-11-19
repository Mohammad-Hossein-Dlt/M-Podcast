import 'package:user/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class CategoriesPageState {}

class CategoriesPageInitState implements CategoriesPageState {}

class CategoriesPageLoadingState implements CategoriesPageState {}

class CategoriesPageDataState implements CategoriesPageState {
  Either<String, CategoryPageDataModel> data;
  CategoriesPageDataState({required this.data});
}
