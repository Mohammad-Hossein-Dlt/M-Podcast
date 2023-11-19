import 'package:user/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';

abstract class DocumentOnlineState {}

class DocumentInitState implements DocumentOnlineState {}

class DocumentLoadingState implements DocumentOnlineState {}

class DocumentErrorState implements DocumentOnlineState {}

class DocumentOnRefreshState implements DocumentOnlineState {
  OnRefresh onRefresh;
  DocumentOnRefreshState({required this.onRefresh});
}

class DocumentRefreshState implements DocumentOnlineState {
  DocumentDataModel document;
  OnRefresh onRefresh = OnRefresh.none;

  DocumentRefreshState({required this.document});
}

class DocumentDataState implements DocumentOnlineState {
  Either<String, DocumentDataModel> data;
  DocumentDataState({required this.data});
}

enum OnRefresh { none, like, addToFavorites, noting }
