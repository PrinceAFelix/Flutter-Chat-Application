import 'package:chat_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Authentication extends StatefulWidget {
  
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _auth = FirebaseAuth.instance;
  void _sbmtForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    print("works");
    
    try{
      if(isLogin){
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      }else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }
    } on PlatformException catch(pe){
      var outputMessage = 'An error occured while processing the request, please check your credentials';

      if(pe.message != null){
        outputMessage = pe.message!;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(outputMessage),
          backgroundColor: Colors.red,
        )
      );
     } on Exception catch (e){

    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(10),
      //   child: AppBar(
      //     elevation: 0,
      //     centerTitle: true,
      //     flexibleSpace: Container(
      //     margin: EdgeInsets.only(top: 5),
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage("assets/images/logo.png"),
      //         fit: BoxFit.cover,
      //       )
      //     )
      //   ),
      //   backgroundColor: Colors.transparent
      //   ),
      // ),
      
      body: AuthForm(_sbmtForm),
    );
  }
}