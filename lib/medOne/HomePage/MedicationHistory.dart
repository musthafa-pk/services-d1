import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_one/res/appUrl.dart';
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../../../res/appurl.dart';
import '../Constants/AppColors.dart';
import '../MedOneConstants.dart';
import '../MedOneWidgets/customWidgets.dart';

class MedicationHistories extends StatefulWidget {
  const MedicationHistories({super.key});

  @override
  State<MedicationHistories> createState() => _MedicationHistoriesState();
}

class _MedicationHistoriesState extends State<MedicationHistories> {
  List<Map<String, dynamic>> medications = []; // Store fetched medication data
  bool isLoading = true; // Loading state
  bool showRetry = false; // State for showing retry button

  @override
  void initState() {
    super.initState();
    fetchMedicationHistory(); // Fetch medication history on widget initialization
    _loadUserName();
  }
  String userName = '';
  Future<void> _loadUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString("username") ?? 'No user name found';
    });
  }

  String _getFirstLetter() {
    if (userName.isNotEmpty && userName != 'No user name found') {
      return userName[0].toUpperCase();
    }
    return '?';
  }
  Future<void> fetchMedicationHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');

    if (userId == null) {
      setState(() {
        isLoading = false;
        showRetry = true; // Show retry button
      });
      showErrorFlushbar('User ID is missing. Please log in again.');
      return;
    }

    final url = Uri.parse(MedOneUrls.medicationHistory); // Your API endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}), // Your request body
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          if (data['data'] != null && data['data'] is List) {
            setState(() {
              medications = List<Map<String, dynamic>>.from(
                (data['data'] as List).map((med) {
                  return {
                    'name': med['status'],
                    'medicinename': med['medicinename'],
                    'status': med['takenStatus'] == 'Yes' ? 'Taken' : 'Skipped',
                    'date': DateFormat('yyyy-MM-dd').format(DateTime.parse(med['createdDate'])),
                    'time': med['takenTime'] ?? 'N/A',
                    'color': med['takenStatus'] == 'Yes'
                        ? AppColors.containercolorgreen
                        : AppColors.containercolorRed,
                  };
                }),
              ).reversed.toList(); // Reverse the list to show latest first
              isLoading = false; // Update loading state
              showRetry = false; // Hide retry button
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showErrorFlushbar('No medication history available.');
          }
        } else {
          setState(() {
            isLoading = false;
          });
          showErrorFlushbar(data['message']);
        }
      } else {
        setState(() {
          isLoading = false;
          showRetry = true; // Show retry button
        });
        showErrorFlushbar('Failed to fetch medication history');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        showRetry = true; // Show retry button
      });
      showErrorFlushbar('An error occurred: $e');
    }
  }

  void showErrorFlushbar(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.pageColor,
        leading: Dronewidgets.backButton(context),
        actions: [
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: CircleAvatar(backgroundColor: AppColors.primaryColor2,
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                  // );
                },
                child:
                Text( "S",style: text40018,),
                // Text( "_getFirstLetter()",style: text40018,),
              ),
            ),
          ),
        ],
        title: const Text(
          'Medication history',
          style: text40016black,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : medications.isEmpty
          ? const Center(
        child: Text(
          'No medication history available.',
          style: text40014black,
        ),
      )
          : ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 10.0),
            child: Container(
              height: 115,
              width: double.infinity,
              decoration: BoxDecoration(
                color: medication['color'],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(medication['name'],
                              style: text40018black),
                          Text(
                            medication['status'],
                            style: medication['status'] == 'Skipped'
                                ? text60014red
                                : text60014green,
                          ),
                        ],
                      ),
                      Text(
                        'Medicine: ${medication['medicinename']}',
                        style: text40014black,
                      ),
                      Text(
                        'Taken on ${medication['date']}',
                        style: text40012black,
                      ),
                      Text(
                        'Time: ${medication['time']}',
                        style: text40012black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: showRetry
          ? FloatingActionButton(
        onPressed: fetchMedicationHistory,
        child: const Icon(Icons.refresh),
      )
          : null,
    );
  }
}