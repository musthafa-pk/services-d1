import 'package:flutter/material.dart';
import 'package:services/Dr1/LoginPage.dart';
import 'package:services/Dr1/signUp.dart';
import 'package:services/utils/utils.dart';
import '../constants/constants.dart';
import '../homePage.dart';
import 'bottomBar.dart';

class Dronehomepage extends StatefulWidget {
  const Dronehomepage({super.key});

  @override
  State<Dronehomepage> createState() => _DronehomepageState();
}

class _DronehomepageState extends State<Dronehomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SizedBox(height: 100,),
            ServiceCard(
              title: 'Home Care Services',
              icon: Icons.home,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage(type: 'A')),
                );
              },
            ),
            ServiceCard(
              title: 'Hospital Services',
              icon: Icons.local_hospital,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage(type: 'B')),
                );
              },
            ),
            ServiceCard(
              title: 'Physiotherapist',
              icon: Icons.run_circle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage(type: 'C')),
                );
              },
            ),
            ServiceCard(
              title: 'Med One',
              icon: Icons.medical_services,
              onTap: () {
                Util.toastMessage('Coming soon...!');
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
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 50, color: primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
