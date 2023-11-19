import 'package:admin/Bloc/EditDocument/edit_document_event.dart';
import 'package:admin/Bloc/EditDocument/edit_document_state.dart';
import 'package:admin/Dio/base_dio.dart';
import 'package:admin/Repository/get_data_repository.dart';
import 'package:admin/Repository/upload_data_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditDocumentBloc extends Bloc<EditDocumentEvent, EditDocumentState> {
  IUploadDataRepository rep = locator.get();
  IGetDataRepository getRep = locator.get();
  // DocumentModel document = DocumentModel(name: "", creationDate: "");
  ValueNotifier uploadProgress = ValueNotifier([false, false, false]);
  ValueNotifier error = ValueNotifier(false);
  EditDocumentBloc() : super(EditDocumentInitState()) {
    on<InitEvent>((event, emit) async {
      // document = event.document;
      emit(LoadingState());

      var data =
          await getRep.getGroupSubGroupById(event.groupId, event.subGroupId);

      emit(DocumentFirstState(groupSubGroup: data));
    });

    on<EditEvent>((event, emit) async {
      emit(EditState());
    });
    on<InitUploadEvent>((event, emit) async {
      error = ValueNotifier(false);
      uploadProgress = ValueNotifier([false, false, false]);
      emit(InitUploadState());
      var data = await rep.checkDocumentName(event.documentName);
      emit(ReadyUploadState(data: data));
    });
    on<UploadEvent>((event, emit) async {
      emit(UploadState(uploadProgress: uploadProgress, error: error));
      await rep.uploadDocument(event.document, uploadProgress, error);
    });
  }
}
