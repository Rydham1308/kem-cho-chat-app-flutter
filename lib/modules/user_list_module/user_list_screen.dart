import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kem_cho/constants/sp_keys.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:kem_cho/modules/auth_module/model/user_model.dart';
import 'package:kem_cho/modules/user_list_module/model/chat_id_model.dart';
import 'package:kem_cho/modules/user_list_module/bloc/user_list_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  static Widget create() {
    return BlocProvider(
      create: (BuildContext context) {
        return UserListBloc()..add(GetUserListEvent());
      },
      child: const UserListScreen(),
    );
  }

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String? curName;
  String? curKey;
  int? curUserIndex;

  @override
  void initState() {
    super.initState();
  }

  ChatIdsModel chatIdsModel = ChatIdsModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('User List'),
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
            BlocConsumer<UserListBloc, UserListState>(
              listener: (context, state) async {
                if (state is UserListCurrentStates) {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  String? currentEmail = sp.getString(AppKeys.currentUserKey);

                  // get current user details
                  for (int i = 0; i < (state.userList?.length ?? 0); i++) {
                    if (currentEmail == state.userList?[i].email) {
                      curKey = state.userList?[i].key;
                      curName = state.userList?[i].name;
                      curUserIndex = i;
                      break;
                    }
                  }

                }
              },
              builder: (context, state) {
                if (state is UserListCurrentStates && state.status == Status.isLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.userList?.length,
                    // controller: _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                    //     duration: Duration(milliseconds: 300), curve: Curves.elasticOut),
                    itemBuilder: (context, index) {
                      return curUserIndex == index
                          ? const SizedBox.shrink()
                          : Padding(
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
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.blue,
                                          child: Text(
                                            (state.userList?[index].name ?? '')[0],
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(state.userList?[index].name ?? '',
                                          style: const TextStyle(fontSize: 18)),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          // data request from firebase
                                          final db = FirebaseFirestore.instance;
                                          final response = await db.collection('user').get();
                                          final dataList = response.docs
                                              .map((e) => UserModel.fromJson(e.data()))
                                              .toList();

                                          //stored chatIds in local
                                          List<Map<String, dynamic>>? chatIdsCurUserList =
                                              dataList[curUserIndex ?? 0].chatIds;
                                          List<Map<String, dynamic>>? chatIdsIndexList =
                                              dataList[index].chatIds;

                                          // data add in model class
                                          // chatIdsModel.userOneId = curKey;
                                          // chatIdsModel.userOneName = curName;
                                          // chatIdsModel.userTwoId = state.userList?[index].key ?? '';
                                          // chatIdsModel.userTwoName = state.userList?[index].name ?? '';
                                          chatIdsModel.connectionKey =
                                              '${Random().nextInt(1000000)}';

                                          // check if there is some data
                                          bool isAvailForCurr = false;
                                          bool isAvailForIndexed = false;
                                          for (int i = 0;
                                              i < (chatIdsCurUserList?.length ?? 0);
                                              i++) {
                                            if (chatIdsCurUserList?[i]['userOneName'] ==
                                                state.userList?[index].name) {
                                              isAvailForCurr = true;
                                              break;
                                            }
                                          }
                                          for (int i = 0;
                                              i < (chatIdsIndexList?.length ?? 0);
                                              i++) {
                                            if (chatIdsIndexList?[i]['userOneName'] == curName) {
                                              isAvailForIndexed = true;
                                              break;
                                            }
                                          }

                                          //data add in firestore
                                          if (!isAvailForIndexed) {
                                            chatIdsModel.userOneName = curName;
                                            chatIdsModel.userOneId = curKey;
                                            chatIdsIndexList?.add(chatIdsModel.toJson());

                                            db
                                                .collection('user')
                                                .doc(
                                                    '${state.userList?[index].name}${state.userList?[index].key}')
                                                .update({"chatIds": chatIdsIndexList});
                                            chatIdsIndexList?.clear();
                                          }

                                          if (!isAvailForCurr) {
                                            chatIdsModel.userOneName =
                                                state.userList?[index].name ?? '';
                                            chatIdsModel.userOneId =
                                                state.userList?[index].key ?? '';
                                            chatIdsCurUserList?.add(chatIdsModel.toJson());

                                            db
                                                .collection('user')
                                                .doc('$curName$curKey')
                                                .update({"chatIds": chatIdsCurUserList});
                                          }
                                          Future.delayed(Duration.zero).then(
                                            (value) => Navigator.pop(context),
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                          ),
                                          child: const Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                  );
                } else if (state is UserListCurrentStates && state.status == Status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserListCurrentStates && state.status == Status.isError) {
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
    );
  }
}
