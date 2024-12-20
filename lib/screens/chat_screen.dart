import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import 'package:intl/intl.dart'; // Import intl package for DateFormat

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  ChatScreen({required this.senderId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Get the ChatProvider instance
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // Initialize the chatProvider with senderId and receiverId (phone numbers)
    if (chatProvider.username.isEmpty) {
      chatProvider.initialize(widget.senderId, widget.receiverId);
    }
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose of the scroll controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the ChatProvider instance
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chatting with ${widget.receiverId}'),
        elevation: 2,
        shadowColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatProvider.messages[widget.receiverId]?.length ?? 0,
              itemBuilder: (context, index) {
                final message =
                    chatProvider.messages[widget.receiverId]![index];
                final timestamp = DateFormat('HH:mm').format(DateTime.now());
                final deliveryStatus = message['status'] ?? 'Pending';

                return Column(
                  crossAxisAlignment: message['sender'] == chatProvider.username
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    MessageBubble(
                      message: message['content']!,
                      isMine: message['sender'] == chatProvider.username,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                      child: Row(
                        mainAxisAlignment:
                            message['sender'] == chatProvider.username
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Text(
                            timestamp,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            deliveryStatus,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = _messageController.text.trim();
                    if (content.isNotEmpty) {
                      chatProvider.sendMessage(
                          widget.senderId, widget.receiverId, content);
                      _messageController.clear();

                      // Scroll to the bottom when a message is sent
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
