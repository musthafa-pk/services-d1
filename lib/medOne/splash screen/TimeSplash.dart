import 'package:doctor_one/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/AppColors.dart';
import '../MedOneConstants.dart';
import '../MedOneWidgets/customWidgets.dart';
import '../View/CreatingProfile/DailyRoutine.dart';
import '../View/CreatingProfile/pastOrder.dart';

class Timesplash extends StatefulWidget {
  final String name;
  final String gender;
  // final String dateOfBirth;
  final String healthCondition;
  final String? height;
  final String? weight;
  final String? profileImage;

  // Constructor to receive user data
  const Timesplash({
    Key? key,
    required this.name,
    required this.gender,
    // required this.dateOfBirth,
    required this.healthCondition,
    this.height,
    this.weight,
    this.profileImage,
  }) : super(key: key);

  @override
  State<Timesplash> createState() => _TimesplashState();
}


class _TimesplashState extends State<Timesplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      Padding(
        padding: const EdgeInsets.only(right: 15.0,left: 15.0),
        child: Dronewidgets.mainButton(title: 'Start',textColor: Colors.black,
            onPressed: (){
              _showMedicationOptionsDialog(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileName(
              //   name: widget.name,
              //   gender: widget.gender,
              //   // dateOfBirth: widget.dateOfBirth,
              //   healthCondition: widget.healthCondition
              //   , height: widget.height, weight: widget.weight,
              //   profileImage: widget.profileImage,
              // ),));
            },backgroundColor: pharmacyBlue),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Stack for medicine images (replace with your own assets)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/medone/images/clock.png', // Replace with your image
                            height: 299,
                            width: 299,
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

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
                        'Set Reminders',
                        style: text60031black,
                      ),
                      // Text "Of All Medications You Take"
                      Text(
                        'so you wont forget to take pills',
                        style: text40018black,
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showMedicationOptionsDialog(BuildContext context) {
    bool _backPressedOnce = false;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing when tapping outside the dialog
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.containercolor,
        content: medicationOptionsContainer(context),
      ),
    );
  }



  // Your medicationOptionsContainer function
  static Widget medicationOptionsContainer(BuildContext context) {
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Do you have any past orders or need to add it manually?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // "Past order" button
          Dronewidgets.mainButton(title: 'Past order', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineListPastorder(),));

          },
            textColor: Colors.black
          ),
          SizedBox(height: 12),
          // "Add Medication" button
          Dronewidgets.mainButton(title: 'Add Medication', onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context) => AddingMedicineone()));
            Navigator.push(context, MaterialPageRoute(builder: (context) => DailyRoutine(),));

          },
            textColor: Colors.black
           )

        ],
      ),
    );
  }
}