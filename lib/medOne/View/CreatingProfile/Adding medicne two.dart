
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart'; // Required for date formatting
// import 'package:lottie/lottie.dart';
//
// import 'package:med_one/app_colors.dart';
// import 'package:med_one/res/appurl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Utils.dart';
// import '../../constants.dart';
// import '../../widgets/CustomWidgets.dart';
// import '../bottomnavigation.dart';
// import 'package:http/http.dart' as http;
//
// import 'Adding medcine one.dart';
// class AddingMedicineTwo extends StatefulWidget {
//   final Map<String, dynamic> selectedMedicine;
//   final String medicineName;
//   final String medicineType;
//
//   const AddingMedicineTwo(
//       {Key? key, required this.medicineName, required this.medicineType,required this.selectedMedicine})
//       : super(key: key);
//
//   @override
//   State<AddingMedicineTwo> createState() => _AddingMedicineTwoState();
// }
//
// class _AddingMedicineTwoState extends State<AddingMedicineTwo> {
//   bool isBeforeFood = true;
//   bool isMorning = false;
//   bool isAfternoon = false;
//   bool isNight = false;
//   bool checkingOr = false;
//
//   DateTime? _selectedStartDate; // To store the selected date
//
//   TextEditingController totalQuantityController = TextEditingController();
//   TextEditingController takingQuantityController = TextEditingController();
//   TextEditingController startDateController = TextEditingController();
//   TextEditingController numofDaysController = TextEditingController();
//   TextEditingController timeIntervalController = TextEditingController();
//   TextEditingController dateIntervalController = TextEditingController();
//
//   FocusNode totalQuantityNode = FocusNode();
//   FocusNode takingQuantityNode = FocusNode();
//   FocusNode startDateNode = FocusNode();
//   FocusNode numofDaysNode = FocusNode();
//   FocusNode timeIntervalNode = FocusNode();
//   FocusNode dateIntervalNode = FocusNode();
//   String userName = '';
//
//
//   final String apiUrl = AppUrl.addMedcineSchedule; // Replace with your actual API URL
//   // List<String> selectedTimings = [];
//
//   // Function to toggle the selection of timings
//   // void _toggleTiming(String timing, bool isSelected) {
//   //   setState(() {
//   //     if (isSelected) {
//   //       selectedTimings.add(timing); // Add timing to the list if selected
//   //     } else {
//   //       selectedTimings.remove(timing); // Remove timing from the list if deselected
//   //     }
//   //   });
//   // }
//   List<Map<String, String>> selectedTimings = [{}];
//   // bool isMorning = false;
//   // bool isAfternoon = false;
//   // bool isNight = false;
//
//   void _toggleTiming(String timing, bool isSelected) {
//     // Ensure we are working with the first object in the list
//     Map<String, String> timingMap = selectedTimings[0];
//
//     setState(() {
//       if (isSelected) {
//         // Add to the map with the correct key
//         if (timing == 'Morning') {
//           timingMap['time1'] = timing;
//         } else if (timing == 'lunch') {
//           timingMap['time2'] = timing;
//         } else if (timing == 'dinner') {
//           timingMap['time3'] = timing;
//         }
//       } else {
//         // Remove the timing entry based on its value
//         if (timing == 'Morning') {
//           timingMap.remove('time1');
//         } else if (timing == 'lunch') {
//           timingMap.remove('time2');
//         } else if (timing == 'dinner') {
//           timingMap.remove('time3');
//         }
//       }
//     });
//   }
//
//   List<Map<String, String>> getTimingList() {
//     return selectedTimings; // This will return the list directly
//   }
//
//   void _submitData() {
//     // Example payload for the API request
//     List<Map<String, String>> timingData = getTimingList();
//
//     // Convert the data to the desired JSON structure
//     print('Payload to send: $timingData'); // Debugging line to see the output
//     // Use your API request method here to send the payload
//     // Example: await sendDataToApi(payload);
//   }
//
//
//   Future<void> addMedicineData(dynamic postData) async {
//     final url = Uri.parse(apiUrl);
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(postData), // Convert the map to JSON
//       );
//       print('respppp:${jsonDecode(response.body)}');
//       if (response.statusCode == 200) {
//         // If the server returns a 200 OK response
//         final jsonResponse = jsonDecode(response.body);
//         print('Response data: $jsonResponse');
//        _showSuccessDialogOnmedication();
//         Utils.flushBarSuccessMessage('${jsonResponse['message']}', context);
//         // Handle the response data here, for example, show a success message
//       } else {
//         final jsonResponse = jsonDecode(response.body);
//         Utils.flushBarErrorMessage('${jsonResponse['message']}', context);
//         print('Failed to send data. Status code: ${response.statusCode}');
//         // Handle the error here, for example, show an error message
//       }
//     } catch (e) {
//       print('Error sending data: $e');
//       // Handle network or parsing error
//     }
//   }
//   void _validateInputs() {
//     if (totalQuantityController.text.isEmpty || int.tryParse(totalQuantityController.text) == null || int.parse(totalQuantityController.text) <= 0) {
//       // Show an error dialog or snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid total quantity')),
//       );
//       return;
//     }
//     // Continue with form submission
//   }
//
//   Future<void> _loadUserName() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       userName = preferences.getString("userName") ?? 'No user name found';
//     });
//   }
//
//   String _getFirstLetter() {
//     if (userName.isNotEmpty && userName != 'No user name found') {
//       return userName[0].toUpperCase();
//     }
//     return '?';
//   }
//
//   @override
//   void initState() {
//     print('sshshshsh::${widget.selectedMedicine}');
//     // TODO: implement initState
//     _selectedStartDate = DateTime.now();
//     _loadUserName();
//     print('selected type:${widget.medicineType}');
//     // Update the start date controller to show the current date
//     startDateController.text = DateFormat('yyyy/MM/dd').format(_selectedStartDate!);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.pageColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.pageColor,
//         leading: Dronewidgets.backButton(context),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CircleAvatar(backgroundColor: AppColors.primaryColor2,
//               child: TextButton(
//                 onPressed: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) => EditProfilePage()),
//                   // );
//                 },
//                 child: Text( _getFirstLetter(),style: text40018,),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//               Text(widget.medicineName, style: text60024),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildToggleButton('Before food', isBeforeFood, () {
//                 setState(() {
//                   isBeforeFood = true;
//                 });
//               }),
//               _buildToggleButton('After food', !isBeforeFood, () {
//                 setState(() {
//                   isBeforeFood = false;
//                 });
//               }),
//             ],
//           ),
//           const SizedBox(height: 20),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Total Quantity", style: text50018primary),
//
//                 TextFormField(
//                   controller: totalQuantityController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: const InputDecoration(hintText: 'Enter the quantity'),
//                 ),
//                 const SizedBox(height: 20),
//
//                 Text("Dosage per time", style: text50018primary),
//                 TextFormField(
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   controller: takingQuantityController,
//                   decoration: InputDecoration(
//                     hintText: 'Enter the quantity',
//                     suffixText: (widget.medicineType == 'Syrup' || widget.medicineType == 'Syringe') ? 'ml' : null,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 _buildDateAndDays(),
//               ],
//             ),
//                 const SizedBox(height: 20),
//
//           const Text(
//             'Timing',
//             style: TextStyle(fontSize: 16),
//           ),
//           const SizedBox(height: 11),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     _buildTimingButton('Morning', isMorning, () {
//           //       setState(() {
//           //         isMorning = !isMorning;
//           //         isMorning == true ? checkingOr = true: checkingOr = false;
//           //         _toggleTiming('Morning', isMorning);
//           //       });
//           //     }),
//           //     _buildTimingButton('Afternoon', isAfternoon, () {
//           //       setState(() {
//           //         isAfternoon = !isAfternoon;
//           //         isAfternoon == true ? checkingOr = true: checkingOr = false;
//           //         _toggleTiming('lunch', isAfternoon);
//           //       });
//           //     }),
//           //     _buildTimingButton('Night', isNight, () {
//           //       setState(() {
//           //         isNight = !isNight;
//           //         isNight == true ? checkingOr = true: checkingOr = false;
//           //         _toggleTiming('dinner', isNight);
//           //       });
//           //     }),
//           //   ],
//           // ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildTimingButton('Morning', isMorning, () {
//                       setState(() {
//                         isMorning = !isMorning;
//                         _toggleTiming('Morning', isMorning);
//                       });
//                     }),
//                     _buildTimingButton('Afternoon', isAfternoon, () {
//                       setState(() {
//                         isAfternoon = !isAfternoon;
//                         _toggleTiming('lunch', isAfternoon);
//                       });
//                     }),
//                     _buildTimingButton('Night', isNight, () {
//                       setState(() {
//                         isNight = !isNight;
//                         _toggleTiming('dinner', isNight);
//                       });
//                     }),
//                   ],
//                 ),
//
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 50.0),
//                   child: Divider(
//                     color: Colors.grey,
//                     thickness: 1,
//                     endIndent: 20,
//                   ),
//                 ),
//               ),
//               Text('Or', style: text40024black),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 50.0),
//                   child: Divider(
//                     color: Colors.grey,
//                     thickness: 1,
//                     indent: 20,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//                 const SizedBox(height: 10),
//           Row(
//             children: [
//               Text(
//                 "Every",
//                 style: text50018primary,
//               ),
//               const SizedBox(width: 10),
//               SizedBox(
//                 width: 95,
//                 child: TextFormField(
//                   controller: timeIntervalController,
//                   decoration:
//                   const InputDecoration(hintText: 'Enter hours'),
//                   readOnly: checkingOr,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "hours",
//                 style: text50018primary,
//               ),
//             ],
//           ),
//           Row(
//             children: [
//             Text(
//             "Every",
//             style: text50018primary,
//           ),
//           const SizedBox(width: 10),
//           SizedBox(
//             width: 100,
//             child: TextFormField(
//               readOnly: checkingOr,
//                 controller: dateIntervalController,
//                 keyboardType: TextInputType.number, // Allows number input
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//                 style: const TextStyle(fontSize: 18),
//             decoration: const InputDecoration(hintText: 'Enter days'),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           "days",
//           style: text50018primary,
//         )
//         ],
//       ),
//                 SizedBox(height: 30),
//                 Center(
//                   child: Dronewidgets.mainButton(
//                     title: 'Next',
//                     onPressed: () async {
//                       SharedPreferences preferences = await SharedPreferences.getInstance();
//                       String? userID = preferences.getString('userID');
//                       // Validate inputs
//                       if (totalQuantityController.text.isEmpty || int.tryParse(totalQuantityController.text) == null || int.parse(totalQuantityController.text) <= 0) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Please enter a valid total quantity')),
//                         );
//                         return;
//                       }
//                       // Prepare data
//                       var data = {
//                         "userId": int.parse(userID.toString()),
//                         "medicine":[widget.selectedMedicine],
//                         "medicine_type": widget.medicineType,
//                         "startDate": DateFormat('yyyy/MM/dd').format(_selectedStartDate!),
//                         "no_of_days": numofDaysController.text,
//                         "afterFd_beforeFd": isBeforeFood == false ? 'After food':'Before food',
//                         "totalQuantity": totalQuantityController.text,
//                         "timing": selectedTimings,
//                         "takingQuantity": takingQuantityController.text,
//                       };
//
//                       // Show success dialog
//                       // _showSuccessDialogOnmedication();
//                       // Optionally call the API to save data
//                       addMedicineData(data);
//                       print('Baa ${data}');
//                     },
//                   ),
//                 ),
//       const SizedBox(height: 100),
//       ],
//     ),
//     ),
//     ),
//     // floatingActionButton: Dronewidgets.mainButton(
//     // title: 'Next',
//     // onPressed: () {
//     // var data = {
//     // "userId": 45,
//     // "medicine":'${[widget.selectedMedicine]}',
//     // "medicine_type": widget.medicineType,
//     // "startDate": DateFormat('d-MM-yyyy').format(_selectedStartDate!),
//     // "no_of_days": numofDaysController.text,
//     // "afterFd_beforeFd": isBeforeFood == false ? 'After food':'Before food',
//     // "totalQuantity": totalQuantityController.text,
//     // "timing": selectedTimings,
//     // "takingQuantity": takingQuantityController.text,
//     //
//     // //or
//     // // "timeInterval":timeIntervalController,
//     // // "daysInterval":dateIntervalController,
//     // };
//     // _showSuccessDialogOnmedication();
//     // // addMedicineData(data);
//     // },
//     // ),
//
//       // floatingActionButton: Dronewidgets.mainButton(
//       //   title: 'Next',
//       //   onPressed: () async {
//       //     SharedPreferences preferences = await SharedPreferences.getInstance();
//       //     String? userID = preferences.getString('userID');
//       //     // Validate inputs
//       //     if (totalQuantityController.text.isEmpty || int.tryParse(totalQuantityController.text) == null || int.parse(totalQuantityController.text) <= 0) {
//       //       ScaffoldMessenger.of(context).showSnackBar(
//       //         SnackBar(content: Text('Please enter a valid total quantity')),
//       //       );
//       //       return;
//       //     }
//       //     // Prepare data
//       //     var data = {
//       //       "userId": int.parse(userID.toString()),
//       //       "medicine":[widget.selectedMedicine],
//       //       "medicine_type": widget.medicineType,
//       //       "startDate": DateFormat('yyyy/MM/dd').format(_selectedStartDate!),
//       //       "no_of_days": numofDaysController.text,
//       //       "afterFd_beforeFd": isBeforeFood == false ? 'After food':'Before food',
//       //       "totalQuantity": totalQuantityController.text,
//       //       "timing": selectedTimings,
//       //       "takingQuantity": takingQuantityController.text,
//       //     };
//       //
//       //     // Show success dialog
//       //     // _showSuccessDialogOnmedication();
//       //     // Optionally call the API to save data
//       //     addMedicineData(data);
//       //   },
//       // ),
//       //
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   // Method to show the date picker and store selected date
//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedStartDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedStartDate) {
//       setState(() {
//         _selectedStartDate = picked;
//         // Format the date and update the TextFormField controller
//         startDateController.text = DateFormat('yyyy/MM/dd').format(_selectedStartDate!);
//       });
//     }
//   }
//
//
//   Widget _buildToggleButton(
//       String text, bool isSelected, VoidCallback onPressed) {
//     return SizedBox(
//       width:150,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//           isSelected ? AppColors.primaryColor2 : AppColors.textfiedlColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         ),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: 14,
//             color: isSelected ? Colors.white : AppColors.textColor1,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimingButton(
//       String text, bool isSelected, VoidCallback onPressed) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor:
//         isSelected ? AppColors.primaryColor2 : AppColors.textfiedlColor,
//         padding: const EdgeInsets.all(20),
//       ),
//       onPressed: onPressed,
//       child: Text(
//         text,
//         style: TextStyle(
//           fontWeight: FontWeight.w400,
//           fontSize: 14,
//           color: isSelected ? Colors.white : AppColors.textColor1,
//         ),
//       ),
//     );
//   }
//   void _showSuccessDialogOnmedication() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing by tapping outside the dialog
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Lottie.asset(
//                 'assets/lottie/profiledone1.json', // Path to your Lottie animation file
//                 height: 183,
//                 width: 189,
//               ),
//               Text(
//                 'You have successfully added',
//                 style: TextStyle(fontSize: 16),
//               ),
//               Center(
//                 child: Text(
//                   'medicine name',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Dronewidgets.mainButton(title: 'Add Medication', onPressed: (){
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddingMedicineone()),
//                       (Route<dynamic> route) => false, // This condition removes all previous routes
//                 );
//
//               }),
//               SizedBox(height: 10,),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (context) => BottomNavigation()),
//                         (Route<dynamic> route) => false, // This condition removes all previous routes
//                   );
//
//
//                 },
//                 child: Text('I’m done'),
//               ),
//             ],
//           ),
//
//         );
//       },
//     );
//   }
//   Widget _buildDateAndDays() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Start date", style: text50018primary),
//     GestureDetector(
//     onTap: () {
//     _selectStartDate(context);
//     },
//     child: AbsorbPointer(
//     child: TextFormField(
//     controller: startDateController,
//     readOnly: true, // Make the date field read-only
//     decoration: const InputDecoration(hintText: 'Select the start date'),
//     ),
//     ),
//     )
//             ],
//           ),
//         ),
//         const SizedBox(width: 20),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("No. of days", style: text50018primary),
//               TextFormField(
//                 controller: numofDaysController,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 decoration: const InputDecoration(hintText: 'Type here'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }




import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Required for date formatting
import 'package:lottie/lottie.dart';
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../../res/appUrl.dart';
import '../../../utils/utils.dart';
import '../../Constants/AppColors.dart';
import '../../MedOneConstants.dart';
import '../../MedOneWidgets/customWidgets.dart';
import '../bottomNavMedOne.dart';
import 'Adding medicine one.dart';
class AddingMedicineTwo extends StatefulWidget {
  final Map<String, dynamic> selectedMedicine;
  final String medicineName;
  final String medicineType;

  const AddingMedicineTwo(
      {Key? key, required this.medicineName, required this.medicineType,required this.selectedMedicine})
      : super(key: key);

  @override
  State<AddingMedicineTwo> createState() => _AddingMedicineTwoState();
}

class _AddingMedicineTwoState extends State<AddingMedicineTwo> {
  bool isBeforeFood = true;
  bool isMorning = false;
  bool isAfternoon = false;
  bool isNight = false;
  bool checkingOr = false;
  bool areButtonsEnabled = true; // To control whether the timing buttons are active
  bool hideTiming = false;
  bool areTextFieldsEnabled = true; // To control whether the text fields are editabl
  DateTime? _selectedStartDate; // To store the selected date
  bool isHoursFieldEnabled = true; // To enable/disable hours input
  bool isDaysFieldEnabled = true; // To enable/disable days input

  TextEditingController totalQuantityController = TextEditingController();
  TextEditingController takingQuantityController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController numofDaysController = TextEditingController();
  TextEditingController timeIntervalController = TextEditingController();
  TextEditingController dateIntervalController = TextEditingController();

  FocusNode totalQuantityNode = FocusNode();
  FocusNode takingQuantityNode = FocusNode();
  FocusNode startDateNode = FocusNode();
  FocusNode numofDaysNode = FocusNode();
  FocusNode timeIntervalNode = FocusNode();
  FocusNode dateIntervalNode = FocusNode();
  String userName = '';


  final String apiUrl = MedOneUrls.addMedcineSchedule; // Replace with your actual API URL
  // List<String> selectedTimings = [];

  // Function to toggle the selection of timings
  // void _toggleTiming(String timing, bool isSelected) {
  //   setState(() {
  //     if (isSelected) {
  //       selectedTimings.add(timing); // Add timing to the list if selected
  //     } else {
  //       selectedTimings.remove(timing); // Remove timing from the list if deselected
  //     }
  //   });
  // }
  List<Map<String, String>> selectedTimings = [{}];
  // bool isMorning = false;
  // bool isAfternoon = false;
  // bool isNight = false;

  void _toggleTiming(String timing, bool isSelected) {
    // Ensure we are working with the first object in the list
    Map<String, String> timingMap = selectedTimings[0];

    setState(() {
      if (isSelected) {
        // Add to the map with the correct key
        if (timing == 'Morning') {
          timingMap['time1'] = timing;
        } else if (timing == 'lunch') {
          timingMap['time2'] = timing;
        } else if (timing == 'dinner') {
          timingMap['time3'] = timing;
        }
      } else {
        // Remove the timing entry based on its value
        if (timing == 'Morning') {
          timingMap.remove('time1');
        } else if (timing == 'lunch') {
          timingMap.remove('time2');
        } else if (timing == 'dinner') {
          timingMap.remove('time3');
        }
      }
    });
  }

  List<Map<String, String>> getTimingList() {
    return selectedTimings; // This will return the list directly
  }

  void _submitData() {
    // Example payload for the API request
    List<Map<String, String>> timingData = getTimingList();

    // Convert the data to the desired JSON structure
    print('Payload to send: $timingData'); // Debugging line to see the output
    // Use your API request method here to send the payload
    // Example: await sendDataToApi(payload);
  }

  Future<void> addMedicineData(dynamic postData) async {
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(postData), // Convert the map to JSON
      );
      print('respppp:${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response
        final jsonResponse = jsonDecode(response.body);
        print('Response data: $jsonResponse');
        _showSuccessDialogOnmedication();
        Util.flushBarSuccessMessage(pharmacyBlue,'${jsonResponse['message']}', context);
        // Handle the response data here, for example, show a success message
      } else {
        final jsonResponse = jsonDecode(response.body);
        Util.flushBarErrorMessage('${jsonResponse['message']}', context);
        print('Failed to send data. Status code: ${response.statusCode}');
        // Handle the error here, for example, show an error message
      }
    } catch (e) {
      print('Error sending data: $e');
      // Handle network or parsing error
    }
  }
  void _validateInputs() {
    if (totalQuantityController.text.isEmpty || int.tryParse(totalQuantityController.text) == null || int.parse(totalQuantityController.text) <= 0) {
      // Show an error dialog or snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid total quantity')),
      );
      return;
    }
    // Continue with form submission
  }
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
  void initState() {
    print('sshshshsh::${widget.selectedMedicine}');
    // TODO: implement initState
    _selectedStartDate = DateTime.now();
    _loadUserName();
    print('selected type:${widget.medicineType}');
    // Update the start date controller to show the current date
    startDateController.text = DateFormat('yyyy/MM/dd').format(_selectedStartDate!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageColor,
        leading: Dronewidgets.backButton(context),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(backgroundColor: AppColors.primaryColor2,
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                  // );
                },
                child: Text( _getFirstLetter(),style: text40018,),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.medicineName, style: text60024),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildToggleButton('Before food', isBeforeFood, () {
                    setState(() {
                      isBeforeFood = true;
                    });
                  }),
                  _buildToggleButton('After food', !isBeforeFood, () {
                    setState(() {
                      isBeforeFood = false;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Quantity", style: text50018primary),

                  TextFormField(
                    controller: totalQuantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(hintText: 'Enter the quantity'),
                  ),
                  const SizedBox(height: 20),

                  Text("Dosage per time", style: text50018primary),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: takingQuantityController,
                    decoration: InputDecoration(
                      hintText: 'Enter the quantity',
                      suffixText: (widget.medicineType == 'Syrup' || widget.medicineType == 'Syringe') ? 'ml' : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildDateAndDays(),
                ],
              ),
              const SizedBox(height: 20),

              !hideTiming?Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Timing',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 11),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     _buildTimingButton('Morning', isMorning, () {
                  //       if (areButtonsEnabled) {
                  //         setState(() {
                  //           isMorning = !isMorning;
                  //           _toggleTiming('Morning', isMorning);
                  //           areTextFieldsEnabled = false; // Disable text fields when button is clicked
                  //         });
                  //       }
                  //     }),
                  //     _buildTimingButton('Afternoon', isAfternoon, () {
                  //       if (areButtonsEnabled) {
                  //         setState(() {
                  //           isAfternoon = !isAfternoon;
                  //           _toggleTiming('Afternoon', isAfternoon);
                  //           areTextFieldsEnabled = false; // Disable text fields when button is clicked
                  //         });
                  //       }
                  //     }),
                  //     _buildTimingButton('Night', isNight, () {
                  //       if (areButtonsEnabled) {
                  //         setState(() {
                  //           isNight = !isNight;
                  //           _toggleTiming('Night', isNight);
                  //           areTextFieldsEnabled = false; // Disable text fields when button is clicked
                  //         });
                  //       }
                  //     }),
                  //   ],
                  // ),



                  ///ss
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimingButton('Morning', isMorning, () {
                        setState(() {
                          isMorning = !isMorning;
                          _toggleTiming('Morning', isMorning);
                        });
                      }),
                      _buildTimingButton('Afternoon', isAfternoon, () {
                        setState(() {
                          isAfternoon = !isAfternoon;
                          _toggleTiming('lunch', isAfternoon);
                        });
                      }),
                      _buildTimingButton('Night', isNight, () {
                        setState(() {
                          isNight = !isNight;
                          _toggleTiming('dinner', isNight);
                        });
                      }),
                    ],
                  ),
                ],
              ):Text(''),



              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        endIndent: 20,
                      ),
                    ),
                  ),
                  Text('Or', style: text40024black),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (areTextFieldsEnabled) {
                    setState(() {
                      // areButtonsEnabled = false; // Disable buttons when the text fields are active
                    });
                  }
                },
                child: Row(
                  children: [
                    Text("Every", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 95,
                      child: TextFormField(
                        controller: timeIntervalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Enter hours'),
                        readOnly: !areTextFieldsEnabled || !isHoursFieldEnabled, // Disable input when not active or disabled
                        onChanged: (value) {
                          setState(() {
                            areButtonsEnabled = false; // Disable buttons if text is entered
                            isDaysFieldEnabled = value.isEmpty; // Disable days field if hours field is active
                            // showFlushbar(context, 'Please select either hours or days, not both', Colors.red);

                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("hours", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (areTextFieldsEnabled) {
                    setState(() {
                      areButtonsEnabled = false; // Disable buttons when the text fields are active
                      // showFlushbar(context, 'Please select either hours or days, not both', Colors.red);
                    });
                  }
                },
                child: Row(
                  children: [
                    Text("Every", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: dateIntervalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Enter days'),
                        readOnly: !areTextFieldsEnabled || !isDaysFieldEnabled, // Disable input when not active or disabled
                        onChanged: (value) {
                          setState(() {
                            // areButtonsEnabled = value.isEmpty; // Disable buttons if text is entered
                            hideTiming = !hideTiming;
                            isHoursFieldEnabled = value.isEmpty; // Disable hours field if days field is active
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("days", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              hideTiming?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Timing',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 11),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     _buildTimingButton('Morning', isMorning, () {
                  //       if (areButtonsEnabled) {
                  //         setState(() {
                  //           isMorning = !isMorning;
                  //           _toggleTiming('Morning', isMorning);
                  //           areTextFieldsEnabled = false; // Disable text fields when button is clicked
                  //         });
                  //       }
                  //     }),
                  //     _buildTimingButton('Afternoon', isAfternoon, () {
                  //       if (areButtonsEnabled) {
                  //         setState(() {
                  //           isAfternoon = !isAfternoon;
                  //           _toggleTiming('Afternoon', isAfternoon);
                  //           areTextFieldsEnabled = false; // Disable text fields when button is clicked
                  //         });
                  //       }
                  //     }),
                  //     _buildTimingButton('Night', isNight, () {
                  //       if (areButtonsEnabled) {
                  //         setState(() {
                  //           isNight = !isNight;
                  //           _toggleTiming('Night', isNight);
                  //           areTextFieldsEnabled = false; // Disable text fields when button is clicked
                  //         });
                  //       }
                  //     }),
                  //   ],
                  // ),



                  ///ss
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimingButton('Morning', isMorning, () {
                        setState(() {
                          isMorning = !isMorning;
                          _toggleTiming('Morning', isMorning);
                        });
                      }),
                      _buildTimingButton('Afternoon', isAfternoon, () {
                        setState(() {
                          isAfternoon = !isAfternoon;
                          _toggleTiming('lunch', isAfternoon);
                        });
                      }),
                      _buildTimingButton('Night', isNight, () {
                        setState(() {
                          isNight = !isNight;
                          _toggleTiming('dinner', isNight);
                        });
                      }),
                    ],
                  ),
                ],
              ):Text(''),
              SizedBox(height: 30),
              Center(
                child: Dronewidgets.mainButton(
                  title: 'Next',
                  onPressed: () async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    int? userID = preferences.getInt('userId');
                    // Validate inputs
                    if (totalQuantityController.text.isEmpty || int.tryParse(totalQuantityController.text) == null || int.parse(totalQuantityController.text) <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid total quantity')),
                      );
                      return;
                    }
                    // Prepare data
                    var data = {
                      "userId": int.parse(userID.toString()),
                      "medicine":[widget.selectedMedicine],
                      "medicine_type": widget.medicineType,
                      "startDate": DateFormat('yyyy/MM/dd').format(_selectedStartDate!),
                      "no_of_days": numofDaysController.text,
                      "afterFd_beforeFd": isBeforeFood == false ? 'After food':'Before food',
                      "totalQuantity": totalQuantityController.text,
                      "timing": selectedTimings,
                      "takingQuantity": takingQuantityController.text,
                      "timeInterval":timeIntervalController.text,
                      "daysInterval":dateIntervalController.text
                    };
                    addMedicineData(data);
                    print('hl.. ${data}');
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show the date picker and store selected date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        // Format the date and update the TextFormField controller
        startDateController.text = DateFormat('yyyy/MM/dd').format(_selectedStartDate!);
      });
    }
  }
  Widget _buildToggleButton(
      String text, bool isSelected, VoidCallback onPressed) {
    return SizedBox(
      width:150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isSelected ? AppColors.primaryColor2 : AppColors.textfiedlColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isSelected ? Colors.white : AppColors.textColor1,
          ),
        ),
      ),
    );
  }
  Widget _buildTimingButton(String text, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primaryColor2 : AppColors.textfiedlColor,
        padding: const EdgeInsets.all(20),
      ),
      onPressed: areButtonsEnabled ? onPressed : null, // Disable button if areButtonsEnabled is false
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: isSelected ? Colors.white : AppColors.textColor1,
        ),
      ),
    );
  }

  void _showSuccessDialogOnmedication() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/medone/lottie/profiledone1.json', // Path to your Lottie animation file
                height: 183,
                width: 189,
              ),
              Text(
                'You have successfully added',
                style: TextStyle(fontSize: 16),
              ),
              Center(
                child: Text(
                  'medicine name',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10,),
              Dronewidgets.mainButton(title: 'Add Medication', onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AddingMedicineone()),
                      (Route<dynamic> route) => false, // This condition removes all previous routes
                );
              }),
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavigation()),
                        (Route<dynamic> route) => false, // This condition removes all previous routes
                  );
                },
                child: Text('I’m done'),
              ),
            ],
          ),

        );
      },
    );
  }
  Widget _buildDateAndDays() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Start date", style: text50018primary),
              GestureDetector(
                onTap: () {
                  _selectStartDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: startDateController,
                    readOnly: true, // Make the date field read-only
                    decoration: const InputDecoration(hintText: 'Select the start date'),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("No. of days", style: text50018primary),
              TextFormField(
                controller: numofDaysController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: 'Type here'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void showFlushbar(BuildContext context, String message, Color backgroundColor) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: backgroundColor,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(8),
    )..show(context);
  }
}