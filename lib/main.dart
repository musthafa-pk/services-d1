import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/homePage.dart';
import 'package:services/menuPage.dart';
import 'package:services/views/addLocation.dart';
import 'package:services/views/basicDetails.dart';
import 'package:services/views/finalDetailsPage.dart';
import 'package:services/views/gender.dart';
import 'package:services/views/splash/submit_success.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Services',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
        fontFamily: 'AeonikTRIAL-Bold.otf'
      ),
      // home:Homepage()
      home:Menupage()
    );
  }
}
