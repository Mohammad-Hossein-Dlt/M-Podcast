import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class SearchState {}

class SearchInitState implements SearchState {}

class SearchLoadingState implements SearchState {}

class SearchDefaultState implements SearchState {}

class SearchDataState implements SearchState {
  Either<String, SearchPageinationDataModel> data;
  SearchDataState({required this.data});
}
