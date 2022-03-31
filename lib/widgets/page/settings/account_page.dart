import 'package:chat_app/utils.dart';
import 'package:chat_app/widgets/common/icon_widget.dart';
import 'package:chat_app/widgets/common/round_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AccountPage extends StatelessWidget {
  static const keyLanguage = 'key-language';
  static const keyLocation = 'key-location';
  static const keyPassword = 'key-password';

  @override
  Widget build(BuildContext context) => SimpleSettingsTile(
        title: 'Account',
        subtitle: 'Privacy, Security, Language',
        leading: IconWidget(icon: Icons.person, color: Colors.green),
        child: SettingsScreen(
          title: 'Account Settings',
          children: <Widget>[
            buildLanguage(),
            buildLocation(),
            buildPassword(),
            buildPrivacy(context),
            buildSecurity(context),
            buildAccountInfo(context),
          ],
        ),
      );

  Widget buildLanguage() => DropDownSettingsTile(
        settingKey: keyLanguage,
        title: 'Language',
        selected: 1,
        values: <int, String>{
          1: 'English',
          2: 'French',
        },
        onChange: (language) {
          /* In progress*/
        },
      );

  Widget buildLocation() => TextInputSettingsTile(
        settingKey: keyLocation,
        title: 'Location',
        initialValue: 'Canada',
        onChange: (location) {/* In progress */},
      );

  Widget buildPassword() {
    return Column(
      children: [
        TextInputSettingsTile(
          settingKey: keyPassword,
          title: 'Password',
          obscureText: true,
          validator: (password) => password != null && password.length >= 8
              ? null
              : 'Enter 8 characters',
        ),
        TextInputSettingsTile(
          settingKey: keyPassword,
          title: 'Password',
          obscureText: true,
          validator: (password) => password != null && password.length >= 8
              ? null
              : 'Enter 8 characters',
        )
      ],
    );
  }

  Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
        title: 'Privacy',
        subtitle: '',
        leading: IconWidget(icon: Icons.lock, color: Colors.blue),
        onTap: () => Utils.showSnackBar(context, 'Clicked Privacy'),
      );

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
        title: 'Security',
        subtitle: '',
        leading: IconWidget(icon: Icons.security, color: Colors.red),
        onTap: () => Utils.showSnackBar(context, 'Clicked Security'),
      );

  Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
        title: 'Account Info',
        subtitle: '',
        leading: IconWidget(icon: Icons.text_snippet, color: Colors.purple),
        onTap: () => {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                    height: 300,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("emailusers")
                            .where('email',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AppRoundImage.url(
                                    (snapshot.data! as dynamic).docs[0]
                                        ['imageUrl'],
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text(
                                    "Username: ${(snapshot.data! as dynamic).docs[0]['username']}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Email: ${(snapshot.data! as dynamic).docs[0]['email']}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Close"),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Text("No Info to Show");
                          }
                        }),
                  ),
                );
              })
        },
      );
}
