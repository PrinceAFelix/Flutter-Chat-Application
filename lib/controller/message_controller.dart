import 'package:chat_app/models/message.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  var messages = List<MessageModel>.empty(growable: true).obs;
  var username = ''.obs;

  void onSend(
      {required String toUsername,
      required String fromUsername,
      required String message}) {
    /// Add the message object received to the messages list
    messages.add(MessageModel(
      isSent: true,
      toName: toUsername,
      fromName: fromUsername,
      message: message,
    ));

    /// This will force a widget rebuild
    update();
  }

  void onReceived({
    required String toUsername,
    required String fromUsername,
    required String message,
  }) async {
    messages.add(MessageModel(
      isSent: false,
      toName: toUsername,
      fromName: fromUsername,
      message: message,
    ));
  }
}
