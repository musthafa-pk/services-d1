import 'package:flutter/material.dart';
import 'package:services/views/additional.dart';

import '../constants/constants.dart';

class LocationTimingPage extends StatefulWidget {
  String type;
  String? delivryType;
  String? age;
  String? gender;

  LocationTimingPage({required this.type,required this.delivryType,this.age,this.gender,super.key});

  @override
  _LocationTimingPageState createState() => _LocationTimingPageState();
}

class _LocationTimingPageState extends State<LocationTimingPage> {
  TimeOfDay _selectedTime = TimeOfDay.now(); // Default to current time

  // Function to open the time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

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
            const Text(
              "Location & Timing",
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
            // Hospital Name Field
            _buildTextField("Hospital Name"),
            const SizedBox(height: 20),
            // Hospital Location Field
            _buildTextField("Hospital Location"),
            const SizedBox(height: 20),
            // Time Field with Time Picker
            _buildTimeField("Time"),
            const SizedBox(height: 20),
            // Home Location Field (conditionally visible)
            if (widget.delivryType == "Door to Door")...[
              _buildTextField("Home Location"),
      ],
            const Spacer(),
            // Skip Button
            ElevatedButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => Additional(
                 type: widget.type,
                 selectedType: 'Specialized',age: widget.age,gender: widget.gender,),));
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

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: primaryColor2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // Custom widget for time field
  Widget _buildTimeField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectTime(context), // Open time picker
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(
                text: _selectedTime.format(context), // Show selected time
              ),
              decoration: InputDecoration(
                filled: true,
                suffixIcon: Icon(Icons.alarm),
                fillColor: primaryColor2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
