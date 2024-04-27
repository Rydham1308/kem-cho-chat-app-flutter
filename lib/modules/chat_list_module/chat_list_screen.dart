import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kem_cho/constants/sp_keys.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:kem_cho/modules/chat_list_module/bloc/chat_list_bloc.dart';
import 'package:kem_cho/modules/chat_module/chat_screen_stream.dart';
import 'package:kem_cho/modules/user_list_module/model/chat_id_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  static Widget create() {
    return BlocProvider(
      create: (BuildContext context) {
        return ChatListBloc()..add(GetChatListEvent());
      },
      child: const ChatListScreen(),
    );
  }

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? curName;
  String? curKey;
  int? curUserIndex;

  ChatIdsModel chatIdsModel = ChatIdsModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Kem Cho?'),
        actions: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              // InkWell(
              //   onTap: () {},
              //   child:  SizedBox(
              //     height: 40,
              //     width: 150,
              //     child: Center(
              //       child: Text(
              //         '',
              //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //       ),
              //     ),
              //   ),
              // ),
              // const Divider(),
              InkWell(
                onTap: () async {
                  var sharedPref = await SharedPreferences.getInstance();
                  sharedPref.setBool(AppKeys.keyLogin, false);
                  sharedPref.setString(AppKeys.currentUserKey, '');
                  sharedPref.setString(AppKeys.currentUserId, '');
                  sharedPref.setInt(AppKeys.currentUserIndex, 0);
                  Future.delayed(Duration.zero).then(
                    (value) => Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (Route<dynamic> route) => false),
                  );
                },
                child: const SizedBox(
                  height: 40,
                  width: 150,
                  child: Center(
                    child: Text(
                      'Log Out',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
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
              bottom: -900,
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
            BlocConsumer<ChatListBloc, ChatListState>(
              listener: (context, state) async {},
              builder: (context, state) {
                if (state is ChatListCurrentStates && state.status == Status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatListCurrentStates && state.status == Status.isLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.chatIdsModel?.length ?? 0,
                    // controller: _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                    //     duration: Duration(milliseconds: 300), curve: Curves.elasticOut),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          Future.delayed(Duration.zero).then(
                            (value) => Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    //     ChatScreen.create(
                                    //   state.chatIdsModel?[index]['connectionKey'] ?? '',
                                    // ),
                                    const ChatScreenStream(),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  var begin = const Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeInOut;
                                  var tween =
                                      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                settings: RouteSettings(arguments: {
                                  'name': state.chatIdsModel?[index]['userOneName'] ?? '',
                                  'id': state.chatIdsModel?[index]['userId'] ?? '',
                                  'connectionKey':
                                      state.chatIdsModel?[index]['connectionKey'] ?? '',
                                }),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                          ),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(100),
                                right: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue,
                                      child: Text(
                                        (state.chatIdsModel?[index]['userOneName'] ?? '')[0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(state.chatIdsModel?[index]['userOneName'] ?? '',
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatListCurrentStates && state.status == Status.isError) {
                  return Center(child: Text(state.errorMessage ?? ''));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            //endregion
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/user-list').then(
            (value) => setState(() {
              context.read<ChatListBloc>().add(GetChatListEvent());
            }),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
