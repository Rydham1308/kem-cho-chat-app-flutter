part of 'user_list_bloc.dart';

@immutable
abstract class UserListEvent {}

class GetUserListEvent extends UserListEvent {
  GetUserListEvent();
}

class ConnectUsersEvent extends UserListEvent {
  final ChatIdsModel? chatIdsModel;

  ConnectUsersEvent({required this.chatIdsModel});
}
