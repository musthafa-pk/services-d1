import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:services/Dr1/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/appUrl.dart';

class DrOneEditProfile extends StatefulWidget {
  @override
  _DrOneEditProfileState createState() => _DrOneEditProfileState();
}

class _DrOneEditProfileState extends State<DrOneEditProfile> {
  String selectedGender = 'Male';
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  TextEditingController nameController = TextEditingController();
  TextEditingController ageGroupController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  File? selectedImage;
  String? profileImageUrl;

  static const Color primaryColor = Color(0xFF007BFF);
  static const Color textColor = Colors.black;
  static const Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    String url = AppUrl.getProfile;

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userid": userID}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData["success"] == true && responseData["userDetails"] != null) {
        UserDetails user = UserDetails.fromJson(responseData["userDetails"]);

        setState(() {
          nameController.text = user.name ?? "";
          ageGroupController.text = user.ageGroup ?? "";
          dobController.text = user.ageGroup ?? "";
          pincodeController.text = user.pincode ?? "";
          selectedGender = user.gender ?? "Male";
          profileImageUrl = user.image; // Assign profile image from backend
        });
      }
    } else {
      print("Failed to load user data");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> editUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int userId = pref.getInt("userId") ?? 0;

    String url = AppUrl.edituser;
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['data'] = jsonEncode({
      "userId": userId,
      "name": nameController.text,
      "ageGroup": ageGroupController.text,
      "gender": selectedGender,
      "pincode": pincodeController.text,
    });

    if (selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        selectedImage!.path,
        filename: basename(selectedImage!.path),
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print("User updated successfully!");
    } else {
      print("Failed to update user. Status: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit Profile", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : (profileImageUrl != null && profileImageUrl!.isNotEmpty
                      ? NetworkImage(profileImageUrl!)
                      : null) as ImageProvider<Object>?,
                  child: selectedImage == null && (profileImageUrl == null || profileImageUrl!.isEmpty)
                      ? Icon(Icons.person, size: 60, color: textColor)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              buildInputField("Name", nameController),
              buildDropdownField("Gender"),
              buildInputField("Age Group", ageGroupController),
              buildInputField("Date of Birth", dobController),
              buildInputField("Pincode", pincodeController),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: editUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: textColor)),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 14, color: textColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: textColor)),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: selectedGender,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide.none,
              ),
            ),
            items: genderOptions.map((gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender, style: TextStyle(fontSize: 14, color: textColor)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
