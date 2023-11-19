import 'package:admin/Bloc/DocumentBloc/document_event.dart';
import 'package:admin/Bloc/DocumentBloc/document_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/delete_repository.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentOnlineBloc
    extends Bloc<DocumentOnlineEvent, DocumentOnlineState> {
  IUploadDataRepository uploadRep = locator.get();
  IGetDataRepository getRep = locator.get();
  IDeleteDataRepository deleteRep = locator.get();
  ValueNotifier progress = ValueNotifier([false, false, false]);
  ValueNotifier error = ValueNotifier(false);
  DocumentOnlineBloc() : super(DocumentInitState()) {
    on<GetOrdinaryDocumentEvent>((event, emit) async {
      emit(DocumentLoadingState());
      var data = await getRep.getDocument(id: event.id);
      await Future.delayed(
        Duration(seconds: 1),
        () {
          emit(DocumentDataState(data: data));
        },
      );
    });
    on<GetDocumentToEditEvent>((event, emit) async {
      emit(DocumentLoadingState());
      var data = await getRep.getDocumentToEdit(id: event.id);
      emit(DocumentEditState(data: data));
    });

    on<GetGroupSubGroupByIdEvent>((event, emit) async {
      emit(LoadingGroupSubGroupState());
      var data =
          await getRep.getGroupSubGroupById(event.groupId, event.subGroupId);
      emit(GroupSubGroupDataState(groupSubGroup: data));
    });

    on<InitDocumentEditEvent>((event, emit) async {
      emit(DocumentEditDefaultState());
    });

    on<OnlineInitUploadEvent>((event, emit) async {
      error = ValueNotifier(false);
      progress = ValueNotifier([false, false, false]);
      emit(OnlineInitUploadState());
      var data = await uploadRep.checkDocumentName(event.name);
      emit(OnlineReadyUploadState(data: data));
    });
    on<OnlineUploadEvent>((event, emit) async {
      emit(OnlineUploadState(uploadProgress: progress, error: error));
      await uploadRep.uppdateDocument(
          event.document, event.newName, progress, error);
    });

    on<DocumentDeleteEvent>((event, emit) async {
      progress = ValueNotifier(false);
      await deleteRep.deleteDocument(event.name, event.id, progress, error);
    });
  }
}
