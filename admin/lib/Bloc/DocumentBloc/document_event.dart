import '../../DataModel/data_model.dart';

abstract class DocumentOnlineEvent {}

class GetOrdinaryDocumentEvent implements DocumentOnlineEvent {
  int id;
  GetOrdinaryDocumentEvent({required this.id});
}

class GetDocumentToEditEvent implements DocumentOnlineEvent {
  int id;
  GetDocumentToEditEvent({required this.id});
}

class GetGroupSubGroupByIdEvent implements DocumentOnlineEvent {
  String groupId;
  String subGroupId;
  GetGroupSubGroupByIdEvent({required this.groupId, required this.subGroupId});
}

class InitDocumentEditEvent implements DocumentOnlineEvent {}

class OnlineInitUploadEvent implements DocumentOnlineEvent {
  String name;
  OnlineInitUploadEvent({required this.name});
}

class OnlineUploadEvent implements DocumentOnlineEvent {
  EditDocumentDataModel document;
  String newName;
  OnlineUploadEvent({required this.document, required this.newName});
}

class DocumentDeleteEvent implements DocumentOnlineEvent {
  String name;
  int id;
  DocumentDeleteEvent({required this.name, required this.id});
}
