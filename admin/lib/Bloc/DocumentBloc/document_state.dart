import 'package:admin/DataModel/data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class DocumentOnlineState {}

class DocumentInitState implements DocumentOnlineState {}

class DocumentLoadingState implements DocumentOnlineState {}

class DocumentDataState implements DocumentOnlineState {
  Either<String, OrdinaryDocumentDataModel> data;
  DocumentDataState({required this.data});
}

class DocumentEditState implements DocumentOnlineState {
  Either<String, EditDocumentDataModel> data;
  DocumentEditState({required this.data});
}

class LoadingGroupSubGroupState implements DocumentOnlineState {}

class GroupSubGroupDataState implements DocumentOnlineState {
  Either<String, GroupSubGroup> groupSubGroup;

  GroupSubGroupDataState({
    required this.groupSubGroup,
  });
}

class DocumentEditDefaultState implements DocumentOnlineState {}

class OnlineInitUploadState implements DocumentOnlineState {}

class OnlineReadyUploadState implements DocumentOnlineState {
  Either<String, bool> data;
  OnlineReadyUploadState({required this.data});
}

class OnlineUploadState implements DocumentOnlineState {
  ValueNotifier uploadProgress;
  ValueNotifier error;
  OnlineUploadState({required this.uploadProgress, required this.error});
}
