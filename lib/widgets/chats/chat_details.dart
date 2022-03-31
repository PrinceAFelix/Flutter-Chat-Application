import 'package:chat_app/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:page_transition/page_transition.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatDetails extends StatefulWidget {
  final String toUid;
  final String toName;
  final String imageURl;
  const ChatDetails(
      {Key? key,
      required this.toUid,
      required this.toName,
      required this.imageURl})
      : super(key: key);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  // ignore: prefer_typing_uninitialized_variables
  var chatId;
  final TextEditingController _messageController = TextEditingController();
  var message = '';

  @override
  void initState() {
    setState(() {});
    super.initState();
    chats
        .where('users', isEqualTo: {widget.toUid: null, currentUid: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            setState(() {
              chatId = snapshot.docs.single.id;
            });
          } else {
            chats.add({
              'users': {currentUid: null, widget.toUid: null}
            }).then((value) => {
                  setState(() {
                    chatId = value;
                  })
                });
          }
        })
        .catchError((e) {});

    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  void unfocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return GestureDetector(
      onTap: () => unfocus(),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(chatId)
            .collection('messages')
            .orderBy('sentOn', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong, please try again later"),
            );
          }
          if (!snapshot.hasData) {
            return Container();
          }

          dynamic data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.leftToRight,
                      child: const MainScreen(),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
              title: Text(
                widget.toName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageURl),
                  ),
                )
              ],
            ),
            body: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListView(
                              reverse: true,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                data = document.data()!;

                                var text = data['message'];
                                return BubbleNormal(
                                  text: text,
                                  isSender: isSender(data['uid'].toString()),
                                  color: isSender(data['uid'].toString())
                                      ? Colors.blue
                                      : Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: isSender(data['uid'].toString())
                                        ? Colors.white
                                        : Colors.black.withOpacity(.8),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      height: 100,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.text,
                              controller: _messageController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                hintText: 'Send a message',
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              style: TextStyle(fontSize: 14),
                              onEditingComplete: () {
                                message = _messageController.text;
                              },
                              onSubmitted: (value) {
                                unfocus();
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              _sendMessage(_messageController.text);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(String msg) {
    FocusScope.of(context).unfocus();
    if (msg == '') {
      return;
    }
    ;

    chats.doc(chatId).collection('messages').add({
      'sentOn': FieldValue.serverTimestamp(),
      'uid': currentUid,
      'message': msg,
    }).then((value) {
      _messageController.text = '';
      _messageController.clear();
    });
    setState(() {});
  }

  bool isSender(String current) {
    return current == currentUid;
    setState(() {});
  }
}
