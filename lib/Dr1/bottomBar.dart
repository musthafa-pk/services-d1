import 'dart:convert';

import 'package:doctor_one/Dr1/profile.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart'; // For SystemNavigator.pop()
import 'package:shared_preferences/shared_preferences.dart';
import '../Labs/Lab Homepage.dart';
import '../res/appUrl.dart';
import 'DroneHomePage.dart';
import 'Medicine.dart';
import 'package:http/http.dart' as http;

class DroneBottomNavigation extends StatefulWidget {
  final int pageindx; // Make this final since it's immutable
  DroneBottomNavigation({required this.pageindx});

  @override
  _DroneBottomNavigationState createState() => _DroneBottomNavigationState();
}

class _DroneBottomNavigationState extends State<DroneBottomNavigation> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; // Track the current index internally
  Future<UserDetails>? _apiResponse;

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


  final List<Widget> _pages = [
    Dronehomepage(),
    LabHomePage(),
    MedicineHomePage(),
    DrOneProfile(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageindx; // Initialize with the passed index

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pageController.jumpToPage(_currentIndex); // Ensure it's attached before jumping
      }
    });
    _apiResponse = getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index; // Update the tracked index
            });
          },
          children: _pages,
          physics: const BouncingScrollPhysics(),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: pharmacyBlueLight,
          height: 60,
          index: _currentIndex, // Use the tracked index
          items: <Widget>[
            _buildIcon(_currentIndex == 0
                ? 'assets/icons/home-9-fill.png'
                : 'assets/icons/home-9-line.png', 25),
            _buildIcon(_currentIndex == 1
                ? 'assets/icons/flask-fill.png'
                : 'assets/icons/flask-line.png', 30),
            _buildIcon(_currentIndex == 2
                ? 'assets/icons/store-2-fill.png'
                : 'assets/icons/store-2-line.png', 25),
            _buildIcon(_currentIndex == 3
                ? 'assets/icons/account-circle-2-fill.png'
                : 'assets/icons/account-circle-2-line.png', 25),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update tracked index
            });
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }

  Widget _buildIcon(String assetPath, double size) {
    return Image.asset(
      assetPath,
      height: size,
      width: size,
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit App"),
        content: Text("Do you want to exit the app?"),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pharmacyBlue
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // Exit the app
            },
            child: Text("Yes"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}