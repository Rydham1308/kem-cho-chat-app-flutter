part of 'chat_list_bloc.dart';

@immutable
abstract class ChatListState {
  const ChatListState();
}

class ChatListCurrentStates extends ChatListState {
  final Status status;
  final String? errorMessage;
  final List<Map<String, dynamic>>? chatIdsModel;

  const ChatListCurrentStates._({
    required this.status,
    this.errorMessage,
    this.chatIdsModel,
  });

  const ChatListCurrentStates.isInitial() : this._(status: Status.isInitial);

  const ChatListCurrentStates.isLoaded({required List<Map<String, dynamic>>? chatIdsModel})
      : this._(status: Status.isLoaded, chatIdsModel: chatIdsModel);

  const ChatListCurrentStates.isLoading() : this._(status: Status.isLoading);

  const ChatListCurrentStates.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}