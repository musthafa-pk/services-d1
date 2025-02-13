import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/medOne/splash%20screen/TimeSplash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../utils/utils.dart';
import '../Constants/AppColors.dart';
import '../View/bottomNavMedOne.dart';
import 'MedicationTrackerScreen.dart';


class MainSplashScreen extends StatefulWidget {
  const MainSplashScreen({Key? key}) : super(key: key);

  @override
  State<MainSplashScreen> createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer for 2 seconds before navigating to the login page
    Timer(Duration(seconds: 2), ()async {
      // Navigate to the login page
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool? checkroutine = preferences.getBool('routineData');
      int? userID = preferences.getInt('userId');
      print('userid is :$userID');

      if(userID != null){
        // if(checkroutine == true){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // builder: (context) => BottomNavigation(),
              builder: (context) => Timesplash(name: 'Abcd', gender: "Male", healthCondition: "healthCondition"),
            ),
          );
        // }
        // else{
        //   Util.flushBarErrorMessage('some work pending..', context);
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginPage()),
          //       (Route<dynamic> route) => false,
          // );

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MedicationTrackerScreen(
          //       name: name,
          //       gender: gender,
          //       // dateOfBirth: dateOfBirth,
          //       healthCondition: healthCondition,
          //       height: height,
          //       weight: weight,
          //     ),
          //   ),
          // );
        // }
      }else{
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pharmacyBlue,
      body: Center(
        child: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>BottomNavigation() ,));
          },
          icon: Image.asset('assets/medone/icons/medoneicon.png', height: 100, width: 100),
        ),
      ),
    );
  }
}