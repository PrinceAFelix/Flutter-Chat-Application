import 'package:chat_app/screens/main_screen.dart';
import 'package:chat_app/widgets/common/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ScreenLogo extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isSetting;
  const ScreenLogo(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.isSetting})
      : super(key: key);

  @override
  _ScreenLogoState createState() => _ScreenLogoState();
}

class _ScreenLogoState extends State<ScreenLogo> {
  double logoHW = 0.0;

  String imageUrl = '';
  bool isSet = false;

  var currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    //To Create Responsive application
    if (widget.screenHeight == 568 && widget.screenWidth == 320) {
      //Ipod Touch, 5, 6, 7Gen, Iphone 5C, 5S, 5
      logoHW = 0.45;
    } else if (widget.screenHeight == 736 && widget.screenWidth == 414) {
      //Iphone 8 Plus
      logoHW = 0.48;
    } else if (widget.screenHeight == 667 && widget.screenWidth == 375) {
      //Iphone 8, 7, 6s, 6, SE //Iphone 13 mini, 12 mini, 11 pro, XS, X
      logoHW = 0.49;
    } else if (widget.screenHeight == 844 && widget.screenWidth == 390 ||
        widget.screenHeight == 896 && widget.screenWidth == 414 ||
        widget.screenHeight == 926 && widget.screenWidth == 428) {
      //Iphpne 13, 13 Pro, 12, 12 Pro //Iphone 11 Pro Malszx, 11, XR, XS Max
      logoHW = 0.41;
    } else if (widget.screenHeight == 812 && widget.screenWidth == 375) {
      logoHW = 0.41;
    }
    return widget.isSetting
        ? Container(
            height: MediaQuery.of(context).size.height * logoHW,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: -30,
                    right: -30,
                    bottom: 0,
                    child: Image.asset("assets/images/logo.png")),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 50.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.linear,
                            type: PageTransitionType.topToBottom,
                            child: const MainScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      iconSize: 50.0,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: UserProfile(
                          onFileChanged: (imageUrl, isSet) {
                            setState(() {
                              this.imageUrl = imageUrl;
                              this.isSet = isSet;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("emailusers")
                          .where('email', isEqualTo: currentUser)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Text(
                                (snapshot.data! as dynamic).docs[0]["username"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.white),
                              )
                            : const Text(
                                "username",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.white),
                              );
                      },
                    ),
                  ],
                ),

                //UserName
              ],
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * logoHW,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: -30,
                  right: -30,
                  bottom: 0,
                  child: Image.asset("assets/images/logo.png"),
                )
              ],
            ),
          );
  }
}
