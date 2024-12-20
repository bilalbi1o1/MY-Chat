import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  /// Connect to the server with a phone number
  void connect(String phoneNumber, Function(List<String>) onUserUpdate,
      Function(String, String) onMessageReceived) {
    // Initialize the socket connection
    socket = IO.io(
      'http://192.168.100.7:5000', // Replace with your server IP
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket as transport
          .enableAutoConnect() // Auto-connect to the server
          .setReconnectionAttempts(3) // Retry connection 3 times on failure
          .setReconnectionDelay(2000) // Wait 2 seconds between retries
          .setQuery(
              {'phone_number': phoneNumber}) // Attach phone number as query
          .build(),
    );

    // Event: Successful connection
    socket.onConnect((_) => print('Connected'));

    // Event: Receive updated user list
    socket.on('update_users', (data) {
      final users = List<String>.from(data['users']);
      onUserUpdate(users); // Pass the user list to the provided callback
    });

    // Event: Receive new message
    socket.on('new_message', (data) {
      final sender = data['sender'];
      final message = data['message'];
      onMessageReceived(sender, message); // Pass sender and message to callback
    });

    // Event: Disconnected from the server
    socket.onDisconnect((_) => print('Disconnected'));

    // Event: Connection error
    socket.onConnectError((error) => print('Connection Error: $error'));

    // Event: General socket error
    socket.onError((error) => print('Socket Error: $error'));

    // Event: Message acknowledgment
    socket.on('message_acknowledgment', (data) {
      final status = data['status'];
      final receiver = data['receiver'];
      print('Message to $receiver: $status'); // Log acknowledgment status
    });

    // Connect the socket
    socket.connect();
  }

  /// Send a message to a specific receiver
  void sendMessage(String senderId, String receiver, String message) {
    socket.emit('send_message', {
      'sender': senderId, // Sender's phone number
      'receiver': receiver, // Recipient's phone number
      'message': message, // Message content
    });
  }

  /// Disconnect from the server
  void disconnect() {
    socket.disconnect();
    print('Socket disconnected');
  }
}
