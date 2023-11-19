import 'package:dartz/dartz.dart';
import 'package:user/DataModel/data_model.dart';

abstract class NotesState {}

class NotesInitState implements NotesState {}

class NotesLoadingState implements NotesState {}

class NotesDataState implements NotesState {
  Either<String, NotesDataModel> notes;

  NotesDataState({required this.notes});
}

class RemoveErrorState implements NotesState {}

class NoLoginState implements NotesState {}
