part of 'chat_data_bloc.dart';

@immutable
abstract class ChatDataState {
  const ChatDataState();
}

class ChatCurrentStates extends ChatDataState {
  final Status status;
  final String? errorMessage;
  final List<ChatModel>? chatList;
  final bool? isSent;
  final String? name;

  const ChatCurrentStates._({
    required this.status,
    this.errorMessage,
    this.chatList,
    this.isSent,
    this.name,
  });

  const ChatCurrentStates.isInitial() : this._(status: Status.isInitial);

  const ChatCurrentStates.isSent({required bool isSent})
      : this._(status: Status.isSent, isSent: true);

  const ChatCurrentStates.isLoaded({required List<ChatModel>? chatList, String? name})
      : this._(status: Status.isLoaded, chatList: chatList, name: name);

  const ChatCurrentStates.isLoading() : this._(status: Status.isLoading);

  const ChatCurrentStates.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}

class ChatSentCurrentStates extends ChatDataState {
  final Status status;
  final String? errorMessage;
  final List<ChatModel>? chatList;
  final bool? isSent;

  const ChatSentCurrentStates._({
    required this.status,
    this.errorMessage,
    this.chatList,
    this.isSent,
  });

  const ChatSentCurrentStates.isInitial() : this._(status: Status.isInitial);

  const ChatSentCurrentStates.isSent({required bool isSent})
      : this._(status: Status.isSent, isSent: true);

  // const ChatSentCurrentStates.isLoaded({required List<ChatModel>? chatList})
  //     : this._(status: Status.isLoaded, chatList: chatList);

  const ChatSentCurrentStates.isLoading() : this._(status: Status.isLoading);

  const ChatSentCurrentStates.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}
