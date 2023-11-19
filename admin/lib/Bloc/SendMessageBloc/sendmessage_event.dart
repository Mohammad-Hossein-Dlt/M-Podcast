abstract class SendMessageEvent {}

class MessageEditEvent implements SendMessageEvent {}

class SendMessageDataEvent implements SendMessageEvent {
  String messageText;
  SendMessageDataEvent({required this.messageText});
}
