import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class NewMessage extends StatefulWidget {
  final MessageModel messageModel;
  final NearbyService nearbyService;
  final Device device;
  const NewMessage({
    Key? key,
    required this.messageModel,
    required this.nearbyService,
    required this.device,
  }) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _messageController = TextEditingController();
  var message = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
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
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                hintText: 'Send a message',
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              style: const TextStyle(fontSize: 14),
              onEditingComplete: () {
                message = _messageController.text;
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ClipOval(
            child: Material(
              borderRadius: BorderRadius.circular(50),
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).buttonColor.withOpacity(0.4),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    splashColor: Colors.greenAccent[400],
                    highlightColor: Colors.greenAccent[400],
                    icon: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      widget.nearbyService.sendMessage(
                          widget.device.deviceName, _messageController.text);
                      _messageController.clear();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
