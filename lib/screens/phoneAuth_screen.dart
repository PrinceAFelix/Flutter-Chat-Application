import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/auth/phoneAuth_form.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _proccessingAuth = false;
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhoneAuthForm(_proccessingAuth),
    );
  }
}
