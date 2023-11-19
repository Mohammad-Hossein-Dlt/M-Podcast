abstract class FetchDocumentsEvent {}

class FetchFirstDocumentsEvent implements FetchDocumentsEvent {
  int offset = 0;
  String by = "newest";
  FetchFirstDocumentsEvent({required this.offset, required this.by});
}

class FetchMoreDocumentsEvent implements FetchDocumentsEvent {
  int offset = 0;
  String by = "newest";
  FetchMoreDocumentsEvent({required this.offset, required this.by});
}

class FetchFirstDocumentsByEvent implements FetchDocumentsEvent {
  int offset = 0;
  String by = "newest";
  String group = "";
  String subGroup = "";
  FetchFirstDocumentsByEvent(
      {required this.offset,
      required this.by,
      required this.group,
      required this.subGroup});
}

class FetchMoreByEvent implements FetchDocumentsEvent {
  int offset = 0;
  String by = "newest";
  String group = "";
  String subGroup = "";
  FetchMoreByEvent(
      {required this.offset,
      required this.by,
      required this.group,
      required this.subGroup});
}
