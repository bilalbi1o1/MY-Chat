import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Import ChatScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Sender and Receiver IDs"),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _senderController,
              decoration: InputDecoration(
                labelText: 'Sender ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _receiverController,
              decoration: InputDecoration(
                labelText: 'Receiver ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final senderId = _senderController.text.trim();
                final receiverId = _receiverController.text.trim();

                if (senderId.isNotEmpty && receiverId.isNotEmpty) {
                  // Navigate to ChatScreen with sender and receiver IDs
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        senderId: senderId,
                        receiverId: receiverId,
                      ),
                    ),
                  );
                } else {
                  // Show a warning if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter both IDs")),
                  );
                }
              },
              child: Text("Start Chat"),
            ),
          ],
        ),
      ),
    );
  }
}
