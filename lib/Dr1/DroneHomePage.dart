import 'dart:async';
import 'package:doctor_one/Dr1/profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../homePage.dart';
import '../medOne/splash screen/MainSplashScreen.dart';

class Dronehomepage extends StatefulWidget {
  Dronehomepage({super.key});

  @override
  State<Dronehomepage> createState() => _DronehomepageState();
}

class _DronehomepageState extends State<Dronehomepage> {
  String getCurrentDateTime() {
    return DateFormat('EEE, d MMM yyyy | hh:mm a').format(DateTime.now());
  }

  bool isNightTime() {
    int hour = DateTime.now().hour;
    return hour >= 19 || hour < 6; // 7 PM to 6 AM is night
  }

  @override
  Widget build(BuildContext context) {
    // bool nightMode = isNightTime();
    // Color appBarColor = nightMode ? Colors.black : primaryColor;
    // IconData appBarIcon = nightMode ? Icons.nightlight_round : Icons.wb_sunny;
    // Color iconColor = nightMode ? Colors.yellowAccent : Colors.orangeAccent;
    // Color textColorTime = nightMode ? Colors.white :Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(120),
      //   child: ClipPath(
      //     clipper: CurvedAppBarClipper(),
      //     child: AppBar(
      //       backgroundColor: appBarColor,
      //       elevation: 0,
      //       centerTitle: true,
      //       automaticallyImplyLeading: false,
      //       title: StreamBuilder(
      //         stream: Stream.periodic(const Duration(seconds: 1)),
      //         builder: (context, snapshot) {
      //           return Text(
      //             getCurrentDateTime(),
      //             textAlign: TextAlign.center,
      //             style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColorTime),
      //           );
      //         },
      //       ),
      //       actions: [
      //         Padding(
      //           padding: const EdgeInsets.only(right: 16.0),
      //           child: Icon(appBarIcon, color: iconColor, size: 28),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
            ServiceCard(
              title: 'Med One',
              icon: Icons.health_and_safety_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainSplashScreen()));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ServiceCard({
    required this.title,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              pharmacyBlueLight,
              pharmacyBlue
            ],
              begin: Alignment.topLeft, // Gradient starts from top-left
              end: Alignment.bottomRight, // Gradient ends at bottom-right
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 50, color: pharmacyBlue),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
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

class CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height + 20, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CurvedAppBarClipper oldClipper) => false;
}
