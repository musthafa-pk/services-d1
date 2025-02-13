import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyFeedback extends StatefulWidget {
  const MyFeedback({super.key});

  @override
  State<MyFeedback> createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {
  Future<List<Map<String, dynamic>>> fetchFeedback() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');
    final url = Uri.parse(MedOneUrls.getAddedFeedback); // Replace with actual API URL
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": int.parse(userId.toString())}), // Use the correct `userId`
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['data'] != null && responseData['data'].isNotEmpty) {
        final List data = responseData['data'];
        return data
            .map<Map<String, dynamic>>((entry) => {
          "id": entry['id'],
          "medicineId": entry['medicineId'],
          "feedback": entry['feedback']
              .map((fb) => fb['feedback'])
              .toList(), // Extract feedback array
          "createdDate": entry['createdDate'],
        })
            .toList();
      } else {
        throw Exception("No feedback found.");
      }
    } else {
      throw Exception("Failed to load feedback");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Feedback"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFeedback(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No feedback found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final feedbackList = snapshot.data!;
            return ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedbackEntry = feedbackList[index];
                final feedbackMessages = feedbackEntry['feedback'] as List;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        feedbackEntry['medicineId'].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      "Medicine ID: ${feedbackEntry['medicineId']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        feedbackMessages.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: feedbackMessages.map<Widget>((fb) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text("- $fb"),
                            );
                          }).toList(),
                        )
                            : const Text("No feedback available."),
                        const SizedBox(height: 8),
                        Text(
                          "Date: ${feedbackEntry['createdDate']}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}