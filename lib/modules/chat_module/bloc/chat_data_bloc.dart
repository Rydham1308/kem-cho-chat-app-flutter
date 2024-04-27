import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kem_cho/modules/chat_module/model/chat_model.dart';

part 'chat_data_event.dart';

part 'chat_data_state.dart';

class ChatDataBloc extends Bloc<ChatDataEvent, ChatDataState> {
  ChatDataBloc() : super(const ChatCurrentStates.isInitial()) {
    on<SendChatDataEvent>(sendChatData);
    on<GetChatDataEvent>(getChatData);
  }

  Future<void> sendChatData(SendChatDataEvent event, Emitter<ChatDataState> emit) async {
    try {
      emit(const ChatSentCurrentStates.isLoading());
      final db = FirebaseFirestore.instance;

      await db
          .collection('chat')
          .doc(event.connectionKey)
          .collection('verified')
          .doc(event.timeStamp)
          .set(event.json);

      emit(const ChatSentCurrentStates.isSent(isSent: true));
    } catch (e) {
      emit(ChatSentCurrentStates.isError(errorMessage: e.toString()));
    }
  }

  Future<void> getChatData(GetChatDataEvent event, Emitter<ChatDataState> emit) async {
    try {
      emit(const ChatCurrentStates.isLoading());
      final db = FirebaseFirestore.instance;
      final response =
          await db.collection('chat').doc(event.connectionKey).collection('verified').get();
      List<ChatModel> chatList = response.docs.map((e) => ChatModel.fromJson(e.data())).toList();
      emit(ChatCurrentStates.isLoaded(chatList: chatList));
    } catch (e) {
      emit(ChatCurrentStates.isError(errorMessage: e.toString()));
    }
  }
}
