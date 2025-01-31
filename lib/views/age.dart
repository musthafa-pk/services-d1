import 'package:flutter/material.dart';
import 'package:services/utils/utils.dart';
import 'package:services/views/AssistantTypePage.dart';
import 'package:services/views/addLocation.dart';
import 'package:services/views/basicDetails.dart';
import 'package:services/views/physiotherapy/addPatientLocation.dart';

import '../constants/constants.dart';

class AgePage extends StatefulWidget {
  String type;
  String gender;
  String? mobility;
  AgePage({required this.type,required this.gender,this.mobility,Key? key}) : super(key: key);

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  int selectedAge = 25;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selectedAge - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void smoothScrollToItem(int index) {
    _controller.animateToItem(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Specify Patient\nAge',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (selectedAge > 1) {
                      setState(() {
                        selectedAge--;
                      });
                      smoothScrollToItem(selectedAge - 1);
                    }
                  },
                  icon: const Icon(Icons.arrow_left, color: primaryColor),
                ),
                SizedBox(
                  height: 400,
                  width: 200,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    perspective: 0.003,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedAge = index + 1;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final age = index + 1;
                        return Text(
                          '$age',
                          style: TextStyle(
                            fontSize: age == selectedAge ? 32 : 24,
                            fontWeight: FontWeight.bold,
                            color: age == selectedAge
                                ? Colors.black
                                : Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                      childCount: 100, // Max age limit
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (selectedAge < 100) {
                      setState(() {
                        selectedAge++;
                      });
                      smoothScrollToItem(selectedAge - 1);
                    }
                  },
                  icon: const Icon(Icons.arrow_right, color: primaryColor),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Util.toastMessage('Selected Age is $selectedAge');
                      if(widget.type=='A'){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BasicDetailsPage(
                          type: widget.type,
                          age: selectedAge.toString(),
                          mobility: widget.mobility,
                        ),));
                      }else if(widget.type=='B'){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AssistantTypePage(type: widget.type,age: selectedAge.toString(),gender: widget.gender,),));
                      }
                      else if(widget.type=="C"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPatientLocationPage(
                          type: widget.type,
                          gender: widget.gender,
                          age: selectedAge.toString(),
                        ),));
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssistantTypePage(type: widget.type,age: selectedAge.toString(),),
                          ),
                        );
                      }
        
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
