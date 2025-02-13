import 'package:flutter/material.dart';
import 'package:doctor_one/Dr1/Labs.dart';
import 'package:doctor_one/Dr1/Medicine.dart';
import 'package:doctor_one/Dr1/bottomBar.dart';
import 'package:doctor_one/Dr1/myOrders.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/homePage.dart';
import 'package:intl/intl.dart';

import 'Dr1/DroneHomePage.dart';
//beta release...

class Menupage extends StatefulWidget {
  const Menupage({super.key});

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {

  String getCurrentDateTime() {
    return DateFormat('EEE, d MMM yyyy | hh:mm a').format(DateTime.now());
  }

  bool isNightTime() {
    int hour = DateTime.now().hour;
    return hour >= 19 || hour < 6; // 7 PM to 6 AM is night
  }
  @override
  Widget build(BuildContext context) {

    bool nightMode = isNightTime();
    Color appBarColor = nightMode ? Colors.black : primaryColor;
    IconData appBarIcon = nightMode ? Icons.nightlight_round : Icons.wb_sunny;
    Color iconColor = nightMode ? Colors.yellowAccent : Colors.orangeAccent;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: ClipPath(
          clipper: CurvedAppBarClipper(),
          child: AppBar(
            backgroundColor: appBarColor,
            elevation: 0,
            centerTitle: true,
            title: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Text(
                  getCurrentDateTime(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(appBarIcon, color: iconColor, size: 28),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 50),
            ServiceCard(
              title: 'Home Care Services',
              icon: Icons.home_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(type: 'A')));
              },
            ),
            ServiceCard(
              title: 'Hospital Services',
              icon: Icons.local_hospital_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(type: 'B')));
              },
            ),
            ServiceCard(
              title: 'Physiotherapist',
              icon: Icons.run_circle_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(type: 'C')));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
