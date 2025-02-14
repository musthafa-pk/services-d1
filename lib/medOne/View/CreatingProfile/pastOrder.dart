import 'dart:convert';
import 'package:doctor_one/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/appUrl.dart';
import '../../Constants/AppColors.dart';
import '../../MedOneConstants.dart';
import '../bottomNavMedOne.dart';


class MedicineListPastorder extends StatefulWidget {
  const MedicineListPastorder({super.key});

  @override
  State<MedicineListPastorder> createState() => _MedicineListPastorderState();
}

class _MedicineListPastorderState extends State<MedicineListPastorder> {
  // State for managing fetched medicine data
  List<Map<String, dynamic>> medicineList = [];
  bool isLoading = true;

  // State for managing selected medicines
  List<int> selectedMedicines = [];
  bool isSelectionMode = false;

  Future<void> fetchMedicineList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    // final String apiUrl = "http://13.232.117.141:3003/medone/getMedicineForSchedule";
    final String apiUrl = MedOneUrls.getCompleteMedicine;
    final Map<String, dynamic> requestBody = {
      "userId": userID
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true && responseBody['data'] != null) {
          // setState(() {
          //   medicineList = (responseBody['data'] as List).map((item) {
          //     // Extracting medicine details
          //     final medicine = item['medicine'][0];
          //     return {
          //       "id": medicine['id'], // Medicine ID
          //       "name": medicine['name'], // Medicine name
          //       "date": "Date unavailable", // Placeholder for date
          //       "image": "assets/pill.png", // Default image
          //     };
          //   }).toList();
          //
          //   // Populate selectedMedicines with IDs if needed (optional step)
          //   selectedMedicines =
          //       medicineList.map((medicine) => medicine['id'] as int).toList();
          // });
          setState(() {
            medicineList = (responseBody['data'] as List).map((item) {
              // Extracting medicine details
              final medicine = item['medicine'][0];
              return {
                "id": medicine['id'], // Medicine ID
                "name": medicine['name'], // Medicine name
                "date": item['startDate'], // Start date from the response
                "no_of_days": item['no_of_days'], // Number of days from the response
                "image": "assets/medone/pill.png", // Default image
              };
            }).toList();

            // Populate selectedMedicines with IDs if needed (optional step)
            selectedMedicines =
                medicineList.map((medicine) => medicine['id'] as int).toList();
          });

        } else {
          print("Error: ${responseBody['message']}");
        }
      } else {
        print("Failed to fetch medicines: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while fetching medicines: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Function to send selected medicines to the backend
  Future<void> sendSelectedMedicines() async {
    print('printing bf / send selected medi${selectedMedicines}');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');
    final String apiUrl =MedOneUrls.selectPastOrderMedicine;

    // Ensure selectedMedicines contains IDs of selected medicines
    final Map<String, dynamic> requestBody = {
      "userId": userId,
      "medicineIds": selectedMedicines,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
              (Route<dynamic> route) => false, // This condition removes all previous routes
        );
        if (responseBody['success'] == true) {
          print("Medicines successfully scheduled.");
          // Perform any additional actions here
        } else {
          print("Error: ${responseBody['message']}");
        }
      } else {
        print("Failed to schedule medicines: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while scheduling medicines: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMedicineList();
  }

  // Function to select all medicines
  void selectAllMedicines() {
    setState(() {
      selectedMedicines =
          medicineList.map((medicine) => medicine['id'] as int).toList();
      print('selected medicies...${selectedMedicines}');
    });
  }

  // Function to clear all selections
  void clearSelections() {
    setState(() {
      selectedMedicines.clear();
    });
  }

  // Function to check if all medicines are selected
  bool get areAllSelected {
    return selectedMedicines.length == medicineList.length;
  }

  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Do you want to schedule the selected medicines?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

                sendSelectedMedicines();
                print('Selected Medicines: $selectedMedicines');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _showConfirmationDialogforSingleMedicine(BuildContext context, List<int> medicineId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog can't be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to schedule this medicine?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                sendMedicine(medicineId);
                print('Sent Medicine: $medicineId');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendMedicine(List<int> medicineIds) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');
    final String apiUrl = MedOneUrls.selectPastOrderMedicine;

    // Ensure medicineIds contains the IDs of selected medicines
    final Map<String, dynamic> requestBody = {
      "userId":userId,
      "medicineIds": medicineIds, // Pass as list
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
              (Route<dynamic> route) => false, // Remove all previous routes
        );
        if (responseBody['success'] == true) {
          print("Medicines successfully scheduled.");
        } else {
          print("Error: ${responseBody['message']}");
        }
      } else {
        print("Failed to schedule medicines: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while scheduling medicines: $e");
    }
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isSelectionMode ? 'Select Medicines' : 'Medicine List',
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.pageColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        leading: isSelectionMode
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              isSelectionMode = false;
              selectedMedicines.clear();
            });
          },
        )
            : null,
        actions: [
          if (isSelectionMode && !areAllSelected)
            TextButton(
              onPressed: selectAllMedicines,
              child: const Text(
                'Select All',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : medicineList.isEmpty
          ? const Center(
        child: Text(
          'No past orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: medicineList.length,
              itemBuilder: (context, index) {
                final medicine = medicineList[index];
                final isSelected = selectedMedicines.contains(medicine['id']);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      tileColor: Colors.white,
                      onTap: () {
                        if (isSelectionMode) {
                          setState(() {
                            if (isSelected) {
                              selectedMedicines.remove(medicine['id']);
                            } else {
                              selectedMedicines.add(medicine['id']);
                            }
                          });
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          isSelectionMode = true;
                          // Select only the long-pressed medicine, clear other selections
                          selectedMedicines = [medicine['id']];
                        });
                      },
                      leading: isSelectionMode
                          ? Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedMedicines.add(medicine['id']);
                            } else {
                              selectedMedicines.remove(medicine['id']);
                            }
                          });
                        },
                      )
                          :  Image.asset(
                        'assets/medone/icons/multiSelect.png',
                        height: 30,
                        width: 30,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicine['name'],
                            style: text40016black,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                medicine['date'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _showConfirmationDialogforSingleMedicine(context, [medicine['id']]);


                                  print(medicine['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:pharmacyBlue,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Schedule',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (!isSelectionMode)

                            const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isSelectionMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (!areAllSelected)
                    ElevatedButton(
                      onPressed: selectedMedicines.isEmpty
                          ? null
                          : () {
                        _showConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        selectedMedicines.isEmpty ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Schedule Selected',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (areAllSelected)
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Schedule All',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),

    );
  }

}