
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../MedOneConstants.dart';
import '../MedOneWidgets/customWidgets.dart';
import '../View/bottomNavMedOne.dart';

class EditDailyRoutine extends StatefulWidget {
  const EditDailyRoutine({super.key});

  @override
  State<EditDailyRoutine> createState() => _EditDailyRoutineState();
}

class _EditDailyRoutineState extends State<EditDailyRoutine> {
  var getRoutine = MedOneUrls.gettingRoutine;
  var editRoutine = MedOneUrls.editRoutine;
  List<TimeOfDay> routineTimes = List.generate(6, (index) => TimeOfDay.now());
  bool isLoading = true;

  final List<String> routineImages = [
    'assets/medone/images/awaken.png',
    'assets/medone/images/exercising.png',
    'assets/medone/images/breakfast 1.png',
    'assets/medone/images/lunch-box.png',
    'assets/medone/images/roti 1.png',
    'assets/medone/images/sleep.png',
  ];

  @override
  void initState() {
    super.initState();
    _fetchRoutine();
  }

  Future<void> _fetchRoutine() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final url = Uri.parse(getRoutine);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userID}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          isLoading = false;
          routineTimes = _parseRoutineTimes(responseData['data'][0]['routine'][0]);
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<TimeOfDay> _parseRoutineTimes(Map<String, dynamic> routine) {
    return [
      _stringToTimeOfDay(routine['wakeUp']),
      _stringToTimeOfDay(routine['exercise']),
      _stringToTimeOfDay(routine['breakfast']),
      _stringToTimeOfDay(routine['lunch']),
      _stringToTimeOfDay(routine['dinner']),
      _stringToTimeOfDay(routine['sleep']),
    ];
  }

  TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hour != 12) {
      return TimeOfDay(hour: hour + 12, minute: minute);
    } else if (parts[1] == 'AM' && hour == 12) {
      return TimeOfDay(hour: 0, minute: minute);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _saveRoutine() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final url = Uri.parse(editRoutine);
    final routineData = {
      'userId': userID,
      'routine': [
        {
          'wakeUp': routineTimes[0].format(context),
          'exercise': routineTimes[1].format(context),
          'breakfast': routineTimes[2].format(context),
          'lunch': routineTimes[3].format(context),
          'dinner': routineTimes[4].format(context),
          'sleep': routineTimes[5].format(context),
        },
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(routineData),
      );
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update routine.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving routine: $error')),
      );
    }
  }

  Future<void> _selectTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: routineTimes[index],
    );

    if (picked != null) {
      setState(() {
        routineTimes[index] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Routine', style: text40014black),
        leading: Dronewidgets.backButton(context),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(
              routineTimes.length,
                  (index) => Stack(
                children: [
                  if (index != routineTimes.length - 1)
                    Positioned(
                      top: 48,
                      left: screenSize.width * 0.1,
                      child: Container(
                        height: screenSize.height * 0.05,
                        width: 2,
                        color: Colors.blue,
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: screenSize.width * 0.08,
                        backgroundImage: AssetImage(routineImages[index]),
                      ),
                      SizedBox(width: screenSize.width * 0.05),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(index),
                          child: Card(
                            color: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenSize.width * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ['Wake Up', 'Exercise', 'Breakfast', 'Lunch', 'Dinner', 'Sleep'][index],
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height * 0.005),
                                  Text(
                                    routineTimes[index].format(context),
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.045,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Dronewidgets.mainButton(
                title: 'Edit Routine',
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Are you ready to save the data?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          _saveRoutine();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}