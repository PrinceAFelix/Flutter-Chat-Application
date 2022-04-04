import 'package:chat_app/services/database.dart';
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

  final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();

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
            buildPassword(context),
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

  Widget buildPassword(BuildContext context) => SimpleSettingsTile(
        title: 'Change Password',
        subtitle: '',
        leading: IconWidget(icon: Icons.key, color: Colors.black),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Container(
                      height: 300,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  "Change Password",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  validator: (String? value) {
                                    if (value!.isEmpty || value.length < 7) {
                                      return 'Password must be at least 7 characters long';
                                    }
                                    return null;
                                  },
                                  controller: _currentPass,
                                  onSaved: (value) {
                                    _currentPass.text = value!;
                                  },
                                  obscureText: true,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: "Current password",
                                    contentPadding: const EdgeInsets.all(15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  validator: (String? value) {
                                    if (value!.isEmpty || value.length < 7) {
                                      return 'Password must be at least 7 characters long';
                                    }
                                    return null;
                                  },
                                  controller: _newPass,
                                  onSaved: (value) {
                                    _newPass.text = value!;
                                  },
                                  obscureText: true,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: "New password",
                                    contentPadding: const EdgeInsets.all(15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    bool isChange = await Service()
                                        .changePassword(
                                            _currentPass.text, _newPass.text);
                                    if (isChange) {
                                      Navigator.of(context).pop();
                                      Utils.showSnackBar(context,
                                          "Password successfully changed");
                                    } else {
                                      Navigator.of(context).pop();
                                      Utils.showSnackBar(context,
                                          "Error changing password, please check your credentials");
                                    }
                                    _currentPass.clear();
                                    _newPass.clear();
                                  },
                                  child: const Text("Update Password"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey.withOpacity(0.6),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _currentPass.clear();
                                    _newPass.clear();
                                  },
                                  child: const Text("Cancel"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
              });
        },
      );

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
                          var url = '';
                          if (snapshot.hasData) {
                            url =
                                (snapshot.data! as dynamic).docs[0]['imageUrl'];
                          }

                          if (url == "") {
                            url =
                                "https://firebasestorage.googleapis.com/v0/b/chat-app---eng4003-37561.appspot.com/o/images%2FdefaultProfilePicture.png?alt=media&token=6b2d1c22-3de0-4a3a-a1ec-5ed1224604de";
                          }

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
                                    url,
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text(
                                    "Username: ${(snapshot.data! as dynamic).docs[0]['username']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Email: ${(snapshot.data! as dynamic).docs[0]['email']}",
                                    style: TextStyle(
                                        fontSize: 20,
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
                          }
                          return Container();
                        }),
                  ),
                );
              })
        },
      );
}
