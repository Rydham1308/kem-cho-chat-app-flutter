part of 'firebase_auth_bloc.dart';

@immutable
abstract class FirebaseAuthEvent {}

class UserRegisterEvent extends FirebaseAuthEvent {
  final Map<String, dynamic> json;

  UserRegisterEvent({required this.json});
}

class UserSignInEvent extends FirebaseAuthEvent {
  final Map<String, dynamic> json;

  UserSignInEvent({required this.json});
}
