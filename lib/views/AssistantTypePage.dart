import 'package:flutter/material.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/views/mobility.dart';

class AssistantTypePage extends StatefulWidget {
  String type;
  String? age;
  String? gender;
  String? selectedType;
  String? selectedDuration;

  AssistantTypePage({
    required this.type,
    this.gender,
    this.age,
    this.selectedType,
    this.selectedDuration,
    super.key,
  });

  @override
  State<AssistantTypePage> createState() => _AssistantTypePageState();
}

class _AssistantTypePageState extends State<AssistantTypePage> {
  String? selectedType;
  String? selectedDuration;
  double customDays = 4; // Default value for the slider

  @override
  void initState() {
    super.initState();
    selectedType = widget.selectedType;
    selectedDuration = widget.selectedDuration;
  }

  void navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientMobilityPage(
          type: widget.type,
          age: widget.age,
            inoutpatient:selectedType,
          gender: widget.gender,
          customeDays: customDays.toInt(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  selectedDuration = null;
                });
                navigateToNextPage();
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
                      "Medical care or treatment that does not require an overnight stay.",
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
                  selectedDuration = null;
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
                      "Medical care or treatment requiring a hospital stay.",
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
                      navigateToNextPage();
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
                      navigateToNextPage();
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
            if (selectedDuration == "Custom") ...[
              const SizedBox(height: 20),
              Text(
                "Select Number of Days: ${customDays.toInt()}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: customDays,
                min: 4,
                max: 31,
                divisions: 29,
                label: "${customDays.toInt()} Days",
                activeColor: primaryColor,
                inactiveColor: Colors.grey.shade300,
                onChanged: (value) {
                  setState(() {
                    customDays = value;
                  });
                },
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDuration = "${customDays.toInt()} Days";
                    });
                    navigateToNextPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Confirm Selection",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
