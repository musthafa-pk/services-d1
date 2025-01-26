import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/views/gender.dart';
import 'package:services/views/pickupAssitance.dart';

class PatientMobilityPage extends StatefulWidget {
  String type;
  PatientMobilityPage({required this.type, super.key});

  @override
  _PatientMobilityPageState createState() => _PatientMobilityPageState();
}

class _PatientMobilityPageState extends State<PatientMobilityPage> {
  String? selectedMobility;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true, // Back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "How is Patient\nMobility",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Option: Patient Can Walk
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedMobility = "Patient Can Walk";
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedMobility == "Patient Can Walk"
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: selectedMobility == "Patient Can Walk"
                      ? primaryColor2
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Patient Can Walk",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Medical care or treatment that does",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/anothre.png", // Replace with your asset
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Option: Patient Needs a Wheelchair
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedMobility = "Patient Needs a Wheelchair";
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedMobility == "Patient Needs a Wheelchair"
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: selectedMobility == "Patient Needs a Wheelchair"
                      ? primaryColor2
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Patient Needs A Wheelchair",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Medical care or treatment that does",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/wheelchair.png", // Replace with your asset
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Option: Patient Needs a Stretcher
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedMobility = "Patient Needs a Stretcher";
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedMobility == "Patient Needs a Stretcher"
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: selectedMobility == "Patient Needs a Stretcher"
                      ? primaryColor2
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Patient Needs A Stretcher",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Medical care or treatment that does",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/patient.png", // Replace with your asset
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Show the button only if an option is selected
            if (selectedMobility != null)
              ElevatedButton(
                onPressed: () {
                  // Handle Next Button
                  if(widget.type == 'A'){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Gender(type: widget.type),));
                  }else
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PickupAssistancePage(),));
                  print("Selected Mobility: $selectedMobility");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
