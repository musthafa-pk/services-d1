import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/res/appUrl.dart';
import 'package:services/utils/utils.dart';
import 'package:services/views/gender.dart';
import 'package:http/http.dart' as http;
import 'package:services/views/mobility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  final String type;
  const Homepage({required this.type, super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode nameNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode nextNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> postPatientData(String name, String contactNo,String type) async {
    String apiUrl = AppUrl.hospitalasistenquiry; // Replace with your API endpoint
    String apiUrl2 = AppUrl.addhomeServiceenquiry; // Replace with your API endpoint
    String apiUrl3 = AppUrl.physiotherapyenquiry; // Replace with your API endpoint
    final Map<String, String> requestBody = {
      "patient_name": name,
      "patient_contact_no": contactNo,
    };

    try {
      final response = await http.post(
        Uri.parse(type=='A' ?apiUrl2:type == 'B' ? apiUrl :apiUrl3 ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('response Data :${responseData}');
        int userId = int.parse(responseData['data']['id'].toString()); // Extract user_id from the response
        print('ssss:$userId');
        // Store user_id in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);
        await prefs.setString('userName', name);
        await prefs.setString('userPhone', contactNo);
        print('stored data is :${prefs.getInt('user_id')}');
        print('stored data is :${prefs.getString('userName')}');
        print('stored data is :${prefs.getString('userPhone')}');

        Util.toastMessage('${responseData['message']}');
        if(widget.type == "A"){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PatientMobilityPage(type: widget.type,),));
        }else
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Gender(type: widget.type),
          ),
        );
        print('Data posted successfully: ${response.body}');
      } else {
        var responseData = jsonDecode(response.body);
        Util.toastMessage('${responseData['message']}');
        print('Failed to post data. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 40, width: 37, child: Image.asset('assets/images/logo.png')),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor2,
                      border: Border.all(width: 1, color: primaryColor),
                      borderRadius: BorderRadius.circular(31),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8, right: 21, bottom: 8, left: 21),
                      child: Text('Services'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome to ${widget.type == "A" ? 'Home Care' : widget.type == "B" ? 'Hospital' : 'physiotherapi'}\nAssistant',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/images/firsticon.png'),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Patient Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: primaryColor2),
                        child: TextFormField(
                          controller: nameController,
                          focusNode: nameNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            Util.fieldFocusChange(context, nameNode, phoneNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the patient\'s name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Contact Number'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: primaryColor2),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          focusNode: phoneNode,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            Util.fieldFocusChange(context, phoneNode, nextNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the contact number';
                            } else if (value.length != 10) {
                              return 'Contact number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Focus(
                        focusNode: nextNode,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              postPatientData(nameController.text, phoneController.text,widget.type);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
