import 'package:flutter/material.dart';

abstract class SendMessageState {}

class SendMessageInitState implements SendMessageState {}

class MessageEditState implements SendMessageState {}

class SentMessageState implements SendMessageState {
  ValueNotifier sendProgress;
  ValueNotifier error;
  SentMessageState({required this.sendProgress, required this.error});
}
