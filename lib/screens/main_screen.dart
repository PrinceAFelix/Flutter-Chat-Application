import 'package:chat_app/screens/setting_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/chats/chat_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../widgets/common/round_image.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool isMessage = true;
  var _currentIndex = 0;
  var currentUser = FirebaseAuth.instance.currentUser!.email;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String defaultProfile =
      "https://firebasestorage.googleapis.com/v0/b/chat-app---eng4003-37561.appspot.com/o/images%2FdefaultProfilePicture.png?alt=media&token=6b2d1c22-3de0-4a3a-a1ec-5ed1224604de";
  var url = '';

  @override
  void initState() {
    super.initState();
    Service().setUserStatus("Online", true);
    WidgetsBinding.instance!.addObserver(this);
  }

  void setStatus(String status) async {
    await _firestore
        .collection('emailusers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status': status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            padding: EdgeInsets.only(top: 50.0, right: 0, left: 50),
            child: Column(
              children: <Widget>[
                Row(
                  children: const <Widget>[
                    Text(
                      'Chats',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    SizedBox(
                      width: 150,
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
                  ]),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("emailusers")
                              .where('email', isEqualTo: currentUser)
                              .snapshots(),
                          builder: (context, snapshot) {
                            var url = '';
                            if (snapshot.hasData) {
                              url = (snapshot.data! as dynamic).docs[0]
                                  ["imageUrl"];
                            }
                            if (url == "") {
                              url = defaultProfile;
                            }
                            return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      curve: Curves.linear,
                                      type: PageTransitionType.bottomToTop,
                                      child: const SettingScreen(),
                                    ),
                                  );
                                },
                                child: AppRoundImage.url(url,
                                    height: 60, width: 60));
                          },
                        ),
                        const SizedBox(
                          width: 95,
                        ),
                        Text(
                          _currentIndex == 0 ? 'Com Tool' : '  People',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        if (_currentIndex == 0)
                          IconButton(
                            icon: const Icon(
                              Icons.open_in_new_rounded,
                              color: Colors.blue,
                              size: 40,
                            ),
                            onPressed: () {},
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: isMessage == false
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "No Messages",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "New messages will appear here",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: _currentIndex == 0
                                  ? FirebaseFirestore.instance
                                      .collection("emailusers")
                                      .where('email', isNotEqualTo: currentUser)
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection("emailusers")
                                      .where('status', isEqualTo: "Online")
                                      .snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.data != null
                                    ? ListView.builder(
                                        itemCount: (snapshot.data as dynamic)
                                            .docs
                                            .length,
                                        itemBuilder: (context, index) {
                                          var name = (snapshot.data! as dynamic)
                                              .docs[index]["username"];
                                          var uid = (snapshot.data! as dynamic)
                                              .docs[index]["uid"];

                                          return Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 400,
                                                  height: 90,
                                                  // decoration: BoxDecoration(
                                                  //   borderRadius: BorderRadius.circular(20),
                                                  //   border: Border.all(color: Colors.black)
                                                  // ),
                                                  child: Column(
                                                    children: [
                                                      ButtonTheme(
                                                        minWidth: 400,
                                                        height: 80,
                                                        child: MaterialButton(
                                                          elevation: 0,
                                                          // onPressed: (){},
                                                          onPressed: () =>
                                                              startUserChat(
                                                                  context,
                                                                  name,
                                                                  uid,
                                                                  url),
                                                          color: _currentIndex ==
                                                                  0
                                                              ? Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors.white,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                                children: [
                                                                  StreamBuilder(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "emailusers")
                                                                        .where(
                                                                            'email',
                                                                            isNotEqualTo:
                                                                                currentUser)
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snbapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        url = (snapshot.data!
                                                                                as dynamic)
                                                                            .docs[index]["imageUrl"];
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          isMessage =
                                                                              false;
                                                                        });
                                                                      }
                                                                      if (url ==
                                                                          "") {
                                                                        url =
                                                                            defaultProfile;
                                                                      }

                                                                      return AppRoundImage.url(
                                                                          url,
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              60);
                                                                    },
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                    child: Text(
                                                                      (snapshot.data!
                                                                              as dynamic)
                                                                          .docs[index]["username"],
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 200,
                                                                  ),
                                                                  _currentIndex ==
                                                                          1
                                                                      ? Container(
                                                                          width:
                                                                              15,
                                                                          height:
                                                                              15,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        )
                                                                      : const Text(
                                                                          ""),
                                                                ]),
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side: BorderSide(
                                                                color: _currentIndex ==
                                                                        0
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text(
                                          "No active users",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            if (_currentIndex == 0) {
              setState(() {});
            }
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.chat_bubble_rounded),
              title: const Text("Chats"),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.people),
              title: const Text("People"),
              selectedColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }

  void startUserChat(
      BuildContext context, String name, String uid, String url) {
    Navigator.push(
      context,
      PageTransition(
        curve: Curves.linear,
        type: PageTransitionType.rightToLeft,
        child: ChatDetails(toUid: uid, toName: name, imageURl: url),
      ),
    ).then((value) => setState(() {
          this.url = url;
        }));
  }
}
