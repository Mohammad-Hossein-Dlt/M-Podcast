import 'package:flutter/cupertino.dart';

abstract class DocumentOnlineEvent {}

class GetOrdinaryDocumentEvent implements DocumentOnlineEvent {
  int id;
  GetOrdinaryDocumentEvent({
    required this.id,
  });
}

class LikeDocumentEvent implements DocumentOnlineEvent {
  BuildContext ctx;
  int id;
  LikeDocumentEvent({
    required this.ctx,
    required this.id,
  });
}

class AddDocumentToFavoritesEvent implements DocumentOnlineEvent {
  BuildContext ctx;
  int id;
  AddDocumentToFavoritesEvent({
    required this.ctx,
    required this.id,
  });
}

class NoteEvent implements DocumentOnlineEvent {
  String itemId;
  int id;
  BuildContext ctx;

  NoteEvent({
    required this.itemId,
    required this.id,
    required this.ctx,
  });
}
