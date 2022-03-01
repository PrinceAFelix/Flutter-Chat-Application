import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(24, 119, 242, 1.0)
      ),
      debugShowCheckedModeBanner: false,
      //home: Authentication(),
      //home:  SettingScreen(),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
        if(userSnapshot.hasData){
            return const MainScreen();
            // return SettingScreen();
          }
          return Authentication();
      }),
    );
  }
}
