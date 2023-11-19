import 'package:admin/Bloc/UnGroupingDocumentsBloc/ungrouping_documents_event.dart';
import 'package:admin/Bloc/UnGroupingDocumentsBloc/ungrouping_documents_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnGroupingDocumentsBloc
    extends Bloc<UnGroupingDocumentsEvent, UnGroupingDocumentsState> {
  final IGetDataRepository rep = locator.get();
  UnGroupingDocumentsBloc() : super(UnGroupingDocumentsInitState()) {
    on<GetUnGroupingDocumentsEvent>((event, emit) async {
      emit(UnGroupingDocumentsDataLoadingState());
      var data = await rep.getUnGroupingDocuments();
      emit(UnGroupingDocumentsDataState(data: data));
    });

    on<UnGroupingDocumentsDefaultEvent>((event, emit) async {
      emit(UnGroupingDocumentsDefaultState());
    });
  }
}
