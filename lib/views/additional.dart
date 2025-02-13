import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/res/appUrl.dart';
import 'package:doctor_one/utils/utils.dart';
import 'package:doctor_one/views/splash/submit_success.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//
// class Additional extends StatefulWidget {
//   String type;final String? selectedType;String? age;String? gender;DateTime? basicDate;String? dayNight;String? gen_speci;String? mobility;String? location;String? hospital_name;String? hospital_location;String? hospital_time;String? home_location;String? pickup;String? inoutpatient;
//
//   Additional({
//     required this.type, this.selectedType, this.age, this.gender, this.basicDate, this.dayNight, this.gen_speci, this.mobility, this.location, this.hospital_name, this.hospital_location, this.hospital_time, this.home_location, this.inoutpatient, this.pickup, super.key});
//   @override
//   _AdditionalState createState() => _AdditionalState();
// }
// class _AdditionalState extends State<Additional> {
//   final TextEditingController _requirementsController = TextEditingController();
//   File? _selectedFile;
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path!);
//       });
//       // Optionally open the file after selecting
//       // OpenFile.open(result.files.single.path);
//     }
//   }
//   Future<void> _uploadFile(BuildContext context) async {
//     if (widget.selectedType == "Specialized") {
//       if (_requirementsController.text.isEmpty) {
//         Util.toastMessage('Please fill in the additional requirements...!');
//         return;
//       }
//       if (_selectedFile == null) {
//         Util.toastMessage('Please select a file to upload...!');
//         return;
//       }
//     }
//     Util.toastMessage('Processing...!');
//     try {
//       bool success = await uploaddata();
//       if (success) {
//         // Navigate only on successful API response
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SubmitSuccess()),
//         );
//       }
//     } catch (e) {
//       Util.toastMessage('An error occurred during submission');
//     }
//   }
//   Future<bool> uploaddataworking() async {
//     print('🚀 Uploading data...');
//     print('Type is: ${widget.type}');
//
//     String url = AppUrl.addhomeservice;
//     String url2 = AppUrl.hospitalasistenquiryData;
//
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int? userID = preferences.getInt('user_id');
//     String? userName = preferences.getString('userName');
//     String? userPhone = preferences.getString('userPhone');
//
//     String formattedDate = DateFormat('dd-MM-yyyy').format(widget.basicDate!);
//
//     List<Map<String, dynamic>> addressList = [
//       {
//         "address": widget.location,
//         "latitude": "11.6006613",
//         "longitude": "75.583897"
//       }
//     ];
//
//     // 🏡 Home Service Data
//     Map<String, dynamic> homeData = {
//       "id": userID,
//       "patient_mobility": widget.mobility.toString().toLowerCase(),
//       "patient_name": userName,
//       "patient_age": widget.age,
//       "patient_gender": widget.gender.toString().toLowerCase(),
//       "patient_contact_no": userPhone,
//       "patient_location": addressList,
//       "start_date": formattedDate,
//       "days_week": widget.dayNight,
//       "general_specialized": widget.gen_speci.toString().toLowerCase(),
//       "requirements": _requirementsController.text,
//     };
//
//     // 🏥 Hospital Assistance Data
//     Map<String, dynamic> hospitalData = {
//       "id": userID,
//       "patient_mobility": widget.mobility.toString().toLowerCase(),
//       "patient_name": userName,
//       "patient_age": widget.age,
//       "patient_gender": widget.gender.toString().toLowerCase(),
//       "hospital_name": widget.hospital_name,
//       "patient_contact_no": userPhone,
//       "patient_location": addressList,
//       "assist_type": widget.inoutpatient,
//       "start_date": formattedDate, // ✅ Ensures correct "dd-MM-yyyy" format
//       "time": widget.hospital_time,
//       "days_week": widget.dayNight,
//       "hospital_location": widget.hospital_location,
//       "pickup_type": widget.pickup,
//       "requirements": _requirementsController.text,
//       "customer_id": userID,
//       "pincode": "123456",
//       "no_of_days": ""
//     };
//
//     // 🌐 Choose the right URL & data
//     bool isHomeService = widget.type == "A";
//     String selectedUrl = isHomeService ? url : url2;
//     Map<String, dynamic> requestData = isHomeService ? homeData : hospitalData;
//     print('📦 Final data being sent: ${jsonEncode(hospitalData)}');
//
//     print('📦 Data being sent: ${jsonEncode(requestData)}');
//     print('🌍 URL: $selectedUrl');
//
//     var request = http.MultipartRequest("POST", Uri.parse(selectedUrl));
//
//     // ✅ Send the correct JSON data
//     request.fields['data'] = jsonEncode(requestData);
//
//     // 📸 Add image if selected
//     if (_selectedFile != null) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'images',
//         _selectedFile!.path,
//       ));
//     }
//
//     try {
//       print('🚀 Sending request...');
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       print('📝 Response: ${response.body}');
//
//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);
//         Util.toastMessage(responseData['message']);
//         return true;
//       } else {
//         print('❌ Failed to send data. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('⚠️ Error: $e');
//       Util.toastMessage('Network error. Please try again.');
//       return false;
//     }
//   }
//   Future<bool> uploaddata() async {
//     print('🚀 Uploading data...');
//     print('Type is: ${widget.type}');
//     String url = AppUrl.addhomeservice;
//     String url2 = AppUrl.hospitalasistenquiryData;
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int? userID = preferences.getInt('user_id');
//     String? userName = preferences.getString('userName');
//     String? userPhone = preferences.getString('userPhone');
//     String formattedDate = DateFormat('dd-MM-yyyy').format(widget.basicDate!);
//     List<Map<String, dynamic>> addressList = [
//       {
//         "address": widget.location,
//         "latitude": "11.6006613",
//         "longitude": "75.583897"
//       }
//     ];
//     Map<String, dynamic> homeData = {
//       "id": userID,
//       "patient_mobility": widget.mobility.toString().toLowerCase(),
//       "patient_name": userName,
//       "patient_age": widget.age,
//       "patient_gender": widget.gender.toString().toLowerCase(),
//       "patient_contact_no": userPhone,
//       "patient_location": addressList,
//       "start_date": formattedDate,
//       "days_week": widget.dayNight,
//       "general_specialized": widget.gen_speci.toString().toLowerCase(),
//       "requirements": _requirementsController.text,
//     };
//     Map<String, dynamic> hospitalData = {
//       "id": userID,
//       "patient_mobility": widget.mobility.toString().toLowerCase(),
//       "patient_name": userName,
//       "patient_age": widget.age,
//       "patient_gender": widget.gender.toString().toLowerCase(),
//       "hospital_name": widget.hospital_name,
//       "patient_contact_no": userPhone,
//       "patient_location": addressList, // ✅ Proper JSON array format
//       "assist_type": widget.inoutpatient,
//       "start_date": formattedDate, // ✅ Ensures correct date format
//       "time": widget.hospital_time,
//       "days_week": widget.dayNight,
//       "hospital_location": widget.hospital_location,
//       "pickup_type": widget.pickup,
//       "requirements": _requirementsController.text,
//       "customer_id": userID,
//       "pincode": "123456",
//       "no_of_days": ""
//     };
//     // 🌐 Choose URL & Data
//     bool isHomeService = widget.type == "A";
//     String selectedUrl = isHomeService ? url : url2;
//     Map<String, dynamic> requestData = isHomeService ? homeData : hospitalData;
//
//     // ✅ Print final data before sending
//     print('📦 Final data being sent: ${jsonEncode(requestData)}');
//     print('🌍 API URL being used: $selectedUrl');
//
//     var request = http.MultipartRequest("POST", Uri.parse(selectedUrl));
//
//     // ✅ Send the correct JSON data
//     request.fields['data'] = jsonEncode(requestData);
//
//     // 📸 Add image if selected
//     if (_selectedFile != null) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'images',
//         _selectedFile!.path,
//       ));
//     }
//
//     try {
//       print('🚀 Sending request...');
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       print('📝 Response Status: ${response.statusCode}');
//       print('📝 Response Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);
//         print('✅ Success! Response Data: $responseData');
//         Util.toastMessage(responseData['message']);
//         return true;
//       } else {
//         print('❌ Failed to send data. Status code: ${response.statusCode}');
//         print('🔍 Response body: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('⚠️ Error: $e');
//       Util.toastMessage('Network error. Please try again.');
//       return false;
//     }
//   }
//
//
//
//   // Future<bool> uploaddata2() async {
//   //   String url = AppUrl.addhomeservice;
//   //   String url2 = AppUrl.hospitalasistenquiryData;
//   //
//   //   SharedPreferences preferences = await SharedPreferences.getInstance();
//   //   int? userID = preferences.getInt('user_id');
//   //   String? userName = preferences.getString('userName');
//   //   String? userPhone = preferences.getString('userPhone');
//   //
//   //   String formattedDate = DateFormat('dd-MM-yyyy').format(widget.basicDate!);
//   //
//   //   List<Map<String, dynamic>> addressList = [
//   //     {
//   //       "address": widget.location,
//   //       "latitude": "11.6006613",
//   //       "longitude": "75.583897"
//   //     }
//   //   ];
//   //   // String addressJson = (addressList);
//   //
//   //   Map<String, dynamic> homeData = {
//   //     "id": userID,
//   //     "patient_mobility": widget.mobility.toString().toLowerCase(),
//   //     "patient_name": userName,
//   //     "patient_age": widget.age,
//   //     "patient_gender": widget.gender.toString().toLowerCase(),
//   //     "patient_contact_no": userPhone,
//   //     "patient_location": addressList,
//   //     "start_date": formattedDate,
//   //     "days_week": widget.dayNight,
//   //     "general_specialized": widget.gen_speci.toString().toLowerCase(),
//   //     "requirements": _requirementsController.text,
//   //   };
//   //
//   //   final Map<String,dynamic> hospitalData = {
//   //   "id":userID,
//   //   // "type":"",
//   //   "patient_mobility":"${widget.mobility }",
//   //   "patient_name":"${userName}",
//   //   "patient_age":"${widget.age}",
//   //   "paitent_gender":"${widget.gender}",
//   //   "hospital_name":"${widget}",
//   //   "patient_contact_no":"${userPhone}",
//   //   "patient_location":"${widget}",
//   //   "assist_type":"${widget.selectedType}",
//   //   "location":"${widget.location}",
//   //   "start_date":"${widget.basicDate}",
//   //   "time":"${widget.hospital_time}",
//   //   "days_week":"${widget.dayNight}",
//   //   "hospital_location":"${widget.hospital_location}",
//   //   "pickup_type":"${widget.pickup}",
//   //   "requirements":"${_requirementsController.text}",
//   //   "documents": "$_selectedFile"
//   //   };
//   //
//   //   var request = http.MultipartRequest("POST", Uri.parse("${widget.type == "A" ?url:url2}"));
//   //
//   //   // Add JSON data
//   //   request.fields['data'] = jsonEncode("${widget.type == "A" ?homeData:hospitalData}");
//   //
//   //   // Add file if selected
//   //   if (_selectedFile != null) {
//   //     request.files.add(await http.MultipartFile.fromPath(
//   //       'images',
//   //       _selectedFile!.path,
//   //     ));
//   //   }
//   //
//   //   try {
//   //     var streamedResponse = await request.send();
//   //     var response = await http.Response.fromStream(streamedResponse);
//   //
//   //     print('Response: ${response.body}');
//   //
//   //     print('sssssss${request.fields}');
//   //
//   //     if (response.statusCode == 200) {
//   //       var responseData = jsonDecode(response.body);
//   //       Util.toastMessage(responseData['message']);
//   //       return true;
//   //     } else {
//   //       print('Failed to send data. Status code: ${response.statusCode}');
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     print('Error: $e');
//   //     Util.toastMessage('Network error. Please try again.');
//   //     return false;
//   //   }
//   // }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Additional Information'),
//       ),
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Don’t Worry\nWe Almost Done",
//                         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Medical care or treatment that does not require an overnight stay at a hospital or medical facility.",
//                         style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "You have any additional requirements?",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: _requirementsController,
//                         maxLines: 4,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: primaryColor2,
//                           hintText: "Enter your requirements",
//                           suffixIcon: Icon(
//                             Icons.edit,
//                             color: Colors.grey.shade700,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide(
//                               color: primaryColor,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide(
//                               color: primaryColor,
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         "You have any Documents to Upload?",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: _pickFile,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Pick file",
//                                 style: TextStyle(color: Colors.white, fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (_selectedFile != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             "Selected File: ${basename(_selectedFile!.path)}",
//                             style: const TextStyle(fontSize: 14, color: Colors.green),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             ElevatedButton(onPressed: ()async{
//               final Map<String,dynamic> hospitalData = {
//                 // "id":userID,
//                 // "type":"",
//                 "patient_mobility":"${widget.mobility }",
//                 // "patient_name":"${userName}",
//                 "patient_age":"${widget.age}",
//                 "patient_gender":"${widget.gender}",
//                 "hospital_name":"${widget.hospital_name}",
//                 // "patient_contact_no":"${userPhone}",
//                 // "patient_location":"${addressList}",
//                 "assist_type":"${widget.selectedType}",
//                 "location":"${widget.location}",
//                 "start_date":"${widget.basicDate}",
//                 "time":"${widget.hospital_time}",
//                 "days_week":"${widget.dayNight}",
//                 "hospital_location":"${widget.hospital_location}",
//                 "pickup_type":"${widget.pickup}",
//                 "requirements":"${_requirementsController.text}",
//                 // "documents": "$_selectedFile"
//               };
//               print('${hospitalData}');
//             }, child: Text('Test')),
//             // Bottom button
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     _uploadFile(context);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     decoration: BoxDecoration(
//                       color: primaryColor,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         "Finish",
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Additional extends StatefulWidget {
  final String type;
  final String? selectedType;
  final String? age;
  final String? gender;
  final DateTime? basicDate;
  final String? dayNight;
  final String? gen_speci;
  final String? mobility;
  final List<Map<String, dynamic>>? location;
  final String? hospital_name;
  final List<Map<String, dynamic>>? hospital_location;
  final TimeOfDay? hospital_time;
  final  List<Map<String, dynamic>>? home_location;
  final String? pickup;
  final String? inoutpatient;
  final String? customeDays;
  final String? pincode;

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
    this.hospital_name,
    this.hospital_location,
    this.hospital_time,
    this.home_location,
    this.inoutpatient,
    this.pickup,
    this.customeDays,
    this.pincode,
    super.key,
  });

  @override
  _AdditionalState createState() => _AdditionalState();
}

class _AdditionalState extends State<Additional> {
  final TextEditingController _requirementsController = TextEditingController();
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Limit to images
      withData: false, // Avoid loading file data into memory
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile(BuildContext context) async {
    if (widget.selectedType == "Specialized") {
      if (_requirementsController.text.isEmpty) {
        Util.toastMessage('Please fill in the additional requirements...!');
        return;
      }
      if (_selectedFile == null) {
        Util.toastMessage('Please select a file to upload...!');
        return;
      }
    }
    Util.toastMessage('Processing...!');
    try {
      bool success = widget.type == "A" ? await _sendHomeData() : await _sendHospitalData();
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubmitSuccess()),
        );
      }
    } catch (e) {
      Util.toastMessage('An error occurred during submission');
    }
  }

  Future<void> _uploadFileB(BuildContext context) async {
    print('upload file B is working....');
    if (widget.selectedType == "Specialized") {
      if (_requirementsController.text.isEmpty) {
        Util.toastMessage('Please fill in the additional requirements...!');
        return;
      }
      if (_selectedFile == null) {
        Util.toastMessage('Please select a file to upload...!');
        return;
      }
    }
    Util.toastMessage('Processing...!');
    try {
      bool success =  await _sendHospitalData();
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubmitSuccess()),
        );
      }
    } catch (e) {
      Util.toastMessage('An error occurred during submission');
    }
  }

  Future<bool> _sendHomeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    int? serviceID = preferences.getInt('service_id');
    String? userName = preferences.getString('userName');
    String? userPhone = preferences.getString('userPhone');

    String formattedDate = DateFormat('dd-MM-yyyy').format(widget.basicDate!);

    // List<Map<String, dynamic>> addressList = [
    //   {
    //     "address": widget.location,
    //     "latitude": "11.6006613",
    //     "longitude": "75.583897"
    //   }
    // ];

    Map<String, dynamic> homeData = {
      "id": serviceID,
      "patient_mobility": widget.mobility.toString().toLowerCase(),
      "patient_name": userName,
      "patient_age": widget.age,
      "patient_gender": widget.gender.toString().toLowerCase(),
      "patient_contact_no": userPhone,
      "patient_location":widget.location,
      "start_date": formattedDate,
      "days_week": widget.dayNight,
      "general_specialized": widget.gen_speci.toString().toLowerCase(),
      "requirements": _requirementsController.text,
    };

    return await _sendRequest(AppUrl.addhomeservice, homeData);
  }

  Future<bool> _sendHospitalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userName = preferences.getString('userName');
    String? userPhone = preferences.getString('userPhone');
    int? userID = preferences.getInt('userId');
    int? serviceID = preferences.getInt('service_id');
    print('service id :$serviceID');
    String daysss = 'day';

    print('mobility :${widget.mobility.toString().toLowerCase()}');
    print('username:${userName.toString()}');
    print('age :${widget.age.toString().toLowerCase()}');
    print('gender :${widget.gender.toString().toLowerCase()}');
    print('hospital name:${widget.hospital_name.toString()}');
    print('userphone :${userPhone.toString()}');
    print('homelocation :${widget.home_location}');
    print('inoutpatient :${widget.inoutpatient.toString()}');
    // print('my hospital data :${formattedDate.toString()}');
    print('hospital time :${_formatTime(widget.hospital_time).toString()}');
    print('days :${daysss}');
    print('hospitallocation :${widget.hospital_location}');
    print('pickup :${ widget.pickup.toString()}');
    print('requirement :${_requirementsController.text}');
    print('userid :${int.parse(userID.toString())}');
    print('pincode:${int.parse(widget.pincode.toString())}');
    print('sending hospital data');

    // String formattedDate = DateFormat('dd-MM-yyyy').format(widget.basicDate!);
    // List<Map<String, dynamic>> addressList = [
    //   {
    //     "address": widget.location,
    //     "latitude": "11.6006613",
    //     "longitude": "75.583897"
    //   }
    // ];

    Map<String, dynamic> hospitalData ={
      "id": serviceID,
      "patient_mobility": widget.mobility.toString().toLowerCase(),
      "patient_name": userName.toString(),
      "patient_age": widget.age.toString().toLowerCase(),
      "patient_gender": widget.gender.toString().toLowerCase(),
      "hospital_name": widget.hospital_name.toString(),
      "patient_contact_no": userPhone.toString(),
      "patient_location": jsonEncode(widget.home_location),
      "assist_type": widget.inoutpatient.toString().toLowerCase(),
      "start_date": "05-02-2025",
      "end_date": "10-02-2025",
      // "time": _formatTime(widget.hospital_time).toString(),
      "time": "10:55 AM",
      "days_week": '${daysss}',
      "pincode": int.parse(widget.pincode.toString()),
      "hospital_location": jsonEncode(widget.hospital_location),
      "pickup_type": 'door_to_door',
      "requirements": '${_requirementsController.text}',
      "customer_id": int.parse(userID.toString()),
      // "start_date": "formattedDate.toString()",
      // "no_of_days": widget.customeDays
    };

    print('url is :${AppUrl.hospitalasistenquiryData}');
    print('body data is :$hospitalData');

    return await _sendRequest(AppUrl.hospitalasistenquiryData, hospitalData);
  }

  // Future<bool> _sendRequest(String url, Map<String, dynamic> data) async {
  //   print('Sending request to URL: $url');
  //   print('Request data: ${jsonEncode(data)}');
  //   var request = http.MultipartRequest("POST", Uri.parse(url));
  //
  //   // Set headers for multipart request
  //   request.headers.addAll({
  //     "Content-Type": "multipart/form-data",
  //   });
  //
  //   // Attach file if available
  //   if (_selectedFile != null) {
  //     var multipartFile = await http.MultipartFile.fromPath(
  //       'image',
  //       _selectedFile!.path,
  //     );
  //     request.files.add(multipartFile);
  //   }
  //
  //   // request.fields['data'] = jsonEncode(data);
  //
  //   // if (_selectedFile != null) {
  //   //   request.files.add(await http.MultipartFile.fromPath(
  //   //     'images',
  //   //     _selectedFile!.path,
  //   //   ));
  //   // }
  //
  //   try {
  //
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //
  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);
  //       Util.toastMessage(responseData['message']);
  //       return true;
  //     } else {
  //       print('Failed to send data. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       Util.toastMessage('Error: ${response.body}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     Util.toastMessage('Network error. Please try again.');
  //     return false;
  //   }
  // }

  Future<bool> _sendRequest(String url, Map<String, dynamic> data) async {
    print('Sending request to URL: $url');
    print('Request data: ${jsonEncode(data)}');

    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Set headers for multipart request
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
      });

      // Attach JSON data correctly
      request.fields['data'] = jsonEncode(data);

      // Attach file if available
      if (_selectedFile != null) {
        print('Attaching file...');
        try {
          var multipartFile = await http.MultipartFile.fromPath(
            'images', // Ensure the field name matches the backend's expected key
            _selectedFile!.path,
          );
          request.files.add(multipartFile);
        } catch (e) {
          print("Error attaching file: $e");
        }
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print('Success!');
        var responseData = jsonDecode(response.body);
        Util.toastMessage(responseData['message']);
        return true;
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        Util.toastMessage('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Network Error: $e');
      Util.toastMessage('Network error. Please try again.');
      return false;
    }
  }


  String _formatTime(TimeOfDay? time) {
    if (time == null) return "00:00 AM"; // Default value if time is null

    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dateTime); // Converts to 12-hour format with AM/PM
  }



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
                      const Text(
                        "You have any additional requirements?",
                        style: TextStyle(fontSize: 16),
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
           widget.type == "A" ? SafeArea(
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
                        "Finish ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ):
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    _uploadFileB(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Finish Hospital ",
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