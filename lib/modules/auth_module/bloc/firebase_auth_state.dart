part of 'firebase_auth_bloc.dart';

@immutable
abstract class FirebaseAuthState {
  const FirebaseAuthState();
}


class FirebaseAuthCurrentStates extends FirebaseAuthState {
  final Status status;
  final String? errorMessage;
  final bool? isReg;

  const FirebaseAuthCurrentStates._({
    required this.status,
    this.errorMessage,
    this.isReg,
  });

  const FirebaseAuthCurrentStates.isInitial() : this._(status: Status.isInitial);

  const FirebaseAuthCurrentStates.isSuccess() : this._(status: Status.isSuccess);

  const FirebaseAuthCurrentStates.isRegistered({required bool? isReg})
      : this._(status: Status.isRegistered, isReg: isReg);

  const FirebaseAuthCurrentStates.isLoading() : this._(status: Status.isLoading);

  const FirebaseAuthCurrentStates.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}
