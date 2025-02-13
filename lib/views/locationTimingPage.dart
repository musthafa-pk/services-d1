import 'dart:convert';

import 'package:doctor_one/res/appUrl.dart';
import 'package:flutter/material.dart';
import 'package:doctor_one/views/additional.dart';

import '../constants/constants.dart';

import '../constants/widgets/widgetsfordoctor1.dart';
import 'package:http/http.dart' as http;

class LocationTimingPage extends StatefulWidget {
  String type;
  String? delivryType;
  String? age;
  String? gender;
  String? inoutpatient;
  String? pickup;
  String? mobility;
  int? customeDays;

  LocationTimingPage({required this.type,
    required this.delivryType,
    this.age,
    this.gender,
    this.inoutpatient,
    this.pickup,
    this.mobility,
    this.customeDays,
    super.key});

  @override
  _LocationTimingPageState createState() => _LocationTimingPageState();
}

class _LocationTimingPageState extends State<LocationTimingPage> {
  TimeOfDay _selectedTime = TimeOfDay.now(); // Default to current time

  TextEditingController hospitalName = TextEditingController();
  TextEditingController hospitalLocation = TextEditingController();
  TextEditingController homeLocation = TextEditingController();

  List<Map<String, dynamic>> addressListhopital = [];
  List<Map<String, dynamic>> addressListhome = [];
  TextEditingController hospitalpincodeController = TextEditingController();
  TextEditingController homepincodeController = TextEditingController();

  List<String> hospitalNames = [];
  List<String> filteredHospitals = [];
  bool isLoading = true;

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

  Future<void> fetchHospitals() async {
    final response = await http.get(Uri.parse(AppUrl.gethospitals));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse["success"] == true) {
        setState(() {
          hospitalNames = (jsonResponse["data"] as List)
              .map((hospital) => hospital["name"].toString())
              .toList();
          isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredHospitals = hospitalNames
          .where((hospital) => hospital.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    fetchHospitals();
    super.initState();
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
      body: SingleChildScrollView(
        child: Padding(
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
              ////////////////////
              const Text(
                "Hospital Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: hospitalName,
                onChanged: _onSearchChanged,
                decoration:  InputDecoration(
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
              if (filteredHospitals.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    children: filteredHospitals
                        .map(
                          (hospital) => ListTile(
                        title: Text(hospital),
                        onTap: () {
                          hospitalName.text = hospital;
                          setState(() {
                            filteredHospitals.clear();
                          });
                        },
                      ),
                    )
                        .toList(),
                  ),
                ),
              ////////////////////
              // Hospital Name Field
              // _buildTextField("Hospital Name",hospitalName),
              const SizedBox(height: 20),
              // Hospital Location Field
              // _buildTextField("Hospital Location",hospitalLocation),
              DroneAppWidgets.buildGooglePlacesTextField(
                  label: 'Hopital Location',
                  addressController: hospitalLocation,
                  pincodeController: hospitalpincodeController,
                  onAddressSelected: (selectedAddress){
                    setState(() {
                      addressListhopital.add(selectedAddress);
                    });
                  }),


              const SizedBox(height: 20),
              // Time Field with Time Picker
              _buildTimeField("Time"),
              const SizedBox(height: 20),
              // Home Location Field (conditionally visible)
              if (widget.delivryType == "Door to Door")...[
                DroneAppWidgets.buildGooglePlacesTextField(
                    label: 'Home Location',
                    addressController: homeLocation,
                    pincodeController: homepincodeController,
                    onAddressSelected: (selectedAddress){
                      setState(() {
                        addressListhome.add(selectedAddress);
                      });
                    }),
                // _buildTextField("Home Location",homeLocation),
                // _buildGooglePlacesTextField("Home Location", homeLocation),

                SizedBox(height: 100,),
        ],
              // const Spacer(),
              // Skip Button
              ElevatedButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => Additional(
                   type: widget.type,
                   selectedType: 'Specialized',
                   age: widget.age,
                   gender: widget.gender,
                   mobility: widget.mobility,
                   pickup: widget.pickup,
                   inoutpatient: widget.inoutpatient,
                   hospital_name: hospitalName.text,
                   hospital_location: addressListhopital,
                   home_location: addressListhome,
                   hospital_time: _selectedTime,
                   customeDays: widget.customeDays.toString(),
                 ),));
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
      ),
    );
  }


  Widget _buildTextField(String label,TextEditingController controller) {
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
          controller:controller ,
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


// Widget _buildGooglePlacesTextField(String label, TextEditingController controller) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//       const SizedBox(height: 8),
//       GooglePlaceAutoCompleteTextField(
//         textEditingController: controller,
//         googleAPIKey: AppUrl.G_MAP_KEY, // Replace with your API Key
//         inputDecoration: InputDecoration(
//           filled: true,
//           fillColor: primaryColor2,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: primaryColor),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: primaryColor),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: primaryColor, width: 2),
//           ),
//         ),
//         debounceTime: 800,
//         countries: ["IN"], // Restrict to India (change as needed)
//         isLatLngRequired: true,
//         getPlaceDetailWithLatLng: (prediction) async {
//           print("Place details: ${prediction.lng} , ${prediction.lat}");
//
//           // Fetch pincode using Google Places API
//           String? pincode = await Util.getPincodeFromLatLng(prediction.lat!, prediction.lng!);
//
//           // Store the details in `addressList`
//           setState(() {
//             addressList = [
//               {
//                 "address": prediction.description,
//                 "latitude": prediction.lat.toString(),
//                 "longitude": prediction.lng.toString(),
//                 "pincode": pincode ?? "N/A"
//               }
//             ];
//
//             // Update the pincode text field
//             hospitalpincodeController.text = pincode ?? "";
//           });
//         },
//         itemClick: (prediction) {
//           controller.text = prediction.description!;
//           controller.selection = TextSelection.fromPosition(
//             TextPosition(offset: prediction.description!.length),
//           );
//         },
//         seperatedBuilder: const Divider(),
//       ),
//
//     ],
//   );
// }

// Widget _buildGooglePlacesTextField({
//   required String label,
//   required TextEditingController addressController,
//   required TextEditingController pincodeController,
//   required Function(Map<String, dynamic>) onAddressSelected, // Callback function
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//       const SizedBox(height: 8),
//       GooglePlaceAutoCompleteTextField(
//         textEditingController: addressController,
//         googleAPIKey: AppUrl.G_MAP_KEY, // Replace with your API Key
//         inputDecoration: InputDecoration(
//           filled: true,
//           fillColor: primaryColor2,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: primaryColor),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: primaryColor),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: primaryColor, width: 2),
//           ),
//         ),
//         debounceTime: 800,
//         countries: ["IN"], // Restrict to India (change as needed)
//         isLatLngRequired: true,
//         getPlaceDetailWithLatLng: (prediction) async {
//           print("Place details: ${prediction.lng} , ${prediction.lat}");
//
//           // Fetch pincode using Google Places API
//           String? pincode = await Util.getPincodeFromLatLng(prediction.lat!, prediction.lng!);
//
//           // Update controllers
//           addressController.text = prediction.description!;
//           pincodeController.text = pincode ?? "N/A";
//
//           // Create an address entry
//           Map<String, dynamic> selectedAddress = {
//             "address": prediction.description,
//             "latitude": prediction.lat.toString(),
//             "longitude": prediction.lng.toString(),
//             "pincode": pincode ?? "N/A"
//           };
//
//           // Update address list using callback
//           onAddressSelected(selectedAddress);
//         },
//         itemClick: (prediction) {
//           addressController.text = prediction.description!;
//           addressController.selection = TextSelection.fromPosition(
//             TextPosition(offset: prediction.description!.length),
//           );
//         },
//         seperatedBuilder: const Divider(),
//       ),
//     ],
//   );
// }