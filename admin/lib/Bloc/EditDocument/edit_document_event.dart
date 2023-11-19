import 'package:admin/Document/DocumentModel.dart';

abstract class EditDocumentEvent {}

class InitEvent implements EditDocumentEvent {
  DocumentModel document;
  String groupId;
  String subGroupId;
  InitEvent(
      {required this.document,
      required this.groupId,
      required this.subGroupId});
}

class EditEvent implements EditDocumentEvent {}

class InitUploadEvent implements EditDocumentEvent {
  String documentName;
  InitUploadEvent({required this.documentName});
}

class UploadEvent implements EditDocumentEvent {
  DocumentModel document;
  UploadEvent({required this.document});
}
