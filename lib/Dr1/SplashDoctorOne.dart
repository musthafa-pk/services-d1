import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../constants/constants.dart';
import '../medOne/Constants/AppColors.dart';
import 'LoginPage.dart';
import 'bottomBar.dart';

class MainSplashScreenDocOne extends StatefulWidget {
  const MainSplashScreenDocOne({Key? key}) : super(key: key);

  @override
  State<MainSplashScreenDocOne> createState() => _MainSplashScreenDocOneState();
}

class _MainSplashScreenDocOneState extends State<MainSplashScreenDocOne> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late Animation<double> _subtitleAnimation;

  final String title = "Doctor One...";
  final String subtitle = "Wellness Made Easy "; // Medical-related subtitle

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500), // Total animation duration
    );

    _fadeAnimations = List.generate(
      title.length,
          (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index / title.length, 1, curve: Curves.easeIn),
        ),
      ),
    );

    // Subtitle animation starts after the title animation
    _subtitleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.7, 1, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Navigate after 2.5 seconds
    Timer(Duration(seconds: 5), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      int? userID = preferences.getInt('userId');
      if (userID != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DroneBottomNavigation(pageindx: 0,)));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DroneLoginpage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Title
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(title.length, (index) {
                return FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: Text(
                    title[index],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: d1blue),
                  ),
                );
              }),
            ),
            SizedBox(height: 8), // Space between title and subtitle

            // Subtitle with Fade Animation
            FadeTransition(
              opacity: _subtitleAnimation,
              child: Text(
                subtitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
