import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> chatMessages = [];
  bool isTyping = false;

  Future<void> sendMessage(String message) async {
    setState(() {
      chatMessages.add("You: $message");
      isTyping = true;
    });

    final ngrokUrl = "https://9b5a-35-189-47-57.ngrok-free.app/";

    try {
      final response = await http.post(
        Uri.parse(ngrokUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'input_text': message}),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        String reply = result['data'];

        // Simulate typing delay
        await Future.delayed(Duration(seconds: 1));

        setState(() {
          chatMessages.add("$reply");
          isTyping = false;
        });
      } else {
        print("Error: ${response.statusCode} ${response.body}");
        setState(() {
          chatMessages.add("Bot replied nothing");
          isTyping = false;
        });
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 187, 187, 187)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: chatMessages[index].startsWith("You")
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: chatMessages[index].startsWith("You")
                            ? Color.fromARGB(255, 50, 50, 50)
                            : Color.fromARGB(188, 3, 69, 224),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        chatMessages[index],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                      _messageController.clear();
                    }
                  },
                ),
                isTyping ? CircularProgressIndicator() : SizedBox(),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatPage(),
    theme: ThemeData.dark(),
  ));
}
