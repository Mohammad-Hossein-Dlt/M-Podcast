import 'package:user/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class SubGroupsState {}

class SubGroupsInitState implements SubGroupsState {}

class SubGroupsLoadingState implements SubGroupsState {}

class SubGroupsDataState implements SubGroupsState {
  Either<String, SubGroupsDataModel> data;
  SubGroupsDataState({required this.data});
}
