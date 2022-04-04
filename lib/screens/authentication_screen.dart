import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var _proccessingAuth = false;
  Service service = Service();

  // Service service = new Service(email, password, username, ctx);

  Future _sbmtForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _proccessingAuth = true;
      });
      if (isLogin) {
        service.loginUser(ctx, email, password, username);
      } else {
        service.signupUser(ctx, email, password, username);
      }
    } on FirebaseException catch (fe) {
      service.showErrorMessage(ctx, fe);
      setState(() {
        _proccessingAuth = false;
      });
    } catch (e) {
      service.showErrorMessage(ctx, e);
      setState(() {
        _proccessingAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_sbmtForm, _proccessingAuth),
    );
  }
}
