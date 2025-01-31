import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/views/gender.dart';
import 'package:services/views/pickupAssitance.dart';

class PatientMobilityPage extends StatefulWidget {
  String type;
  String? age;
  String? gender;
  String? inoutpatient;
  PatientMobilityPage({required this.type, this.age, this.gender, this.inoutpatient, super.key});

  @override
  _PatientMobilityPageState createState() => _PatientMobilityPageState();
}

class _PatientMobilityPageState extends State<PatientMobilityPage> {
  String? selectedMobility;

  void _navigateNext(String mobility) {
    setState(() {
      selectedMobility = mobility;
    });
    if (widget.type == 'A') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Gender(type: widget.type),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PickupAssistancePage(type: widget.type,age: widget.age,gender: widget.gender,),
        ),
      );
    }
    print("Selected Mobility: $mobility");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How is Patient\nMobility",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildMobilityOption("Patient Can \nWalk", "assets/images/anothre.png"),
            const SizedBox(height: 20),
            _buildMobilityOption("Patient Needs a \nWheelchair", "assets/images/wheelchair.png"),
            const SizedBox(height: 20),
            _buildMobilityOption("Patient Needs a \nStretcher", "assets/images/patient.png"),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilityOption(String title, String assetPath) {
    bool isSelected = selectedMobility == title;
    return GestureDetector(
      onTap: () => _navigateNext(title),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? primaryColor2 : Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Medical care or treatment that does",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Image.asset(assetPath, height: 60),
          ],
        ),
      ),
    );
  }
}