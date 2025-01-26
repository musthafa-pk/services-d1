import 'package:flutter/material.dart';
import 'package:services/views/locationTimingPage.dart';

import '../constants/constants.dart';

class PickupAssistancePage extends StatefulWidget {
  @override
  _PickupAssistancePageState createState() => _PickupAssistancePageState();
}

class _PickupAssistancePageState extends State<PickupAssistancePage> {
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Pick Up Assistance",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Medical care or treatment that does not require an overnight stay at a hospital or medical facility.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Options
            _buildOption(
              title: "Hospital Only",
              description:
              "Medical care or treatment that does not require an overnight stay at a hospital or medical facility.",
              isSelected: selectedOption == "Hospital Only",
              onTap: () {
                setState(() {
                  selectedOption = "Hospital Only";
                });
              },
            ),
            const SizedBox(height: 20),
            _buildOption(
              title: "Door to Door",
              description:
              "Medical care or treatment that does not require an overnight stay at a hospital or medical facility.",
              isSelected: selectedOption == "Door to Door",
              onTap: () {
                setState(() {
                  selectedOption = "Door to Door";
                });
              },
            ),
            const Spacer(),
            // "Next" Button
            if (selectedOption != null)
              ElevatedButton(
                onPressed: () {
                  // Handle "Next" button action
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LocationTimingPage(delivryType: selectedOption,),));
                  print("Selected Option: $selectedOption");
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

  Widget _buildOption({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? primaryColor2 : Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

