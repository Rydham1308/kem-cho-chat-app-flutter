import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kem_cho/modules/auth_module/module_login/login_screen.dart';
import 'package:kem_cho/modules/auth_module/module_signup/signup_screen.dart';
import 'package:kem_cho/modules/auth_module/module_splash/splash_screen.dart';
import 'package:kem_cho/modules/chat_module/chat_screen.dart';
import 'package:kem_cho/modules/chat_list_module/chat_list_screen.dart';
import 'package:kem_cho/modules/user_list_module/user_list_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Kem Cho?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'MundialRegular',
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const Login(),
        '/register': (context) => const RegisterScreen(),
        '/chat-list': (context) => ChatListScreen.create(),
        '/user-list': (context) =>  UserListScreen.create(),
        '/chat': (context) => const ChatScreen(),
        // '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}
