import 'package:flutter/cupertino.dart';
import 'package:rescue/screens/user/ChatDetailScreen.dart';

class ChatMessage {
  String message;
  MessageType type;
  ChatMessage({@required this.message, @required this.type});
}
