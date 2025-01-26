import 'package:flutter/material.dart';
import 'package:services/utils/utils.dart';
import 'package:services/views/age.dart';

class Gender extends StatefulWidget {
  String type;
  Gender({required this.type, super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String? selectedGender; // To track the selected gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'Specify patient\nGender!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'Male';
                    Util.toastMessage('Selected Gender is $selectedGender');
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgePage(
                        type: widget.type,
                        gender: 'Male',
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor:
                  selectedGender == 'Male' ? Colors.blue : Colors.grey[300], // Highlight if selected
                  child: Image.asset('assets/images/male.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Male',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: selectedGender == 'Male' ? FontWeight.bold : FontWeight.normal, // Bold if selected
                    color: selectedGender == 'Male' ? Colors.blue : Colors.black, // Change color if selected
                  ),
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'Female';
                    Util.toastMessage('Selected Gender is $selectedGender');
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgePage(
                        type: widget.type,
                        gender: 'Female',
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: selectedGender == 'Female'
                      ? Colors.pink
                      : Colors.grey[300], // Highlight if selected
                  child: Image.asset('assets/images/female.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Female',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: selectedGender == 'Female' ? FontWeight.bold : FontWeight.normal, // Bold if selected
                    color: selectedGender == 'Female' ? Colors.pink : Colors.black, // Change color if selected
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
