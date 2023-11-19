import 'package:admin/Bloc/SearchBloc/search_event.dart';
import 'package:admin/Bloc/SearchBloc/search_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/delete_repository.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final IGetDataRepository rep = locator.get();
  IDeleteDataRepository deleteRep = locator.get();
  ValueNotifier progress = ValueNotifier(false);
  ValueNotifier error = ValueNotifier(false);
  SearchBloc() : super(SearchInitState()) {
    on<FirstSearchResultData>((event, emit) async {
      emit(SearchLoadingState());
      var data = await rep.search(
          ofsset: event.offset, topic: event.topic, by: event.by);
      emit(SearchDataState(data: data));
    });

    on<LoadMoreSearchResultData>((event, emit) async {
      var data = await rep.search(
          ofsset: event.offset, topic: event.topic, by: event.by);
      emit(SearchDataState(data: data));
    });
    // ----------------------------------------------------------------------
    on<FirstSearchByLabelResultData>((event, emit) async {
      emit(SearchLoadingState());
      var data = await rep.searchByLabel(
          ofsset: event.offset, topic: event.topic, by: event.by);
      emit(SearchDataState(data: data));
    });

    on<LoadMoreSearchByLabelResultData>((event, emit) async {
      var data = await rep.searchByLabel(
          ofsset: event.offset, topic: event.topic, by: event.by);
      emit(SearchDataState(data: data));
    });
    // ----------------------------------------------------------------------
    on<SearchDefaultEvent>((event, emit) {
      emit(SearchDefaultState());
    });

    on<DocumentDeleteEvent>((event, emit) async {
      await deleteRep.deleteDocument(event.name, event.id, progress, error);
    });
  }
}
