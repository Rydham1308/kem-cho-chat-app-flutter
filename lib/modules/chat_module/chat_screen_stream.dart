import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kem_cho/constants/sp_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alert_dialogbox.dart';
import 'model/chat_model.dart';

class ChatScreenStream extends StatefulWidget {
  const ChatScreenStream({super.key});

  @override
  State<ChatScreenStream> createState() => _ChatScreenStreamState();
}

class _ChatScreenStreamState extends State<ChatScreenStream> {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  String? name;
  String? id;
  String? connectionKey;
  GlobalKey<FormState> chatMsgKey = GlobalKey<FormState>();
  TextEditingController txtMsg = TextEditingController();
  ChatModel chatModel = ChatModel();

  // int selectedIndex = -1;
  String selectedTimestamp = '';

  // bool isDeleted = false;
  ValueNotifier<int> selectedIndex = ValueNotifier(-1);

  _showDialog(BuildContext context) {
    continueCallBack() {
      final db = FirebaseFirestore.instance;
      db
          .collection('chat')
          .doc(connectionKey)
          .collection('verified')
          .doc(selectedTimestamp)
          .delete();
      selectedIndex.value = -1;

      Navigator.of(context).pop();
    }

    BlurryDialog alert =
        BlurryDialog("Delete", "Are you sure you want to delete this chat?", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
        actions: [
          ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, value, child) {
              return selectedIndex.value != -1
                  ? GestureDetector(
                      onTap: () {
                        _showDialog(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(
                          CupertinoIcons.delete,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : const Icon(
                      CupertinoIcons.delete,
                      color: Colors.transparent,
                    );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
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

            //region -- ListView.builder
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chat')
                        .doc(connectionKey.toString())
                        .collection('verified')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data!.docs
                                    .map((DocumentSnapshot document) =>
                                        ChatModel.fromJson(document.data() as Map<String, dynamic>))
                                    .toList();
                                final timeStamp = data[index].timeStamp ?? '';
                                DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                                    int.tryParse(timeStamp) ?? 0);
                                final dateFormatter = DateFormat('yyyy-MM-dd');
                                final timeFormatter = DateFormat('hh:mm');
                                final formattedDate = dateFormatter.format(dateTime);
                                final formattedTime = timeFormatter.format(dateTime);
                                return ValueListenableBuilder(
                                  valueListenable: selectedIndex,
                                  builder: (BuildContext context, value, Widget? child) {
                                    return GestureDetector(
                                      onLongPress: () {
                                        if (selectedIndex.value == index) {
                                          selectedIndex.value = -1;
                                        } else {
                                          selectedIndex.value = index;
                                          selectedTimestamp = data[index].timeStamp ?? '';
                                        }
                                      },
                                      child: Padding(
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
                                              boxShadow: selectedIndex.value == index
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.blue.withOpacity(1),
                                                        spreadRadius: 5,
                                                        blurRadius: 30,
                                                        offset: const Offset(0, 0),
                                                      ),
                                                    ]
                                                  : [
                                                      const BoxShadow(
                                                        color: Colors.transparent,
                                                        spreadRadius: 0.1,
                                                        blurRadius: 15,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
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
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const Expanded(
                            child: Center(
                              child: Text('Start Conversation....'),
                            ),
                          );
                        }
                      } else {
                        return const Expanded(
                          child: Center(
                            child: Text('Network Error !'),
                          ),
                        );
                      }
                    }),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
                  height: 65,
                  width: double.infinity,
                  child: Row(
                    children: [
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
                            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
