import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/devices_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BluetoothLogin extends StatefulWidget {
  const BluetoothLogin({Key? key}) : super(key: key);

  @override
  State<BluetoothLogin> createState() => _BluetoothLoginState();
}

class _BluetoothLoginState extends State<BluetoothLogin> {
  bool isReady = false;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            padding: const EdgeInsets.only(top: 50.0, right: 0, left: 50),
            child: Column(
              children: <Widget>[
                Row(
                  children: const [
                    Text(
                      'Chats',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    SizedBox(
                      width: 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.5),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: Column(
                children: [
                  isReady
                      ? const SizedBox(
                          height: 0.0,
                        )
                      : const SizedBox(
                          height: 50.0,
                        ),
                  isReady
                      ? Expanded(
                          child: Card(child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return Container(
                                height: 120.0,
                                child: Card(
                                  margin: const EdgeInsets.all(20),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: const <Widget>[
                                        Text("Test User"),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text("Username")
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                        )
                      : Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Form(
                                  key: _formkey,
                                  child: Container(
                                    width: 300.0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 60.0,
                                          width: 400,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: TextField(
                                              key: const ValueKey("username"),
                                              // onChanged: loginController.onChange,
                                              controller: _usernameController,
                                              keyboardType: TextInputType.text,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                hintText: "Enter your username",
                                                contentPadding:
                                                    const EdgeInsets.all(15.0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                        ..shade200,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              onSubmitted: (value) {
                                                FocusManager
                                                    .instance.primaryFocus!
                                                    .unfocus();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.0),
                                              child: Container(
                                                width: 130.0,
                                                height: 45.0,
                                                child: ButtonTheme(
                                                  child: MaterialButton(
                                                    elevation: 0,
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          curve: Curves.linear,
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:
                                                              DevicesListSCreen(
                                                            deviceType:
                                                                DeviceType
                                                                    .browser,
                                                            chatterName:
                                                                _usernameController
                                                                    .text,
                                                            isBrowser: true,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    child: const Text(
                                                      "Search Users",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Container(
                                                width: 130.0,
                                                height: 45.0,
                                                child: ButtonTheme(
                                                  child: MaterialButton(
                                                    elevation: 0,
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          curve: Curves.linear,
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:
                                                              DevicesListSCreen(
                                                            deviceType:
                                                                DeviceType
                                                                    .advertiser,
                                                            chatterName:
                                                                _usernameController
                                                                    .text,
                                                            isBrowser: false,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    child: const Text(
                                                      "Advertise Users",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 300,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                curve: Curves.linear,
                                                type: PageTransitionType.fade,
                                                child: const Authentication(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Go Back Online",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
