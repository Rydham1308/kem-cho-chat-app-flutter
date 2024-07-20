import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/sp_keys.dart';
import '../../auth_module/model/user_model.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(const ChatListCurrentStates.isInitial()) {
    on<GetChatListEvent>(getChatListEvent);
  }

  Future<void> getChatListEvent(GetChatListEvent event, Emitter<ChatListState> emit) async {
    try {
      emit(const ChatListCurrentStates.isLoading());
      SharedPreferences sp = await SharedPreferences.getInstance();
      int? curUserIndex = sp.getInt(AppKeys.currentUserIndex);

      // data request from firebase
      final db = FirebaseFirestore.instance;
      final response = await db.collection('user').get();
      final dataList = response.docs.map((e) => UserModel.fromJson(e.data())).toList();

      //stored chatIds in local
      List<Map<String, dynamic>>? chatIdsCurUserList = dataList[curUserIndex ?? 0].chatIds;
      emit(ChatListCurrentStates.isLoaded(chatIdsModel: chatIdsCurUserList));
    } catch (e) {
      emit(ChatListCurrentStates.isError(errorMessage: e.toString()));
    }
  }
}
