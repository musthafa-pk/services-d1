import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/res/appUrl.dart';
import 'package:doctor_one/utils/utils.dart';
import 'package:doctor_one/views/splash/submit_success.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BasicDetailTherapy extends StatefulWidget {
  List<Map<String, dynamic>>? location;
  String? age;
  String? gender;
  String? pincode;
  BasicDetailTherapy({
    this.location,
    this.age,
    this.gender,
    this.pincode,
    Key? key}) : super(key: key);
  @override
  _BasicDetailTherapyState createState() => _BasicDetailTherapyState();
}

class _BasicDetailTherapyState extends State<BasicDetailTherapy> {



  Future<void> createphysio() async {
    // API endpoint
    final String url = AppUrl.addphysiotherapy;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? serviceID = preferences.getInt('service_id');
    String? userName = preferences.getString('userName');
    String? userPhone = preferences.getString('userPhone');

    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    // Address in the required format
    // List<Map<String, dynamic>> addressList = [
    //   {
    //     "address": "${widget.location}",
    //     "latitude": "11.6006613",
    //     "longitude": "75.583897"
    //   }
    // ];

    // Request payload
    final Map<String, dynamic> payload = {
      "id":serviceID,
      "patient_name": "${userName}",
      "patient_contact_no": "${userPhone}",
      "patient_gender": "${widget.gender}",
      "patient_age": "${widget.age}",
      "start_date": "${formattedDate}",
      "patient_location": widget.location,
      "pincode":int.parse(widget.pincode.toString()),
      "prefered_time": "${Util.formatTimeOfDay(selectedTime)}",
      "therapy_type":"${selectedTherapy.toString().toLowerCase()}"
    };

    try {
      print('helooo:$payload');
      // Make POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Handle response
      if (response.statusCode == 200) {
        // Success
        var responseData = jsonDecode(response.body);
        Util.toastMessage('${responseData['message']}');
        print("Patient created successfully: ${response.body}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SubmitSuccess()),
        );
      } else {
        // Error
        var responseData = jsonDecode(response.body);
        Util.toastMessage('${responseData['message']}');
        print("Failed to create patient. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      // Exception handling
      print("Error occurred: $e");
    }
  }




  final List<Map<String, String>> listOfTherapy = [
      {
        "name": "Orthopedic",
        "description": "Focuses on treating musculoskeletal injuries and conditions."
      },
      {
        "name": "Neurological",
        "description": "Designed for patients with nervous system disorders like stroke or Parkinson’s."
      },
      {
        "name": "Pediatric",
        "description": "Helps children improve mobility, strength, and coordination."
      },
      {
        "name": "Geriatric",
        "description": "Aimed at older adults to maintain mobility and reduce pain."
      },
      {
        "name": "Sports",
        "description": "Focuses on injury prevention and rehabilitation for athletes."
      },
      {
        "name": "Women’s Health",
        "description": "Addresses issues like prenatal/postnatal care and pelvic health."
      },
      {
        "name": "Other",
        "description": "Covers specialized therapies outside standard categories."
      }

  ];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedTherapy;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Basic\nDetails',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Date Field
              const Text(
                'Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: "${selectedDate.toLocal()}".split(' ')[0]),
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Select date',
                  filled: true,
                  fillColor: primaryColor2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // Preferred Time Field
              const Text(
                'Preferred time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: "${selectedTime.format(context)}"),
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: InputDecoration(
                  hintText: 'Enter preferred time',
                  filled: true,
                  fillColor: primaryColor2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                  suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // Therapy Type Dropdown
              const Text(
                'Therapy Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedTherapy,
                items: listOfTherapy.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['name'],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          type['description'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedTherapy = value;
                },
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: primaryColor2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return listOfTherapy.map((type) {
                    return Text(
                      type['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }).toList();
                },
              ),
              const SizedBox(height: 20),
              Spacer(),

              // Submit Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle submit action
                      createphysio();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
