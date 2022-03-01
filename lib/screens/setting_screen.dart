import 'package:flutter/material.dart';
import 'package:chat_app/widgets/setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({ Key? key }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {},
      //     icon: Icon(Icons.arrow_left),
      //   ),
      // ),
      body: Settings(ctx: context,),
    );
  }
}