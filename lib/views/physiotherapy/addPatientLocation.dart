import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/views/additional.dart';
import 'package:services/views/physiotherapy/basicDetailTherapy.dart';

class AddPatientLocationPage extends StatefulWidget {
  String? selectedType;
  String type;
  AddPatientLocationPage({required this.type,this.selectedType,Key? key}) : super(key: key);

  @override
  State<AddPatientLocationPage> createState() => _AddPatientLocationPageState();
}

class _AddPatientLocationPageState extends State<AddPatientLocationPage> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Add Patient\nLocation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3F8),
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        hintText: "Enter location",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.grey),
                    onPressed: () {
                      // Add location logic here
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(widget.type=='A'){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Additional(selectedType: widget.selectedType,),));
                  }
                  else if(widget.type == 'C'){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>BasicDetailTherapy() ,));
                  }
                  // Navigate to the next page

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
