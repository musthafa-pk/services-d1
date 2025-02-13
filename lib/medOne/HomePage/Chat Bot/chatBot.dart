import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_one/res/medOneUrls.dart';
import 'dart:convert';

import '../../../res/appUrl.dart';
import '../../Constants/AppColors.dart';


class ChatbotScreen extends StatefulWidget {
  final String? medicineName; // Made nullable

  ChatbotScreen({this.medicineName}); // Optional parameter

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = []; // List of messages to display

  Future<void> sendMessage(String message) async {
    final url = Uri.parse(MedOneUrls.chatbot);
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({"message": message});

    try {
      print('dddddddddddd:$url');
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _messages.add({"message": message, "sender": "user"});

          _messages.add({"message": responseData['message'] ?? "No response", "sender": "bot"});
        });
      } else {
        setState(() {
          _messages.add({"message": "Error: ${response.statusCode}", "sender": "bot"});
        });
      }
    } catch (error) {
      setState(() {
        _messages.add({"message": "Failed to connect to the chatbot", "sender": "bot"});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Automatically search for the medicine name if provided
    if (widget.medicineName != null && widget.medicineName!.isNotEmpty) {
      sendMessage(widget.medicineName!);
    } else {
      setState(() {
        _messages.add({"message": "How can I assist you today?", "sender": "bot"});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Chatbot"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Today",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                return _buildMessageBubble(
                  _messages[index]['message']!,
                  _messages[index]['sender']!,
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  icon: Icon(Icons.send, color: AppColors.primaryColor2),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildMessageBubble(String message, String sender) {
    bool isUser = sender == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: isUser ? AppColors.primaryColor2 : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: isUser ? Radius.circular(16) : Radius.zero,
              bottomRight: isUser ? Radius.zero : Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Text(
            message,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}