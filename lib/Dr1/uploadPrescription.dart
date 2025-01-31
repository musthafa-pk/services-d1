import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:services/constants/constants.dart';
import 'package:services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../res/appUrl.dart';

class UploadPrescriptionPage extends StatefulWidget {
  @override
  _UploadPrescriptionPageState createState() => _UploadPrescriptionPageState();
}

class _UploadPrescriptionPageState extends State<UploadPrescriptionPage> {
  List<PlatformFile>? _pickedFiles;
  bool concent = false;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  List<PlatformFile>? pickedFiles;
  Future<void> placeOrder() async {
    if (!concent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide consent to proceed.")),
      );
      return;
    }

    final url = Uri.parse(AppUrl.salesOrder); // Replace with your API URL

    final Map<String, dynamic> orderData = {
      "name": nameController.text,
      "so_status": "placed",
      "remarks": remarksController.text,
      "order_type": "prescription",
      "delivery_address": _addressController.text,
      "delivery_location": landmarkController.text,
      "city": districtController,
      "district": districtController.text,
      "pincode": pincodeController.text,
      "contact_no": contactController.text
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Order placed successfully: \${response.body}");
      } else {
        print("Failed to place order: \${response.statusCode}, \${response.body}");
      }
    } catch (e) {
      print("Error placing order: \$e");
    }
  }

  void _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFiles = result.files;
      });
    }
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled. Please enable them.")),
      );
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission denied")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permissions are permanently denied")),
      );
      return;
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        setState(() {
          _addressController.text = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea
          ].where((e) => e != null && e.isNotEmpty).join(", ");

          pincodeController.text = place.postalCode ?? "Not Available";
          districtController.text = place.subAdministrativeArea ?? "Not Available";
        });
      } else {
        print("No location details found.");
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Prescription', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                fillColor: color1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Contact Number Field
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                filled: true,
                fillColor: color1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            // Nearest Landmark Field
            TextField(
              controller: landmarkController,
              decoration: InputDecoration(
                labelText: 'Nearest Landmark',
                filled: true,
                fillColor:color1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Upload Prescription Button
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: _pickFiles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0,right: 12),
                  child: Text(
                    'Upload Prescription (Max 5 Files)',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            if (_pickedFiles != null && _pickedFiles!.isNotEmpty)
              Text(
                '${_pickedFiles!.length} file(s) selected',
                style: TextStyle(color: Colors.grey),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color1,
                    ),
                    onPressed: _getCurrentLocation, // Call location function
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: d1blue),
                        Text('Use my location', style: TextStyle(color: d1blue)),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            // Delivery Address Field
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Delivery Address',
                filled: true,
                fillColor: color1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // District Field
            TextField(
              controller: districtController,
              decoration: InputDecoration(
                labelText: 'District',
                filled: true,
                fillColor: color1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Pincode Field
            TextField(
              controller: pincodeController,
              decoration: InputDecoration(
                labelText: 'Pincode',
                filled: true,
                fillColor:color1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Remarks Field
            TextField(
              controller: remarksController,
              decoration: InputDecoration(
                labelText: 'Remarks',
                filled: true,
                fillColor: color1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Consent Checkbox
            Row(
              children: [
                Checkbox(
                  activeColor: d1blue,
                  value: concent,
                  onChanged: (value) {
                    setState(() {
                      concent =!concent;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I consent to be contacted regarding my submission.',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(concent){
                    Navigator.pop(context);
                  }else{
                    Util.toastMessage('please check the box to continue');
                  }
                  // Submit logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: d1blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Submit',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
