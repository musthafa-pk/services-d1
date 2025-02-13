import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/views/physiotherapy/addPatientLocation.dart';

class BasicDetailsPage extends StatefulWidget {
  String type;
  String? age;
  String? mobility;
  String? gender;

  BasicDetailsPage({
    required this.type,
    this.age,
    this.gender,
    this.mobility,
    Key? key,
  }) : super(key: key);

  @override
  State<BasicDetailsPage> createState() => _BasicDetailsPageState();
}

class _BasicDetailsPageState extends State<BasicDetailsPage> {
  String? selectedAvailability;
  String? selectedType;
  DateTime? date;
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        date = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate); // Display formatted date
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
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Add Basic\nDetails',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Date',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 8),
            TextField(
              controller: _dateController, // Use the controller
              decoration: InputDecoration(
                filled: true,
                fillColor: date != null ? primaryColor2 : Colors.white, // Change color if a date is selected
                hintText: 'Select a date',
                suffixIcon: Icon(Icons.calendar_today, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor), // Border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor), // Border color when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 1), // Border color when focused
                ),
              ),
              readOnly: true,
              onTap: _pickDate, // Call the date picker
            ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvailability = 'days';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: selectedAvailability == 'days' ? primaryColor2 : Colors.white,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Day/Night',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvailability = '24*7';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: selectedAvailability == '24*7' ? primaryColor2 : Colors.white,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '24*7',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'General';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: selectedType == 'General' ? primaryColor2 : Colors.white,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'General',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'Specialized';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: selectedType == 'Specialized' ? primaryColor2 : Colors.white,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Specialized',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.type == 'A') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPatientLocationPage(
                            type: widget.type,
                            selectedType: selectedType,
                            age: widget.age,
                            basicDate: date, // Send selected DateTime
                            gender: widget.gender,
                            dayNight: selectedAvailability,
                            gen_speci: selectedType,
                            mobility: widget.mobility,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
