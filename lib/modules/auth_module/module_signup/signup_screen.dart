import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kem_cho/constants/status_enum.dart';
import 'package:kem_cho/constants/validation.dart';
import 'package:kem_cho/modules/auth_module/bloc/firebase_auth_bloc.dart';
import 'package:kem_cho/modules/auth_module/model/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscureTextPass = true;
  bool isObscureTextRePass = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtConfPass = TextEditingController();
  TextEditingController txtFName = TextEditingController();
  TextEditingController txtLName = TextEditingController();

  List<String> getUserList = [];
  UserModel userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirebaseAuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: -300,
              left: -300,
              child: Container(
                height: 600,
                width: 600,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(stops: [
                    0.0005,
                    0.8
                  ], colors: [
                    Color(0xff3191FF),
                    Colors.transparent,
                  ], radius: 0.5),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //region  --- Image
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: SvgPicture.asset(
                      'assets/images/Register_SVG.svg',
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
                          //Name & LastName
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Name',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: txtFName,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "* Required";
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Your Name',
                                        labelStyle:
                                            TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Gap
                          const SizedBox(
                            height: 16,
                          ),

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
                            obscureText: isObscureTextPass,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              labelText: 'Enter Your Password',
                              labelStyle: const TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                              suffixIcon: isObscureTextPass
                                  ? IconButton(
                                      color: const Color.fromARGB(255, 73, 73, 73),
                                      onPressed: () {
                                        setState(() {
                                          isObscureTextPass = false;
                                        });
                                      },
                                      icon: const Icon(CupertinoIcons.eye_slash),
                                    )
                                  : IconButton(
                                      color: const Color.fromARGB(255, 73, 73, 73),
                                      onPressed: () {
                                        setState(() {
                                          isObscureTextPass = true;
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
                            height: 16,
                          ),

                          // Confirm Password
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: txtConfPass,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Required";
                              } else if (txtPass.text.isValidPassword == false) {
                                return "Password should include at-least one Capital, Small, Number & Spacial Char.";
                              } else if (value.length < 6) {
                                return "Password should be at-least 6 characters";
                              } else if (value.length > 15) {
                                return "Password should not be greater than 15 characters";
                              } else if (txtConfPass.text != txtPass.text) {
                                return "Password doesn't match.";
                              } else {
                                return null;
                              }
                            },
                            obscureText: isObscureTextRePass,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              labelText: 'Re-Enter Your Password',
                              labelStyle: const TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                              suffixIcon: isObscureTextRePass
                                  ? IconButton(
                                      color: const Color.fromARGB(255, 73, 73, 73),
                                      onPressed: () {
                                        setState(() {
                                          isObscureTextRePass = false;
                                        });
                                      },
                                      icon: const Icon(CupertinoIcons.eye_slash),
                                    )
                                  : IconButton(
                                      color: const Color.fromARGB(255, 73, 73, 73),
                                      onPressed: () {
                                        setState(() {
                                          isObscureTextRePass = true;
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
                        ],
                      ),
                    ),
                  ),
                  //endregion
                ],
              ),
            ),
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
                          // Add User details to db
                          final db = FirebaseFirestore.instance;
                          db.collection('user').doc('${userModel.name}${userModel.key}').set(userModel.toJson());

                          //pop
                          Future.delayed(Duration.zero).then((value) => Navigator.pop(context));
                          Future.delayed(Duration.zero).then(
                            (value) => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0xd52d2d2d),
                                content: Text(
                                  "User Registered!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(milliseconds: 1000),
                              ),
                            ),
                          );


                        } else if (state is FirebaseAuthCurrentStates &&
                            state.status == Status.isFailed) {
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
                              userModel.email = txtEmail.text.trim();
                              userModel.pass = txtPass.text.trim();
                              userModel.name = txtFName.text.trim();
                              userModel.key = Random().nextInt(10000000).toString();
                              userModel.chatIds = [];
                              context
                                  .read<FirebaseAuthBloc>()
                                  .add(UserRegisterEvent(json: userModel.toJson()));
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
                                      'Register',
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
                          'Already have an account?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 163, 163, 163),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign in',
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
