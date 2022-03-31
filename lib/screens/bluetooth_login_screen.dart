import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth/bluetooth_login.dart';

class BluetoothLoginScreen extends StatefulWidget {
  const BluetoothLoginScreen({Key? key}) : super(key: key);

  @override
  _BluetoothLoginScreenState createState() => _BluetoothLoginScreenState();
}

class _BluetoothLoginScreenState extends State<BluetoothLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BluetoothLogin(),
    );
  }
}
