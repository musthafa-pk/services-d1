import 'package:flutter/material.dart';
import 'dart:async';

import '../Constants/AppColors.dart';
import '../MedOneConstants.dart';
import 'TimeSplash.dart'; // Import for Timer

class MedicationTrackerScreen extends StatefulWidget {
  final String name;
  final String gender;
  // final String dateOfBirth;
  final String healthCondition;
  final String? height;
  final String? weight;
  final String? profileImage;

  // Constructor to receive user data
  MedicationTrackerScreen({
    required this.name,
    required this.gender,
    // required this.dateOfBirth,
    required this.healthCondition,
    required this.height,
    required this.weight,
    required this.profileImage,
  });

  @override
  _MedicationTrackerScreenState createState() => _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next page after 3 seconds
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Timesplash(
            name: widget.name,
            gender: widget.gender,
            // dateOfBirth: widget.dateOfBirth,
            healthCondition: widget.healthCondition,
            // height: widget.height, weight: widget.weight,
            // profileImage: widget.profileImage,

          ), // Replace with your next page
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container with the circular element
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.primaryColor, // Background teal color
            child: Stack(
              children: [
                // Top left circular design
                Positioned(
                  top: -100, // Adjust the position as needed
                  left: -100, // Adjust the position as needed
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor2, // Darker shade of teal
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Main content
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Stack for medicine images (replace with your own assets)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/medone/images/medicineone.png', // Replace with your image
                              height: 300,
                              width: 300,
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        // Dotted separator
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 11,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(width: 5),
                            CircleAvatar(radius: 5, backgroundColor: Colors.white),
                            SizedBox(width: 5),
                            CircleAvatar(radius: 5, backgroundColor: Colors.white),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Text "Keep Track"
                        Text(
                          'Keep Track',
                          style: text60045,
                        ),
                        // Text "Of All Medications You Take"
                        Text(
                          'Of All Medications You Take',
                          style: text40023,
                        ),
                        // Display passed user data
                        SizedBox(height: 20),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}