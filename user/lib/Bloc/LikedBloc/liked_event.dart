import 'package:flutter/material.dart';

abstract class LikedEvent {}

class GetLikedEvent implements LikedEvent {
  int offset;
  String order;
  GetLikedEvent({required this.offset, required this.order});
}

class LoadMoreLikedEvent implements LikedEvent {
  int offset;
  String order;

  LoadMoreLikedEvent({required this.offset, required this.order});
}

class RemoveFromLikedEvent implements LikedEvent {
  int id;
  BuildContext ctx;
  RemoveFromLikedEvent({required this.id, required this.ctx});
}
