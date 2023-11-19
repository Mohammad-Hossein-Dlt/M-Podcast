import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_event.dart';
import 'package:admin/Bloc/FetchDocumentsBloc/fetch_documents_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchDocumentsBloc
    extends Bloc<FetchDocumentsEvent, FetchDocumentsState> {
  final IGetDataRepository rep = locator.get();
  FetchDocumentsBloc() : super(FetchDocumentsInitState()) {
    on<FetchFirstDocumentsEvent>((event, emit) async {
      emit(FetchDocumentsLoading());
      var data =
          await rep.getAllDocumentsBy(ofsset: event.offset, by: event.by);
      await Future.delayed(
        Duration(seconds: 1),
        () {
          emit(FetchDocumentsData(data: data));
        },
      );
    });
    on<FetchMoreDocumentsEvent>((event, emit) async {
      var data =
          await rep.getAllDocumentsBy(ofsset: event.offset, by: event.by);
      emit(FetchDocumentsData(data: data));
    });

    on<FetchFirstDocumentsByEvent>((event, emit) async {
      emit(FetchDocumentsLoading());
      var data = await rep.getDocumentsBy(
          ofsset: event.offset,
          by: event.by,
          group: event.group,
          subGroup: event.subGroup);
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(FetchDocumentsData(data: data));
        },
      );
    });

    on<FetchMoreByEvent>((event, emit) async {
      var data = await rep.getDocumentsBy(
          ofsset: event.offset,
          by: event.by,
          group: event.group,
          subGroup: event.subGroup);
      emit(FetchDocumentsData(data: data));
    });
  }
}
