import 'package:chat_app/controller/message_controller.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chats/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Messages extends StatefulWidget {
  final String username;
  final String user;
  final MessageModel messageModel;
  final MessageController messageController;
  final bool isSent;
  final BuildContext deviceContext;
  final Device device;
  const Messages(
      {Key? key,
      required this.username,
      required this.user,
      required this.messageModel,
      required this.messageController,
      required this.isSent,
      required this.deviceContext,
      required this.device})
      : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final ScrollController _scrollController = ScrollController();

  // MessageModel model = MessageModel(isSent: true, toName: "John", fromName: "Doe", message: "Hi, Test Message Bubble");

  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  static late List<MessageModel> msg = List<MessageModel>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    MessageModel(fromName: "d", isSent: false, message: "hi", toName: "g");
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Flexible(
              child: GetX<MessageController>(
                init: MessageController(),
                builder: (controller) {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((_) => _scrollToBottom());

                  var conversation = widget.messageController.messages.toList();

                  return Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            reverse: false,
                            controller: _scrollController,
                            itemCount: conversation.length,
                            itemBuilder: (BuildContext context, index) {
                              msg.add(conversation[index]);
                              return ChatBubble(
                                message: conversation[index],
                                isSent: widget.isSent,
                                username: widget.username,
                                user: widget.user,
                              );
                            }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
