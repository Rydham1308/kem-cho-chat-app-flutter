import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kem_cho/constants/sp_keys.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:kem_cho/modules/chat_module/model/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/chat_data_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static Widget create(String connectionKey) {
    return BlocProvider(
      create: (BuildContext context) {
        return ChatDataBloc()..add(GetChatDataEvent(connectionKey: connectionKey));
      },
      child: const ChatScreen(),
    );
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  String? name;
  String? id;
  String? connectionKey;
  GlobalKey<FormState> chatMsgKey = GlobalKey<FormState>();
  TextEditingController txtMsg = TextEditingController();
  ChatModel chatModel = ChatModel();

  @override
  void didChangeDependencies() {
    final getData = ModalRoute.of(context)?.settings.arguments;
    if (getData is Map) {
      name = getData['name'];
      id = getData['id'];
      connectionKey = getData['connectionKey'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? '',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        // title: BlocBuilder<ChatDataBloc, ChatDataState>(
        //   builder: (context, state) {
        //     if (state is ChatCurrentStates && state.status == Status.isLoaded) {
        //       return Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             name ?? '',
        //             style: const TextStyle(fontSize: 20),
        //           ),
        //         ],
        //       );
        //     }else{
        //       return const SizedBox.shrink();
        //     }
        //   },
        // ),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            //region -- Gradient 1
            Positioned(
              top: -300,
              left: -300,
              child: Container(
                height: 600,
                width: 600,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    stops: [0.0005, 0.8],
                    colors: [
                      Color(0xb03191ff),
                      Colors.transparent,
                    ],
                    radius: 0.5,
                  ),
                ),
              ),
            ),
            //endregion

            //region -- Gradient 1
            Positioned(
              bottom: -340,
              left: -125,
              child: Container(
                height: 600,
                width: 600,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    stops: [0.0005, 0.8],
                    colors: [
                      Color(0xb03191ff),
                      Colors.transparent,
                    ],
                    radius: 0.5,
                  ),
                ),
              ),
            ),
            //endregion

            //#region -- ListView
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                BlocConsumer<ChatDataBloc, ChatDataState>(
                  listener: (context, state) {
                    if (state is ChatSentCurrentStates && state.status == Status.isSent) {
                      Future.delayed(Duration.zero).then(
                        (value) => context.read<ChatDataBloc>().add(
                              GetChatDataEvent(connectionKey: connectionKey ?? ''),
                            ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatCurrentStates && state.status == Status.isLoading) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      );
                    } else if (state is ChatCurrentStates && state.status == Status.isLoaded) {
                      if (state.chatList?.isNotEmpty ?? false) {
                        // return Expanded(
                        //   child: ListView.builder(
                        //     itemCount: state.chatList?.length,
                        //     // itemCount: state.chatList?.length,
                        //     // controller: _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                        //     //     duration: Duration(milliseconds: 300), curve: Curves.elasticOut),
                        //     itemBuilder: (context, index) {
                        //       final timeStamp = state.chatList?[index].timeStamp ?? '';
                        //       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                        //           int.tryParse(timeStamp) ?? 0);
                        //       final dateFormatter = DateFormat('yyyy-MM-dd');
                        //       final timeFormatter = DateFormat('hh:mm');
                        //       final formattedDate = dateFormatter.format(dateTime);
                        //       final formattedTime = timeFormatter.format(dateTime);
                        //
                        //       return Padding(
                        //         padding: const EdgeInsets.only(
                        //           top: 10,
                        //           left: 10,
                        //           right: 10,
                        //         ),
                        //         child: Container(
                        //           alignment: state.chatList?[index].senderId != id
                        //               ? Alignment.centerRight
                        //               : Alignment.centerLeft,
                        //           color: Colors.transparent,
                        //           child: Container(
                        //             width: 280,
                        //             alignment: Alignment.centerLeft,
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.only(
                        //                 topLeft: const Radius.circular(20),
                        //                 topRight: const Radius.circular(20),
                        //                 bottomRight: state.chatList?[index].senderId == id
                        //                     ? const Radius.circular(20)
                        //                     : const Radius.circular(0),
                        //                 bottomLeft: state.chatList?[index].senderId != id
                        //                     ? const Radius.circular(20)
                        //                     : const Radius.circular(0),
                        //               ),
                        //               color: Colors.grey.shade900,
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(
                        //                   top: 10, left: 20, right: 20, bottom: 10),
                        //               child: Column(
                        //                 mainAxisSize: MainAxisSize.min,
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     state.chatList?[index].senderId != id
                        //                         ? 'Me'
                        //                         : (name ?? ''),
                        //                     style: const TextStyle(
                        //                         color: Colors.blue, fontSize: 16),
                        //                   ),
                        //                   Text(
                        //                     '${state.chatList?[index].msg}',
                        //                     // state.chatList?[index].msg ?? '',
                        //                     style: const TextStyle(fontSize: 14),
                        //                   ),
                        //                   Row(
                        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                     children: [
                        //                       Row(
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        //                             child: Icon(
                        //                               CupertinoIcons.clock,
                        //                               size: 12,
                        //                               color: Colors.grey,
                        //                             ),
                        //                           ),
                        //                           Text(
                        //                             formattedTime.toString(),
                        //                             style: const TextStyle(
                        //                                 color: Colors.grey, fontSize: 12),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       Row(
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        //                             child: Icon(
                        //                               Icons.calendar_month_outlined,
                        //                               size: 12,
                        //                               color: Colors.grey,
                        //                             ),
                        //                           ),
                        //                           Text(
                        //                             formattedDate.toString(),
                        //                             style: const TextStyle(
                        //                                 color: Colors.grey, fontSize: 12),
                        //                           ),
                        //                         ],
                        //                       )
                        //                     ],
                        //                   ),
                        //                   state.chatList?[index].senderId != id
                        //                       ? Container(
                        //                     alignment: FractionalOffset.centerRight,
                        //                     child: const Icon(
                        //                       Icons.done_all_rounded,
                        //                       color: Colors.green,
                        //                       size: 14,
                        //                     ),
                        //                   )
                        //                       : const SizedBox.shrink()
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // );
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('chat')
                                .doc(connectionKey.toString())
                                .collection('verified')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: _scrollController,
                                    // snapshot.data!.docs
                                    //    .map((DocumentSnapshot document) {
                                    //      final data = ChatModel.fromJson(
                                    //          document.data() as Map<String, dynamic>);
                                    //      final timeStamp = data.timeStamp ?? '';
                                    //      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                                    //          int.tryParse(timeStamp) ?? 0);
                                    //      final dateFormatter = DateFormat('yyyy-MM-dd');
                                    //      final timeFormatter = DateFormat('hh:mm');
                                    //      final formattedDate = dateFormatter.format(dateTime);
                                    //      final formattedTime = timeFormatter.format(dateTime);
                                    //      // _scrollController.jumpTo(
                                    //      //   _scrollController.position.maxScrollExtent,
                                    //      //   /*duration: const Duration(seconds: 1), curve: Curves.easeIn,*/);
                                    //      return Padding(
                                    //        padding: const EdgeInsets.only(
                                    //          top: 10,
                                    //          left: 10,
                                    //          right: 10,
                                    //        ),
                                    //        child: Container(
                                    //          alignment: data.senderId != id
                                    //              ? Alignment.centerRight
                                    //              : Alignment.centerLeft,
                                    //          color: Colors.transparent,
                                    //          child: Container(
                                    //            width: 280,
                                    //            alignment: Alignment.centerLeft,
                                    //            decoration: BoxDecoration(
                                    //              borderRadius: BorderRadius.only(
                                    //                topLeft: const Radius.circular(20),
                                    //                topRight: const Radius.circular(20),
                                    //                bottomRight: data.senderId == id
                                    //                    ? const Radius.circular(20)
                                    //                    : const Radius.circular(0),
                                    //                bottomLeft: data.senderId != id
                                    //                    ? const Radius.circular(20)
                                    //                    : const Radius.circular(0),
                                    //              ),
                                    //              color: Colors.grey.shade900,
                                    //            ),
                                    //            child: Padding(
                                    //              padding: const EdgeInsets.only(
                                    //                  top: 10, left: 20, right: 20, bottom: 10),
                                    //              child: Column(
                                    //                mainAxisSize: MainAxisSize.min,
                                    //                crossAxisAlignment: CrossAxisAlignment.start,
                                    //                children: [
                                    //                  Text(
                                    //                    data.senderId != id
                                    //                        // state.chatList?[index].senderId != id
                                    //                        ? 'Me'
                                    //                        : (name ?? ''),
                                    //                    style: const TextStyle(
                                    //                        color: Colors.blue, fontSize: 16),
                                    //                  ),
                                    //                  Text(
                                    //                    '${data.msg}',
                                    //                    // state.chatList?[index].msg ?? '',
                                    //                    style: const TextStyle(fontSize: 14),
                                    //                  ),
                                    //                  Row(
                                    //                    mainAxisAlignment:
                                    //                        MainAxisAlignment.spaceBetween,
                                    //                    children: [
                                    //                      Row(
                                    //                        children: [
                                    //                          const Padding(
                                    //                            padding:
                                    //                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    //                            child: Icon(
                                    //                              CupertinoIcons.clock,
                                    //                              size: 12,
                                    //                              color: Colors.grey,
                                    //                            ),
                                    //                          ),
                                    //                          Text(
                                    //                            formattedTime.toString(),
                                    //                            style: const TextStyle(
                                    //                                color: Colors.grey,
                                    //                                fontSize: 12),
                                    //                          ),
                                    //                        ],
                                    //                      ),
                                    //                      Row(
                                    //                        children: [
                                    //                          const Padding(
                                    //                            padding:
                                    //                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    //                            child: Icon(
                                    //                              Icons.calendar_month_outlined,
                                    //                              size: 12,
                                    //                              color: Colors.grey,
                                    //                            ),
                                    //                          ),
                                    //                          Text(
                                    //                            formattedDate.toString(),
                                    //                            style: const TextStyle(
                                    //                                color: Colors.grey,
                                    //                                fontSize: 12),
                                    //                          ),
                                    //                        ],
                                    //                      )
                                    //                    ],
                                    //                  ),
                                    //                  data.senderId != id
                                    //                      ? Container(
                                    //                          alignment:
                                    //                              FractionalOffset.centerRight,
                                    //                          child: const Icon(
                                    //                            Icons.done_all_rounded,
                                    //                            color: Colors.green,
                                    //                            size: 14,
                                    //                          ),
                                    //                        )
                                    //                      : const SizedBox.shrink()
                                    //                ],
                                    //              ),
                                    //            ),
                                    //          ),
                                    //        ),
                                    //      );
                                    //    })
                                    //    .toList()
                                    //    .cast(),
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final data = snapshot.data!.docs.map((DocumentSnapshot document) =>
                                          ChatModel.fromJson(
                                              document.data() as Map<String, dynamic>)).toList();
                                      final timeStamp = data[index].timeStamp ?? '';
                                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                                          int.tryParse(timeStamp) ?? 0);
                                      final dateFormatter = DateFormat('yyyy-MM-dd');
                                      final timeFormatter = DateFormat('hh:mm');
                                      final formattedDate = dateFormatter.format(dateTime);
                                      final formattedTime = timeFormatter.format(dateTime);
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Container(
                                          alignment: data[index].senderId != id
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          color: Colors.transparent,
                                          child: Container(
                                            width: 280,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: const Radius.circular(20),
                                                topRight: const Radius.circular(20),
                                                bottomRight: data[index].senderId == id
                                                    ? const Radius.circular(20)
                                                    : const Radius.circular(0),
                                                bottomLeft: data[index].senderId != id
                                                    ? const Radius.circular(20)
                                                    : const Radius.circular(0),
                                              ),
                                              color: Colors.grey.shade900,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 20, right: 20, bottom: 10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[index].senderId != id
                                                        // state.chatList?[index].senderId != id
                                                        ? 'Me'
                                                        : (name ?? ''),
                                                    style: const TextStyle(
                                                        color: Colors.blue, fontSize: 16),
                                                  ),
                                                  Text(
                                                    '${data[index].msg}',
                                                    // state.chatList?[index].msg ?? '',
                                                    style: const TextStyle(fontSize: 14),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                            child: Icon(
                                                              CupertinoIcons.clock,
                                                              size: 12,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            formattedTime.toString(),
                                                            style: const TextStyle(
                                                                color: Colors.grey, fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                            child: Icon(
                                                              Icons.calendar_month_outlined,
                                                              size: 12,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            formattedDate.toString(),
                                                            style: const TextStyle(
                                                                color: Colors.grey, fontSize: 12),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  data[index].senderId != id
                                                      ? Container(
                                                          alignment: FractionalOffset.centerRight,
                                                          child: const Icon(
                                                            Icons.done_all_rounded,
                                                            color: Colors.green,
                                                            size: 14,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink()
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              }
                            });
                      } else {
                        return const Expanded(
                          child: Center(
                            child: Text('Start Conversation'),
                          ),
                        );
                      }
                    } else if (state is ChatCurrentStates && state.status == Status.isError) {
                      return Center(
                        child: Text(state.errorMessage ?? ''),
                      );
                    } else {
                      return const Expanded(child: SizedBox());
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
                  height: 65,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Form(
                          key: chatMsgKey,
                          child: TextFormField(
                            controller: txtMsg,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF212121),
                              hintText: 'Type...',
                              border: InputBorder.none,
                              errorStyle: const TextStyle(fontSize: 0),
                              contentPadding:
                                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (chatMsgKey.currentState!.validate()) {
                            final sp = await SharedPreferences.getInstance();

                            chatModel.msg = txtMsg.text.trim();
                            chatModel.senderId = sp.getString(AppKeys.currentUserId);
                            chatModel.receiverId = id;
                            chatModel.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
                            final db = FirebaseFirestore.instance;

                            await db
                                .collection('chat')
                                .doc(connectionKey)
                                .collection('verified')
                                .doc(chatModel.timeStamp)
                                .set(chatModel.toJson());
                            txtMsg.clear();
                            // Future.delayed(Duration.zero)
                            //     .then(
                            //       (value) => context.read<ChatDataBloc>().add(
                            //             SendChatDataEvent(
                            //                 timeStamp: chatModel.timeStamp ?? '',
                            //                 json: chatModel.toJson(),
                            //                 connectionKey: connectionKey ?? ''),
                            //           ),
                            //     )
                            //     .then((value) => txtMsg.clear());
                            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                            // .then(
                            //   (value) =>
                            // );
                            // Future.delayed(Duration.zero).then(
                            //       (value) => context.read<ChatDataBloc>().add(
                            //     GetChatDataEvent(
                            //         connectionKey: connectionKey ?? ''),
                            //   ),5

                            // );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const CircleBorder(),
                          minimumSize: const Size(55, 55),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //endregion
          ],
        ),
      ),
    );
  }
}
