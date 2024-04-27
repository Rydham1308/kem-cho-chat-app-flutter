part of 'user_list_bloc.dart';

@immutable
abstract class UserListState {
  const UserListState();
}

class UserListCurrentStates extends UserListState {
  final Status status;
  final String? errorMessage;
  final List<UserModel>? userList;

  const UserListCurrentStates._({
    required this.status,
    this.errorMessage,
    this.userList,
  });

  const UserListCurrentStates.isInitial() : this._(status: Status.isInitial);

  const UserListCurrentStates.isLoaded({required List<UserModel>? userList})
      : this._(status: Status.isLoaded, userList: userList);

  const UserListCurrentStates.isLoading() : this._(status: Status.isLoading);

  const UserListCurrentStates.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}

class ChatListCurrentStates extends UserListState {
  final Status status;
  final String? errorMessage;
  final List<ChatIdsModel>? chatIdsModel;

  const ChatListCurrentStates._({
    required this.status,
    this.errorMessage,
    this.chatIdsModel,
  });

  const ChatListCurrentStates.isInitial() : this._(status: Status.isInitial);

  const ChatListCurrentStates.isLoaded({required List<ChatIdsModel>? chatIdsModel})
      : this._(status: Status.isLoaded, chatIdsModel: chatIdsModel);

  const ChatListCurrentStates.isLoading() : this._(status: Status.isLoading);

  const ChatListCurrentStates.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}