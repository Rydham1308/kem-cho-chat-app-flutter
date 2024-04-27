import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kem_cho/constants/sp_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();

    whereToGO();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: -7,
              top: -230,
              child: Container(
                height: 388,
                width: 388,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    stops: [0.0005, 0.8],
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/chat.gif',
                  scale: 3,
                ),
                const SizedBox(height: 25,),
                const Text(
                  'Kem Cho?',
                  style: TextStyle(fontSize: 35),
                ),
              ],
            ),
            Positioned(
              left: -7,
              bottom: -250,
              child: Container(
                height: 388,
                width: 388,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    stops: [0.0005, 0.8],
                    colors: [
                      Color.fromARGB(255, 49, 145, 255),
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                    radius: 0.7,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void whereToGO() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(AppKeys.keyLogin);

    Timer(const Duration(milliseconds: 1500), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.popAndPushNamed(context, '/chat-list');
        } else {
          Navigator.popAndPushNamed(context, '/login');
        }
      } else {
        Navigator.popAndPushNamed(context, '/login');
      }
    });
  }
}
