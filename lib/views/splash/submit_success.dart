import 'package:flutter/material.dart';
import 'package:services/homePage.dart';
import 'package:services/menuPage.dart';

class SubmitSuccess extends StatefulWidget {
  const SubmitSuccess({super.key});

  @override
  State<SubmitSuccess> createState() => _SubmitSuccessState();
}

class _SubmitSuccessState extends State<SubmitSuccess> {
  @override
  void initState() {
    super.initState();

    // Navigate to the HomePage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menupage(), // Replace with your actual HomePage widget
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('assets/images/successimage.png'),
              height: 240,
              width: 240,
            ),
            const SizedBox(height: 20),
            const Text(
              'Submitted\nSuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Medical care or treatment that does not require an overnight stay at a hospital or medical facility.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}