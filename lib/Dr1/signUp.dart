import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:services/Dr1/profile.dart';
import 'package:services/constants/constants.dart';
import 'package:services/res/appUrl.dart';

import '../constants/widgets/widgetsByGIkhin.dart';
import 'LoginPage.dart';

class Signupdrone extends StatefulWidget {
  @override
  _SignupdroneState createState() => _SignupdroneState();
}

class _SignupdroneState extends State<Signupdrone> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Replace with your actual API endpoint
  final String apiUrl = AppUrl.addusers;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if form validation fails
    }

    final Map<String, dynamic> requestBody = {
      "name": nameController.text,
      "phone_no": phoneController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful signup
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signup Successful!"))
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => DrOneProfile()));
      } else {
        // Signup failed
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signup Failed: ${response.body}"))
        );
      }
    } catch (e) {
      // Network or unexpected error
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 30, child: Text('Dr1')),
                const SizedBox(height: 10),
                const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                DroneAppWidgets.customTextFormField(
                  hintText: 'Enter your Name',
                  controller: nameController,
                  validator: (value) => value!.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 16),
                DroneAppWidgets.customTextFormField(
                  hintText: 'Enter your Phone No',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.length != 10 ? "Enter a valid phone number" : null,
                ),
                const SizedBox(height: 16),
                DroneAppWidgets.customTextFormField(
                  hintText: 'Enter your Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => !value!.contains("@") ? "Enter a valid email" : null,
                ),
                const SizedBox(height: 16),
                DroneAppWidgets.customTextFormField(
                  hintText: 'Enter your Password',
                  obscureText: !_isPasswordVisible,
                  icon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  controller: passwordController,
                  isIconOnRight: true,
                  onIconPressed: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  validator: (value) => value!.length < 6 ? "Password too short" : null,
                ),
                const SizedBox(height: 16),
                DroneAppWidgets.customTextFormField(
                  hintText: 'Confirm Password',
                  obscureText: !_isConfirmPasswordVisible,
                  icon: _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  controller: confirmPasswordController,
                  isIconOnRight: true,
                  onIconPressed: () {
                    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                  },
                  validator: (value) => value != passwordController.text ? "Passwords do not match" : null,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Password must be 6+ characters with an uppercase letter, digit, and special character',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                DroneAppWidgets.mainButton(
                  backgroundColor: d1blue,
                  title: 'Create Account',
                  onPressed: registerUser, // Call API function
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DroneLoginpage()));
                  },
                  child: const Text('Already have an account? Login', style: TextStyle(color: d1blue)),
                ),
                const Text('OR', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                DroneAppWidgets.OutLinemainButton(title: 'Continue with Google', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
