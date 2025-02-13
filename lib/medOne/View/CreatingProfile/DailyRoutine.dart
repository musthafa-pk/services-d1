import 'package:another_flushbar/flushbar.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../res/appUrl.dart';
import '../../Constants/AppColors.dart';
import '../../MedOneConstants.dart';
import '../../MedOneWidgets/customWidgets.dart';
import 'Adding medicine one.dart';
import 'Pastorder.dart';


class DailyRoutine extends StatefulWidget {
  const DailyRoutine({super.key});

  @override
  State<DailyRoutine> createState() => _DailyRoutineState();
}

class _DailyRoutineState extends State<DailyRoutine> {
  int backPressCounter = 0; // Track back button presses
  DateTime currentDate = DateTime.now();
  List<TimeOfDay> selectedTimes = [
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
    TimeOfDay(hour: 22, minute: 0),
  ];

  String _timeOfDayToString(TimeOfDay time) {
    final hours = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minutes = time.minute.toString().padLeft(2, '0');
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hours:$minutes $amPm';
  }

  Map<String, dynamic> _convertToRoutine(int userid)  {
    
    return {
      'userId': userid,
      'routine': [
        {
          'wakeUp': _timeOfDayToString(selectedTimes[0]),
          'breakfast': _timeOfDayToString(selectedTimes[1]),
          'exercise': _timeOfDayToString(selectedTimes[2]),
          'lunch': _timeOfDayToString(selectedTimes[3]),
          'dinner': _timeOfDayToString(selectedTimes[4]),
          'sleep': _timeOfDayToString(selectedTimes[5]),
        },
      ],
    };
  }
  Future<void> _sendRoutineToBackend() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');
    final routineData = _convertToRoutine(userId!);
    final url = Uri.parse(MedOneUrls.addingRoutine);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(routineData),
      );
      print(url);
      print('routtwwww ${routineData}');
      print('ashannne ${response.body}');
      print('ashannne ${response.statusCode}');
      if (response.statusCode == 200) {
        
        _showFlushbar("Routine saved successfully!", Colors.green);
        print('Routine saved: ${response.body}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddingMedicineone()));
        // _showMedicationOptionsDialog(context);
      } else {
        _showFlushbar("Failed to save routine. Error: ${response.statusCode}", Colors.red);
      }
    } catch (error) {
      _showFlushbar("Error sending data: $error", Colors.red);
    }
  }

  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      backgroundColor: color,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  bool _validateRoutine() {
    // Check if all selected times are provided (can add more checks if needed)
    for (var time in selectedTimes) {
      if (time == null) {
        return false; // Invalid if any time is missing
      }
    }
    return true; // Valid if all fields are filled
  }
  String userName = '';
  Future<void> _loadUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString("userName") ?? 'No user name found';
    });
  }

  String _getFirstLetter() {
    if (userName.isNotEmpty && userName != 'No user name found') {
      return userName[0].toUpperCase();
    }
    return '?';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dronewidgets.mainButton(
          title: 'Next',
          textColor: Colors.black,
          onPressed: () =>
              showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Are you ready to save the data?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                TextButton(
                  onPressed: () {
                    if (_validateRoutine()) {
                      _sendRoutineToBackend();
                      // _showMedicationOptionsDialog(context);
                    } else {
                      _showFlushbar("Please complete all fields before submitting.", Colors.red);
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // appBar: AppBar(automaticallyImplyLeading: false,
      //     actions: [
      //       // ElevatedButton(onPressed: () {
      //       //   Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //       //       AddingMedicineone(
      //       //         // name: '',
      //       //         // gender: '',
      //       //         // dateOfBirth:'',
      //       //         // healthCondition:'', // Pass the new field
      //       //         // height: '', // Pass the new field
      //       //         // weight: '', userId: 45, // Pass the new field
      //       //       )));
      //       //
      //       // }, child: Text('Skip', style: text40018primary)),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: CircleAvatar(backgroundColor: AppColors.primaryColor2,
      //           child: TextButton(
      //             onPressed: () {
      //               // Navigator.push(
      //               //   context,
      //               //   MaterialPageRoute(builder: (context) => EditProfilePage()),
      //               // );
      //             },
      //             child: Text( _getFirstLetter(),style: text40018,),
      //           ),
      //         ),
      //       ),
      //
      //     ],
      //
      //     // leading: Dronewidgets.backButton(context)
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'How does your ', style: text60024),
                      TextSpan(text: 'day', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: AppColors.primaryColor2)),
                      TextSpan(text: ' look like?', style: text60024),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                  ),
                  height: 500,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    // Adjust the position of the first time picker (Wake up) and add some space above the asset
                                    Positioned(left: 80, top: 8, child: _buildTimePickerContainer(0)),  // Moved top to 10 to make it more visible
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50.0), // Added more space above the image
                                      child: Image.asset('assets/medone/images/s.png'),
                                    ),
                                    Positioned(left: 5,top: 22, child: _buildTooltip('Wake up', 'assets/medone/images/awaken.png')),

                                    // Other time pickers remain the same, but we can tweak them as needed for spacing and visibility
                                    Positioned(right: 110, top: 90, child: _buildTimePickerContainer(1)),
                                    Positioned(right: 50,top: 25, child: _buildTooltip('Exercise', 'assets/medone/images/exercising.png')),

                                    Positioned(right: 115, top: 200, child: _buildTimePickerContainer(2)),
                                    Positioned(right: 50, top: 220, child: _buildTooltip('Breakfast', 'assets/medone/images/breakfast 1.png')),

                                    Positioned(left: 80, top: 290, child: _buildTimePickerContainer(3)),
                                    Positioned(top: 250, left: 10, child: _buildTooltip('Lunch', 'assets/medone/images/lunch-box.png')),

                                    Positioned(left: 80, top: 390, child: _buildTimePickerContainer(4)),
                                    Positioned(left: 80, top: 430, child: _buildTooltip('Dinner', 'assets/medone/images/roti 1.png')),

                                    Positioned(top: 430, right: 20, child: _buildTooltip('Sleep', 'assets/medone/images/sleep.png')),
                                    Positioned(right: 20, top: 390, child: _buildTimePickerContainer(5)),
                                    SizedBox(height: 500,)


                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerContainer(int index) {
    return GestureDetector(
      onTap: () => _selectTime(index),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color:pharmacyBlueLight,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('${selectedTimes[index].format(context)}')),
        ),
      ),
    );
  }

  Future<void> _selectTime(int index) async {
    final picked = await showTimePicker(context: context, initialTime: selectedTimes[index]);
    if (picked != null) setState(() => selectedTimes[index] = picked);
  }

  Widget _buildTooltip(String message, String imagePath) {
    return Tooltip(
      message: message,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Color.fromRGBO(125, 210, 255, 1),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }


  // void _showMedicationOptionsDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       backgroundColor: AppColors.containercolor,
  //
  //       content: medicationOptionsContainer(context),
  //
  //     ),
  //   );
  // }

  void _showMedicationOptionsDialog(BuildContext context) {
    bool _backPressedOnce = false;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing when tapping outside the dialog
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_backPressedOnce) {
            // If back is pressed again, close the dialog
            return true;
          } else {
            // Show "Press back again to exit" message
            _backPressedOnce = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press back again to exit'),
                duration: Duration(seconds: 2),
              ),
            );
            Future.delayed(Duration(seconds: 2), () {
              _backPressedOnce = false; // Reset after 2 seconds
            });
            return false; // Prevent dialog from closing on the first back press
          }
        },
        child: AlertDialog(
          backgroundColor: AppColors.containercolor,
          content: medicationOptionsContainer(context),
        ),
      ),
    );
  }



  // Your medicationOptionsContainer function
  static Widget medicationOptionsContainer(BuildContext context) {
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Do you have any past orders or need to add it manually?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // "Past order" button
          Dronewidgets.mainButton(title: 'Past order', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineListPastorder(),));
            // Navigator.pop(context);

          }
          ),
          SizedBox(height: 12),
          // "Add Medication" button
          Dronewidgets.mainButton(title: 'Add Medication', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddingMedicineone()));

          })

        ],
      ),
    );
  }
}