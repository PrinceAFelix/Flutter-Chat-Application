import 'package:flutter/material.dart';
import 'package:chat_app/models/message.dart';

class ChatBubble extends StatefulWidget {
  final MessageModel message;
  final bool isSent;
  final String username;
  final String user;

  const ChatBubble(
      {Key? key,
      required this.message,
      required this.isSent,
      required this.username,
      required this.user})
      : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double defaultWidth = width * 2 / 3;
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color:
              widget.isSent ? Theme.of(context).primaryColor : Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(10, 10),
              color: Colors.black12,
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: defaultWidth),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              widget.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 5),
            Text(
              widget.message.message,
              style: TextStyle(
                fontSize: 14,
                color: widget.isSent
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                // : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
