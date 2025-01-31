import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:services/constants/constants.dart';
import 'package:services/res/appUrl.dart';
import 'package:services/utils/utils.dart';
import 'package:services/views/splash/submit_success.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Additional extends StatefulWidget {
  String type;
  final String? selectedType;
  String? age;
  String? gender;
  DateTime? basicDate;
  String? dayNight;
  String? gen_speci;
  String? mobility;
  String? location;

  Additional({
    required this.type,
    this.selectedType,
    this.age,
    this.gender,
    this.basicDate,
    this.dayNight,
    this.gen_speci,
    this.mobility,
    this.location,
    super.key});
  @override
  _AdditionalState createState() => _AdditionalState();
}

class _AdditionalState extends State<Additional> {
  final TextEditingController _requirementsController = TextEditingController();
  File? _selectedFile;

  // Function to pick a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });

      // Optionally open the file after selecting
      OpenFile.open(result.files.single.path);
    }
  }

  // Function to handle file upload
  Future<void> _uploadFile(BuildContext context) async {
    if (widget.selectedType == "Specialized") {
      // For Specialized type, both fields are mandatory
      if (_requirementsController.text.isEmpty) {
        Util.toastMessage('Please fill in the additional requirements...!');
        return;
      }
      if (_selectedFile == null) {
        Util.toastMessage('Please select a file to upload...!');
        return;
      }
    }

    // If General type, no validations
    Util.toastMessage('Processing...!');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubmitSuccess()),
    );
  }

// Function to send the POST request
  Future<void> uploaddata() async {
    // URL of your backend APIS
    String url = AppUrl.addhomeservice;
    final url2 = AppUrl.hospitalasistenquiryData; // Replace with your API URL

    // Patient data to send
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('user_id');
    String? userName = preferences.getString('userName');
    String? userPhone = preferences.getString('userPhone');
    final Map<String, dynamic> homeData = {
      "id": userID,
      "patient_mobility":"${widget}",
      "patient_name": "${userName}",
      "patient_age": "${int.parse(widget.age.toString())}",
      "paitent_gender": "${widget.gender}",
      "patient_contact_no": "${userPhone}",
      "patient_location":"${widget.location}",
      "start_date":"${widget.basicDate}",
      "days_week": "${widget.dayNight}",
      "general_specialized": "${widget.gen_speci}",
    "requirements":"${_requirementsController.text}",
    "documents":"$_selectedFile"
    };

    final Map<String,dynamic> hospitalData = {
    "id":userID,
    "type":"",
    "patient_mobility":"${widget.mobility}",
    "patient_name":"${userName}",
    "patient_age":"${widget.age}",
    "paitent_gender":"${widget.gender}",
    "hospital_name":"",
    "patient_contact_no":"${userPhone}",
    "patient_location":"",
    "assist_type":"",
    "location":"",
    "start_date":"",
    "time":"",
    "days_week":"",
    "hospital_location":"",
    "pickup_type":"",
    "requirements":"${_requirementsController.text}",
    "documents": "$_selectedFile"
    };

    try {
      // Send POST request with the patient data
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: json.encode(homeData), // Convert the Map to JSON
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Successful response
        print('Patient data successfully sent!');
        print('Response: ${response.body}');
        var responseData = jsonDecode(response.body);
        Util.toastMessage('${responseData['message']}');
      } else {
        // Failed request
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any error during the request
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Additional Information'),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Don’t Worry\nWe Almost Done",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Medical care or treatment that does not require an overnight stay at a hospital or medical facility.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "You have any additional requirements?",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _requirementsController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: primaryColor2,
                          hintText: "Enter your requirements",
                          suffixIcon: Icon(
                            Icons.edit,
                            color: Colors.grey.shade700,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "You have any Documents to Upload?",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Pick file",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Selected File: ${basename(_selectedFile!.path)}",
                            style: const TextStyle(fontSize: 14, color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    _uploadFile(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Finish",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
