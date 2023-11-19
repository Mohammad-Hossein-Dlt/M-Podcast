import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

abstract class EditDocumentState {}

class EditDocumentInitState implements EditDocumentState {}

class DocumentFirstState implements EditDocumentState {
  Either<String, GroupSubGroup> groupSubGroup;

  DocumentFirstState({
    required this.groupSubGroup,
  });
}

class LoadingState implements EditDocumentState {}

class ErrorState implements EditDocumentState {}

class EditState implements EditDocumentState {}

class InitUploadState implements EditDocumentState {}

class ReadyUploadState implements EditDocumentState {
  Either<String, bool> data;
  ReadyUploadState({required this.data});
}

class UploadState implements EditDocumentState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  UploadState({required this.uploadProgress, required this.error});
}
