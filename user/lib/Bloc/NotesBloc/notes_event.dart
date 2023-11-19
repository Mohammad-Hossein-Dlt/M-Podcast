abstract class NotesEvent {}

class GetNotesEvent implements NotesEvent {
  int offset;
  String order;
  GetNotesEvent({required this.offset, required this.order});
}

class LoadMoreNotesEvent implements NotesEvent {
  int offset;
  String order;
  LoadMoreNotesEvent({required this.offset, required this.order});
}

class RemoveNoteEvent implements NotesEvent {
  String itemId;
  int documentId;
  RemoveNoteEvent({required this.itemId, required this.documentId});
}
