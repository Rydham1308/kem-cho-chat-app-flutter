import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kem_cho/constants/sp_keys.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:kem_cho/constants/validation.dart';
import 'package:kem_cho/modules/auth_module/bloc/firebase_auth_bloc.dart';
import 'package:kem_cho/modules/auth_module/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  bool isObscureText = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  UserModel userModel = UserModel();

  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirebaseAuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
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
                      Color(0xff3191FF),
                      Colors.transparent,
                    ],
                    radius: 0.5,
                  ),
                ),
              ),
            ),
            //endregion

            //region -- Main Screen
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //region  --- Image
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: SvgPicture.asset(
                      'assets/images/Illustration.svg',
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                  //endregion

                  const SizedBox(
                    height: 25,
                  ),

                  //region --- TextField & Button
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 52),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Email
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: txtEmail,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Required";
                              } else if (txtEmail.text.isValidEmail == false) {
                                return "Email is not valid";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Enter Your Email',
                              labelStyle: TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),

                          // Gap
                          const SizedBox(
                            height: 16,
                          ),

                          // Password
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: txtPass,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Required";
                              } else if (txtPass.text.isValidPassword == false) {
                                return "Password should include at-least one Capital, Small, Number & Spacial Char.";
                              } else if (value.length < 6) {
                                return "Password should be at-least 6 characters";
                              } else if (value.length > 15) {
                                return "Password should not be greater than 15 characters";
                              } else {
                                return null;
                              }
                            },
                            obscureText: isObscureText,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              labelText: 'Enter Your Password',
                              labelStyle: const TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                              suffixIcon: isObscureText
                                  ? IconButton(
                                      color: const Color.fromARGB(255, 73, 73, 73),
                                      onPressed: () {
                                        setState(() {
                                          isObscureText = false;
                                        });
                                      },
                                      icon: const Icon(CupertinoIcons.eye_slash),
                                    )
                                  : IconButton(
                                      color: const Color.fromARGB(255, 73, 73, 73),
                                      onPressed: () {
                                        setState(() {
                                          isObscureText = true;
                                        });
                                      },
                                      icon: const Icon(CupertinoIcons.eye),
                                    ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),

                          // Gap
                          const SizedBox(
                            height: 8,
                          ),

                          // Forgot Pass
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //endregion
                ],
              ),
            ),
            //endregion
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.165,
          child: Stack(
            children: [
              Positioned(
                left: -7,
                child: Container(
                  height: 388,
                  width: 388,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(255, 49, 145, 255),
                        Color.fromARGB(0, 0, 0, 0),
                      ],
                      radius: 0.7,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: BlocConsumer<FirebaseAuthBloc, FirebaseAuthState>(
                      listener: (context, state) {
                        if (state is FirebaseAuthCurrentStates &&
                            state.status == Status.isRegistered) {
                          Future.delayed(Duration.zero).then(
                              (value) => Navigator.pushReplacementNamed(context, '/chat-list'));
                        } else if (state is FirebaseAuthCurrentStates &&
                            state.status == Status.isError) {
                          Future.delayed(Duration.zero).then(
                            (value) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color(0xd52d2d2d),
                                content: Text(
                                  state.errorMessage ?? '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                duration: const Duration(milliseconds: 1000),
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 20,
                            backgroundColor: Colors.blue,
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                            minimumSize: const Size(double.maxFinite, 48),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                userModel.email = txtEmail.text.trim();
                                userModel.pass = txtPass.text.trim();
                                context
                                    .read<FirebaseAuthBloc>()
                                    .add(UserSignInEvent(json: userModel.toJson()));
                                SharedPreferences sp = await SharedPreferences.getInstance();
                                sp.setString(AppKeys.currentUserKey, txtEmail.text.trim());
                                final db = FirebaseFirestore.instance;
                                final response = await db.collection('user').get();
                                final dataList =
                                    response.docs.map((e) => UserModel.fromJson(e.data())).toList();
                                int? curIndex;
                                for (int i = 0; i < dataList.length; i++) {
                                  if (txtEmail.text.trim() == dataList[i].email) {
                                    curIndex = i;
                                  }
                                }
                                sp.setInt(AppKeys.currentUserIndex, curIndex ?? 0);
                                sp.setString(
                                    AppKeys.currentUserId, dataList[curIndex ?? 0].key ?? '');
                              } catch (e) {}
                            }
                          },
                          child:
                              state is FirebaseAuthCurrentStates && state.status == Status.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account yet?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 163, 163, 163),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            elevation: 0,
                          ),
                          onPressed: () async {
                            Navigator.pushNamed(
                              context,
                              '/register',
                            );
                          },
                          child: const Text(
                            'Register here',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
