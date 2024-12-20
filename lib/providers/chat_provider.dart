import 'package:flutter/foundation.dart';
import '../services/socket_service.dart';

class ChatProvider with ChangeNotifier {
  final SocketService _socketService = SocketService();
  String username = '';
  Map<String, List<Map<String, String>>> messages = {};

  void initialize(String senderId, String receiverId) {
    username = senderId;

    _socketService.connect(
      username,
      (users) {
        print("Online Users: $users");
      },
      (sender, message) {
        if (!messages.containsKey(sender)) {
          messages[sender] = [];
        }
        messages[sender]?.add({'sender': sender, 'content': message});
        notifyListeners();
      },
    );
  }

  void sendMessage(String senderId, String receiver, String content) {
    if (!messages.containsKey(receiver)) {
      messages[receiver] = [];
    }
    messages[receiver]?.add({'sender': username, 'content': content});
    notifyListeners();

    _socketService.sendMessage(senderId, receiver, content);
  }
}
