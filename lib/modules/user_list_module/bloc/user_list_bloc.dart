import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:kem_cho/modules/auth_module/model/user_model.dart';
import 'package:kem_cho/modules/user_list_module/model/chat_id_model.dart';

part 'user_list_event.dart';

part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc() : super(const UserListCurrentStates.isInitial()) {
    on<GetUserListEvent>(getUserList);
    // on<ConnectUsersEvent>(getUserConnectionList);
  }

  List<UserModel>? userList;

  Future<void> getUserList(GetUserListEvent event, Emitter<UserListState> emit) async {
    final fireStore = FirebaseFirestore.instance;

    try {
      emit(const UserListCurrentStates.isLoading());
      final response = await fireStore.collection('user').get();
      final dataList = response.docs.map((e) => UserModel.fromJson(e.data())).toList();
      userList = dataList;
      emit(UserListCurrentStates.isLoaded(userList: userList));
    } on FirebaseFirestore catch (e) {
      emit(UserListCurrentStates.isError(errorMessage: e.toString()));
    }
  }

  // Future<void> getUserConnectionList(ConnectUsersEvent event, Emitter<UserListState> emit) async {
  //
  // }
}
