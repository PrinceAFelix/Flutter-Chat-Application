import 'package:chat_app/controller/message_controller.dart';
import 'package:chat_app/models/advertiser.dart';
import 'package:chat_app/models/browser.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/bluetooth_login_screen.dart';
import 'package:chat_app/screens/devices_screen.dart';
import 'package:chat_app/widgets/chats/messages.dart';
import 'package:chat_app/widgets/chats/new_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:page_transition/page_transition.dart';

class MessageScreen extends StatefulWidget {
  final String username;
  final String user;
  MessageModel messageModel;
  final MessageController messageController;
  final Device device;
  final DeviceType deviceType;
  final NearbyService nearbyService;
  final Advertiser advertiserModel;
  final Browser browserModel;
  final bool isBrowser;
  final BuildContext context;
  MessageScreen(
      {
      //required Key key,
      required this.messageModel,
      required this.messageController,
      required this.username,
      required this.user,
      required this.device,
      required this.deviceType,
      required this.nearbyService,
      required this.advertiserModel,
      required this.browserModel,
      required this.isBrowser,
      required this.context}); //: super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var messagesSent = List<String>.empty(growable: true);
  var messagesSent1 = List<String>.empty(growable: true);

  // MessageModel model = MessageModel(isSent: true, toName: "john", fromName: "Doe", message: "HAHAHHA");
  @override
  Widget build(BuildContext context) {
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
                child: const BluetoothLoginScreen(),
              ),
            );
          },
        ),
        title: Text(
          widget.isBrowser
              ? widget.advertiserModel.advertiserGivenName
              : widget.browserModel.browserGivenName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
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
                      padding: const EdgeInsets.only(top: 0),
                      child: Messages(
                        username: widget.username,
                        user: widget.user,
                        messageModel: widget.messageModel,
                        messageController: widget.messageController,
                        isSent: false,
                        deviceContext: context,
                        device: widget.device,
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
                child: NewMessage(
                  messageModel: widget.messageModel,
                  nearbyService: widget.nearbyService,
                  device: widget.device,
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
  }
}
