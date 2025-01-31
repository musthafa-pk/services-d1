import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:services/Dr1/bottomBar.dart';
import 'package:services/Dr1/profile.dart';
import 'package:services/Dr1/signUp.dart';
import 'package:services/constants/constants.dart';
import 'package:services/res/appUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/widgets/widgetsByGIkhin.dart';

class DroneLoginpage extends StatefulWidget {
  const DroneLoginpage({super.key});

  @override
  State<DroneLoginpage> createState() => _DroneLoginpageState();
}

class _DroneLoginpageState extends State<DroneLoginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  // Replace with your actual API endpoint
  final String apiUrl = AppUrl.userLogin;


  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form validation fails
    }

    setState(() => _isLoading = true);

    final Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          String accessToken = responseData['accessToken'];
          String refreshToken = responseData['refreshToken'];
          int userId = responseData['userId'];
          String userType = responseData['userType'];

          // Store tokens & user info in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('refreshToken', refreshToken);
          await prefs.setInt('userId', userId);
          await prefs.setString('userType', userType);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message']))
          );

          // Navigate based on userType
          if (userType == 'customer') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DroneBottomNavigation())
            );
          } else {
            // Navigate to another page for different user types if needed
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login Failed: ${responseData['message']}"))
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Failed: ${response.statusCode}"))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e"))
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/d1/nolog.jpg'),
                const Center(
                  child: Text(
                    'Login for full potential',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const Center(
                  child: Text(
                    'Your health journey starts here, Log in for quick access to your healthcare services and records.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
          
                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DroneAppWidgets.customTextFormField(
                    hintText: 'Enter your Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null,
                  ),
                ),
                const SizedBox(height: 16),
          
                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DroneAppWidgets.customTextFormField(
                    hintText: 'Enter your Password',
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                  ),
                ),
                const SizedBox(height: 20),
          
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : DroneAppWidgets.mainButton(
                    backgroundColor: d1blue,
                    title: 'Login',
                    onPressed: loginUser, // Call API function
                  ),
                ),
          
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DroneAppWidgets.OutLinemainButton(
                    title: 'Create new account',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signupdrone()));
                    },
                  ),
                ),
          
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Explore without account? ', style: TextStyle(fontSize: 12, color: Colors.black)),
                      GestureDetector(
                        onTap: () {
                          // Navigate back to home
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DroneBottomNavigation()));
                        },
                        child: Text(' Back to Home', style: TextStyle(fontSize: 12, color: d1blue)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
