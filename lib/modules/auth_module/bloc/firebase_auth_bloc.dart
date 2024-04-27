import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kem_cho/constants/sp_keys.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:kem_cho/modules/auth_module/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'firebase_auth_event.dart';
part 'firebase_auth_state.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  FirebaseAuthBloc() : super(const FirebaseAuthCurrentStates.isInitial()) {
    on<UserRegisterEvent>(registerUser);
    on<UserSignInEvent>(signInUser);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> registerUser(UserRegisterEvent event, Emitter<FirebaseAuthState> emit) async {
    UserModel user = UserModel.fromJson(event.json);
    try {
      emit(const FirebaseAuthCurrentStates.isLoading());
      await auth.createUserWithEmailAndPassword(
        email: user.email?.trim() ?? '',
        password: user.pass?.trim() ?? '',
      );
      emit(const FirebaseAuthCurrentStates.isRegistered(isReg: true));
    } on FirebaseException catch (e) {
      emit(FirebaseAuthCurrentStates.isError(errorMessage: e.message.toString()));
    }
  }

  Future<void> signInUser(UserSignInEvent event, Emitter<FirebaseAuthState> emit) async {
    UserModel? user = UserModel.fromJson(event.json);
    try {
      emit(const FirebaseAuthCurrentStates.isLoading());
      await auth.signInWithEmailAndPassword(
        email: user.email?.trim() ?? '',
        password: user.pass?.trim() ?? '',
      );
      var sp = await SharedPreferences.getInstance();
      sp.setBool(AppKeys.keyLogin, true);
      emit(const FirebaseAuthCurrentStates.isRegistered(isReg: true));
    } on FirebaseException catch (e) {
      emit(FirebaseAuthCurrentStates.isError(
        errorMessage:
            e.code == 'invalid-credential' ? 'Invalid email or password.' : e.message ?? '',
      ));
    }
  }
}
