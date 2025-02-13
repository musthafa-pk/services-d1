import 'package:flutter/material.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/constants/widgets/widgetsfordoctor1.dart';

class LocationPage extends StatefulWidget {
   LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController locationController = TextEditingController();

  TextEditingController pincodeController = TextEditingController();
  List<Map<String, dynamic>> locationAddress = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Add Patient\nLocation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              // const Text(
              //   'Location',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.black,
              //   ),
              // ),
              const SizedBox(height: 8),
              DroneAppWidgets.buildGooglePlacesTextField(
                  label: 'Location',
                  addressController: locationController,
                  pincodeController: pincodeController,
                  onAddressSelected: (selectedAddress){
                    setState(() {
                      locationAddress.add(selectedAddress);
                    });
                  }),
              // TextField(
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: primaryColor2,
              //     hintText: 'Enter location',
              //     suffixIcon: Icon(
              //       Icons.location_on,
              //       color: Colors.grey.shade700,
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: BorderSide(
              //         color: primaryColor,
              //       ),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: BorderSide(
              //         color:primaryColor,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: BorderSide(
              //         color: primaryColor,
              //         width: 2,
              //       ),
              //     ),
              //   ),
              // ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Next button click
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
