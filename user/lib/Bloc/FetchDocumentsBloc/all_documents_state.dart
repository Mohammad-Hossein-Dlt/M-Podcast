import 'package:user/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class FetchDocumentsState {}

class FetchDocumentsInitState implements FetchDocumentsState {}

class FetchDocumentsLoading implements FetchDocumentsState {}

class FetchDocumentsData implements FetchDocumentsState {
  Either<String, PageinationDataModel> data;
  FetchDocumentsData({required this.data});
}
