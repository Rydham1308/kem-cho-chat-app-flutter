part of 'chat_data_bloc.dart';

@immutable
abstract class ChatDataEvent {}

class GetChatDataEvent extends ChatDataEvent {
  final String connectionKey;

  GetChatDataEvent({required this.connectionKey});
}

class SendChatDataEvent extends ChatDataEvent {
  final Map<String, dynamic> json;
  final String connectionKey;
  final String timeStamp;
  SendChatDataEvent({required this.json, required this.connectionKey, required this.timeStamp});
}
