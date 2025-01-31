import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:services/Dr1/myOrders.dart';
import 'package:services/constants/constants.dart';
import 'package:services/res/appUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Editprofile.dart';

class DrOneProfile extends StatefulWidget {
  @override
  _DrOneProfileState createState() => _DrOneProfileState();
}

class _DrOneProfileState extends State<DrOneProfile> {
  Future<UserDetails>? _apiResponse;

  @override
  void initState() {
    super.initState();
    _apiResponse = getUserData();
  }

  Future<UserDetails> getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    String url = AppUrl.getProfile;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"userid": userID}),

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData["success"] == true && responseData["userDetails"] != null) {
        return UserDetails.fromJson(responseData["userDetails"]);
      } else {
        throw Exception("Failed to load user details");
      }
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,left: 8,right: 8),
          child: FutureBuilder<UserDetails>(
            future: _apiResponse,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No data available"));
              }

              // API Response Data
              UserDetails user = snapshot.data!;

              return Column(
                children: [
                  // Profile Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: user.image != null && user.image!.isNotEmpty
                                      ? NetworkImage(user.image!) // Load image from API response
                                      : AssetImage('assets/images/default_avatar.png') as ImageProvider, // Placeholder image
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(user.ageGroup?.isNotEmpty == true ? user.ageGroup! : " ", style: const TextStyle(fontSize: 14, color: Colors.green)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: d1blue, size: 18),
                                const SizedBox(width: 5),
                                Text(user.phoneNo?.isNotEmpty == true ? user.phoneNo : " "),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.email, color: d1blue, size: 18),
                                const SizedBox(width: 5),
                                Text(user.email?.isNotEmpty == true ? user.email : " "),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: d1blue, size: 18),
                                const SizedBox(width: 5),
                                Text(user.pincode?.isNotEmpty == true ? user.pincode! : " "),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Edit Profile Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrOneEditProfile(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: d1blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text("Edit profile",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // My Orders & Second Opinion Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrdersPage(),
                              ),
                            );
                          },
                          child: _customTabButton("My orders"),
                        ),
                        _customTabButton("Second opinion"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Menu List
                  _menuItem(Icons.phone, "My queries"),
                  _menuItem(Icons.lock, "Change password",
                      subtitle: "Reset your password"),
                  _menuItem(Icons.help, "Help", subtitle: "Dr1 helpline"),

                  const Spacer(),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("Logout",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Custom Tab Button
  Widget _customTabButton(String text) {
    return Container(
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Text(text,
          style: const TextStyle(
              color:d1blue, fontWeight: FontWeight.bold)),
    );
  }

  // Menu Item
  Widget _menuItem(IconData icon, String title, {String? subtitle}) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor:color1,
          child: Icon(icon, color:d1blue)),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.grey))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}

// UserDetails Model Class
class UserDetails {
  final int id;
  final String name;
  final String phoneNo;
  final String email;
  final String? gender;
  final String? image;
  final String? ageGroup;
  final String? pincode;
  final List<String> healthConditions;
  final String? token;
  final String? lastActive;

  UserDetails({
    required this.id,
    required this.name,
    required this.phoneNo,
    required this.email,
    this.gender,
    this.image,
    this.ageGroup,
    this.pincode,
    required this.healthConditions,
    this.token,
    this.lastActive,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json["id"],
      name: json["name"],
      phoneNo: json["phone_no"],
      email: json["email"],
      gender: json["gender"],
      image: json["image"],
      ageGroup: json["ageGroup"],
      pincode: json["pincode"],
      healthConditions: (json["health_condition"] as List?)
          ?.map((item) => item["healthCondition"] as String)
          .toList() ??
          [],
      token: json["token"],
      lastActive: json["last_active"],
    );
  }
}