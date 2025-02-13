

import 'package:doctor_one/Dr1/bottomBar.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import 'Lab Homepage.dart';
import 'LabUrl.dart';

class UploadPrescriptionScreenLab extends StatefulWidget {
  @override
  _UploadPrescriptionScreenLabState createState() => _UploadPrescriptionScreenLabState();
}
class LabColors {
  static const Color primaryColor = Color.fromRGBO(76, 193, 170, 1.0);
  static const Color lightPrimaryColor1 = Color.fromRGBO(200, 230, 223, 1.0);

  static final Color extraLightPrimary = primaryColor.withOpacity(0.1); // 10% opacity
}
class _UploadPrescriptionScreenLabState extends State<UploadPrescriptionScreenLab> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController dobController = TextEditingController(); // For DOB
  bool consentGiven = false;
  List<File> _selectedFiles = [];
  String? selectedGender; // For gender selection

  Future<void> _pickFiles() async {
    final picker = ImagePicker();
    try {
      final List<XFile>? pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null) {
        if (pickedFiles.length > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You can only select up to 5 images.")),
          );
          return;
        }

        setState(() {
          _selectedFiles = pickedFiles.map((file) => File(file.path)).toList();
        });
      }
    } catch (e) {
      print("Error picking files: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting files")),
      );
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}".split(' ')[0]; // Format: YYYY-MM-DD
      });
    }
  }

  Future<void> _submitForm() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final url = LabUrl.prescriptionUpload;

    // Validate pincode format
    if (pincodeController.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(pincodeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid pincode format")),
      );
      return;
    }

    // Validate DOB and gender
    if (dobController.text.isEmpty || selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    // Prepare JSON data according to API spec
    final jsonData = {
      "data": {
        "userId": userID,
        "status": "placed",
        "remarks": remarksController.text,
        "order_type": "prescription",
        "delivery_location": {
          "lat":11.7871188,
          "lng": 75.5320371
        },
        "pincode": int.parse(pincodeController.text), // Convert to int
        "contact_no": contactController.text,
        "doctor_name": "",
        "patientDetails": {
          "dob": dobController.text, // Use selected DOB
          "name": nameController.text,
          "gender": selectedGender, // Use selected gender
          "phone_no": contactController.text
        },
        "delivery_details": {
          "address": addressController.text,
          "pincode": pincodeController.text,
          "location": {
            "lat": 11.7871188,
            "lng": 75.5320371
          }
        }
      }
    };

    final request = http.MultipartRequest("POST", Uri.parse(url));

    // Add the JSON data as a field named "data"
    request.fields["data"] = jsonEncode(jsonData['data']);

    // Add images with correct field name "images"
    for (var file in _selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "images", // Must match Multer's upload.array("images")
          file.path,
        ),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DroneBottomNavigation(pageindx: 1,)),
              (Route<dynamic> route) => false,
        );
        Util.flushBarSuccessMessage(pharmacyBlue,'Prescription uploaded successfully!', context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Prescription uploaded successfully!")),
        // );
      } else {
        Util.flushBarSuccessMessage(pharmacyBlue,'Error: json.${jsonDecode(responseBody)['message'] ?? 'Upload failed'}', context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Error: json.${decode(responseBody)['message'] ?? 'Upload failed'}")),
        // );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload prescription", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(nameController, "Name"),
              _buildTextField(contactController, "Contact Number"),
              _buildTextField(landmarkController, "Nearest landmark"),

              // Gender Selection
              Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedGender,
                hint: Text("Select Gender"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                items: <String>['male', 'female', 'other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              // Date of Birth (DOB) Selection
              Text("Date of Birth", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {_selectDateOfBirth(context);} ,
                child: TextFormField(
                  controller: dobController,
                  decoration: InputDecoration(
                    hintText: "Select Date of Birth",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDateOfBirth(context),
                    ),
                  ),
                  readOnly: true, // Prevent manual editing
                ),
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickFiles,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text("Upload Prescription (Max 5 Files)", style: TextStyle(color: Colors.white)),
              ),

              if (_selectedFiles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Selected files: ${_selectedFiles.length}"),
                ),

              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: LabColors.primaryColor),
                    icon: Icon(Icons.location_pin, color: Colors.white),
                    label: Text("Use my location", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              _buildTextField(addressController, "Delivery address"),
              _buildTextField(districtController, "District"),
              _buildTextField(pincodeController, "Pincode"),
              _buildTextField(remarksController, "Remarks"),

              Row(
                children: [
                  Checkbox(
                    value: consentGiven,
                    onChanged: (value) {
                      setState(() {
                        consentGiven = value!;
                      });
                    },
                  ),
                  Expanded(child: Text("I consent to be contacted regarding my submission."))
                ],
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(backgroundColor: LabColors.primaryColor),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
//
// class UploadPrescriptionScreenLab extends StatefulWidget {
//   @override
//   _UploadPrescriptionScreenLabState createState() => _UploadPrescriptionScreenLabState();
// }
//
// class _UploadPrescriptionScreenLabState extends State<UploadPrescriptionScreenLab> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();
//   final TextEditingController landmarkController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController districtController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();
//   final TextEditingController remarksController = TextEditingController();
//   bool consentGiven = false;
//   List<File> _selectedFiles = [];
//
//   Future<void> _pickFiles() async {
//     final picker = ImagePicker();
//     try {
//       final List<XFile>? pickedFiles = await picker.pickMultiImage();
//
//       if (pickedFiles != null) {
//         if (pickedFiles.length > 5) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("You can only select up to 5 images.")),
//           );
//           return;
//         }
//
//         setState(() {
//           _selectedFiles = pickedFiles.map((file) => File(file.path)).toList();
//         });
//       }
//     } catch (e) {
//       print("Error picking files: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error selecting files")),
//       );
//     }
//   }
//
//
//   Future<void> _submitForm() async {
//     final url = "https://test.apis.dr1.co.in/labtest/prescriptionupload";
//
//     // Validate pincode format
//     if (pincodeController.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(pincodeController.text)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid pincode format")),
//       );
//       return;
//     }
//
//     // Prepare JSON data according to API spec
//     final jsonData = {
//       "data": {  // Wrap in "data" object as per API requirement
//         "userId": 10,
//         "status": "placed",
//         "remarks": remarksController.text,
//         "order_type": "prescription",
//         "delivery_location": {
//           "lat": 11.5378576,
//           "lng": 75.65675590000001
//         },
//         "pincode": int.parse(pincodeController.text), // Convert to int
//         "contact_no": contactController.text,
//         "doctor_name": "",
//         "patientDetails": {
//           "dob": "2004-01-23",
//           "name": nameController.text,
//           "gender": "male",
//           "phone_no": contactController.text
//         },
//         "delivery_details": {
//           "address": addressController.text,
//           "pincode": pincodeController.text,
//           "location": {
//             "lat": 11.5378576,
//             "lng": 75.65675590000001
//           }
//         }
//       }
//     };
//
//     final request = http.MultipartRequest("POST", Uri.parse(url));
//
//     // Add the JSON data as a field named "data"
//     request.fields["data"] = jsonEncode(jsonData['data']);
//
//     // Add images with correct field name "images"
//     for (var file in _selectedFiles) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           "images", // Must match Multer's upload.array("images")
//           file.path,
//         ),
//       );
//     }
//
//     try {
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//
//       print("Status Code: ${response.statusCode}");
//       print("Response Body: $responseBody");
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Prescription uploaded successfully!")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${json.decode(responseBody)['message'] ?? 'Upload failed'}")),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Network error occurred")),
//       );
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Upload prescription", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTextField(nameController, "Name"),
//               _buildTextField(contactController, "Contact Number"),
//               _buildTextField(landmarkController, "Nearest landmark"),
//
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _pickFiles,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
//                 child: Text("Upload Prescription (Max 5 Files)", style: TextStyle(color: Colors.white)),
//               ),
//
//               if (_selectedFiles.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text("Selected files: ${_selectedFiles.length}"),
//                 ),
//
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     icon: Icon(Icons.location_pin, color: Colors.white),
//                     label: Text("Use my location", style: TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               ),
//
//               _buildTextField(addressController, "Delivery address"),
//               _buildTextField(districtController, "District"),
//               _buildTextField(pincodeController, "Pincode"),
//               _buildTextField(remarksController, "Remarks"),
//
//               Row(
//                 children: [
//                   Checkbox(
//                     value: consentGiven,
//                     onChanged: (value) {
//                       setState(() {
//                         consentGiven = value!;
//                       });
//                     },
//                   ),
//                   Expanded(child: Text("I consent to be contacted regarding my submission."))
//                 ],
//               ),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: Text("Submit", style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.grey[200],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }