import 'package:dartz/dartz.dart';

abstract class UnGroupingDocumentsState {}

class UnGroupingDocumentsInitState implements UnGroupingDocumentsState {}

class UnGroupingDocumentsDataLoadingState implements UnGroupingDocumentsState {}

class UnGroupingDocumentsDefaultState implements UnGroupingDocumentsState {}

class UnGroupingDocumentsDataState implements UnGroupingDocumentsState {
  Either<String, List> data;
  UnGroupingDocumentsDataState({required this.data});
}
