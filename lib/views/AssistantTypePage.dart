import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/views/mobility.dart';

class AssistantTypePage extends StatefulWidget {
  String type;
  AssistantTypePage({required this.type,super.key});
  @override
  State<AssistantTypePage> createState() => _AssistantTypePageState();
}

class _AssistantTypePageState extends State<AssistantTypePage> {
  String? selectedType;
  String? selectedDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true, // Adds the back button
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Customize back button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Choose\nAssistant Type",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedType = "Out Patient";
                  selectedDuration = null; // Reset duration for Out Patient
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedType == "Out Patient"
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: selectedType == "Out Patient"
                      ? primaryColor2
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Out Patient",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Medical care or treatment that does not require an overnight stay at a hospital or medical facility.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedType = "In Patient";
                  selectedDuration = null; // Reset duration for new selection
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedType == "In Patient"
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: selectedType == "In Patient"
                      ? primaryColor2
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "In Patient",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Medical care or treatment that does not require an overnight stay at a hospital or medical facility.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedType == "In Patient") ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDuration = "2 Days";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedDuration == "2 Days"
                              ? primaryColor
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: selectedDuration == "2 Days"
                            ? primaryColor2
                            : Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Text(
                        "2 Days",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDuration = "3 Days";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedDuration == "3 Days"
                              ? primaryColor
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: selectedDuration == "3 Days"
                            ? primaryColor2
                            : Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Text(
                        "3 Days",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDuration = "Custom";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedDuration == "Custom"
                              ? primaryColor
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: selectedDuration == "Custom"
                            ? primaryColor2
                            : Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Text(
                        "Custom",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: selectedType != null &&
                  (selectedType == "Out Patient" ||
                      selectedDuration != null)
                  ? () {
                // Handle "Next" button tap
                Navigator.push(context, MaterialPageRoute(builder: (context) => PatientMobilityPage(type: widget.type,),));
                print("Selected Type: $selectedType");
                if (selectedDuration != null) {
                  print("Selected Duration: $selectedDuration");
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 16,color:Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
