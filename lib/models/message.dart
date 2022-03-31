class MessageModel {
  late final bool isSent;
  final String toName;
  final String fromName;
  final String message;

  MessageModel({
    required this.isSent,
    required this.toName,
    required this.fromName,
    required this.message,
  });
}
