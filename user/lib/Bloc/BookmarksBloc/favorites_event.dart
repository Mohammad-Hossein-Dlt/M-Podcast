import 'package:flutter/material.dart';

abstract class FavoritesEvent {}

class GetFavoritesEvent implements FavoritesEvent {
  int offset;
  String order;
  GetFavoritesEvent({required this.offset, required this.order});
}

class LoadMoreFavoritesEvent implements FavoritesEvent {
  int offset;
  String order;

  LoadMoreFavoritesEvent({required this.offset, required this.order});
}

class RemoveFromFavoritesEvent implements FavoritesEvent {
  int id;
  BuildContext ctx;
  RemoveFromFavoritesEvent({required this.id, required this.ctx});
}
