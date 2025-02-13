import 'package:doctor_one/Dr1/signUp.dart';
import 'package:doctor_one/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/constants.dart';
import '../constants/widgets/widgetsfordoctor1.dart';
import '../res/appUrl.dart';
import 'bottomBar.dart';

class DroneLoginpage extends StatefulWidget {
  const DroneLoginpage({super.key});

  @override
  State<DroneLoginpage> createState() => _DroneLoginpageState();
}

class _DroneLoginpageState extends State<DroneLoginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;


  bool _isLoading = false;

  final String apiUrl = AppUrl.userLogin;

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

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
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', responseData['accessToken']);
          await prefs.setString('refreshToken', responseData['refreshToken']);
          await prefs.setInt('userId', responseData['userId']);
          await prefs.setString('username', responseData['user_name']);
          await prefs.setString('userType', responseData['userType']);

          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text(responseData['message']))
          // );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DroneBottomNavigation(pageindx: 0,)));
          Util.flushBarSuccessMessage(pharmacyBlue,'${responseData['message']}', context);
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

  // Exit Confirmation Dialog
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit App"),
        content: Text("Do you really want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in app
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit app
            child: Text("Yes"),
          ),
        ],
      ),
    ) ??
        false; // If the user taps outside, it won't exit
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back press
      child: Scaffold(
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
                      validator: (value) =>
                      value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  // Modify the password field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DroneAppWidgets.customTextFormField(
                      hintText: 'Enter your Password',
                      controller: passwordController,
                      obscureText: _obscureText,
                      validator: (value) =>
                      value!.length < 6 ? "Password must be at least 6 characters" : null,
                      icon: _obscureText ? Icons.visibility_off : Icons.visibility,
                      isIconOnRight: true,
                      onIconPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : DroneAppWidgets.mainButton(
                      backgroundColor: pharmacyBlue,
                      title: 'Login',
                      textColor: Colors.black,
                      onPressed: loginUser,
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

                  // Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       const Text('Explore without account? ',
                  //           style: TextStyle(fontSize: 12, color: Colors.black)),
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(context,
                  //               MaterialPageRoute(builder: (context) => DroneBottomNavigation(pageindx: 0,)));
                  //         },
                  //         child: Text(' Back to Home', style: TextStyle(fontSize: 12, color: d1blue)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
