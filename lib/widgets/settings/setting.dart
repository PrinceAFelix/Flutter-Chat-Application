import 'package:chat_app/widgets/page/settings/account_page.dart';
import 'package:chat_app/widgets/page/settings/notifications_page.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/common/icon_widget.dart';

import 'package:chat_app/widgets/common/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:page_transition/page_transition.dart';

class Settings extends StatefulWidget {
  final BuildContext ctx;

  const Settings({Key? key, required this.ctx}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _isOpen3 = false;
  var _isOpen4 = false;

  var platformResponse = '';

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Service service = Service();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white.withOpacity(1),
        body: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              ScreenLogo(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isSetting: true),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: 370.0,
                height: 310.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 5.0)
                  ],
                  //border: Border.all(width: 5, color: Colors.red),
                ),
                child: ListView(children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SettingsGroup(
                              title: 'GENERAL',
                              children: <Widget>[
                                AccountPage(),
                                buildMessages(),
                                const NotificationsPage(),
                                //buildDeleteAccount(),
                              ],
                            ),
                            const SizedBox(height: 5),
                            SettingsGroup(
                              title: 'FEEDBACK',
                              children: <Widget>[
                                const SizedBox(height: 3),
                                buildSendFeedback(context),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SettingsGroup(
                              title: 'SUPPORT',
                              children: <Widget>[
                                const SizedBox(height: 8),
                                buildContactUs(context),
                              ],
                            ),
                            SettingsGroup(
                              title: 'ABOUT',
                              children: <Widget>[
                                const SizedBox(height: 8),
                                buildAboutUs(context),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ]),
              ),
              const SizedBox(
                height: 70,
              ),
              ButtonTheme(
                  minWidth: 300,
                  height: 50,
                  child: MaterialButton(
                    elevation: 5,
                    onPressed: () async {
                      Service().setUserStatus("Offline", true);
                      service.signoutUser(context);
                    },
                    color: Colors.white,
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail(context) async {
    var recipient = ["flupcprogrammers@gmail.com"];
    final Email email = Email(
      body: _firstnameController.text +
          _lastnameController.text +
          _messageController.text,
      subject: _subjectController.text,
      recipients: recipient,
      isHTML: false,
      attachmentPaths: null,
    );

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (e) {
      platformResponse = e.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  Widget buildMessages() => SimpleSettingsTile(
      title: 'Messages',
      subtitle: '',
      leading: const IconWidget(icon: Icons.message, color: Colors.blueAccent),
      onTap: () => Navigator.push(
            context,
            PageTransition(
              curve: Curves.linear,
              type: PageTransitionType.leftToRight,
              child: const MainScreen(),
            ),
          ));

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
        title: 'Send Feedback',
        subtitle: '',
        leading: const IconWidget(icon: Icons.thumb_up, color: Colors.purple),
        onTap: () => {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                      height: 300,
                      child: ListView(children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      "We value your feedback",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text("Was the app responsive"),
                                  RatingBar.builder(
                                    initialRating: 5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text("How well was messages online"),
                                  RatingBar.builder(
                                    initialRating: 5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text("How well was messages offline"),
                                  RatingBar.builder(
                                    initialRating: 5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text("Would you recommend this app?"),
                                  RatingBar.builder(
                                    initialRating: 5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                      "Overall, how would you rate this app"),
                                  RatingBar.builder(
                                    initialRating: 5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isOpen4 = !_isOpen4;
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("Send"),
                            )
                          ],
                        ),
                      ])),
                );
              })
        },
      );

  Widget buildAboutUs(BuildContext context) => SimpleSettingsTile(
        title: 'About us',
        subtitle: '',
        leading: const IconWidget(icon: Icons.info, color: Colors.purple),
        onTap: () => {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Com Tool",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            "assets/images/appicon.png",
                            height: 100,
                          ),
                          Text(
                            "Com Tool is a Firebase based chat application that can communicate using internet connection or bluetooth nearby location",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black.withOpacity(0.8)),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isOpen4 = !_isOpen4;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("Close"),
                          )
                        ],
                      )),
                );
              })
        },
      );

  Widget buildContactUs(BuildContext context) => SimpleSettingsTile(
        title: 'Contact Us',
        subtitle: '',
        leading: const IconWidget(icon: Icons.contact_page, color: Colors.teal),
        onTap: () => {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 110,
                                    height: 50,
                                    child: TextField(
                                      controller: _firstnameController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'First Name'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 110,
                                    height: 50,
                                    child: TextField(
                                      controller: _lastnameController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Last Name'),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 50,
                                child: TextField(
                                  controller: _subjectController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Subject'),
                                ),
                              ),
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: _messageController,
                                    decoration: const InputDecoration.collapsed(
                                        hintText: 'Enter your concerns'),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isOpen3 = !_isOpen3;
                                  });

                                  sendEmail(context);

                                  if (platformResponse == 'success') {
                                    _firstnameController.clear();
                                    _lastnameController.clear();
                                    _messageController.clear();
                                    _subjectController.clear();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text("Send"),
                              )
                            ],
                          ),
                        ),
                      )),
                );
              })
        },
      );
}
