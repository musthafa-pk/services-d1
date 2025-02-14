// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:services/constants/constants.dart';
// import 'package:services/utils/utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../res/appUrl.dart';
//
// class UploadPrescriptionPage extends StatefulWidget {
//   @override
//   _UploadPrescriptionPageState createState() => _UploadPrescriptionPageState();
// }
//
// class _UploadPrescriptionPageState extends State<UploadPrescriptionPage> {
//   List<PlatformFile>? _pickedFiles;
//   bool concent = false;
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();
//   final TextEditingController landmarkController = TextEditingController();
//   final TextEditingController districtController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();
//   final TextEditingController remarksController = TextEditingController();
//   List<PlatformFile>? pickedFiles;
//   Future<void> placeOrder() async {
//     if (!concent) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please provide consent to proceed.")),
//       );
//       return;
//     }
//
//     final url = Uri.parse(AppUrl.salesOrder); // Replace with your API URL
//
//     final Map<String, dynamic> orderData = {
//       "name": nameController.text,
//       "so_status": "placed",
//       "remarks": remarksController.text,
//       "order_type": "prescription",
//       "delivery_address": _addressController.text,
//       "delivery_location": landmarkController.text,
//       "city": districtController,
//       "district": districtController.text,
//       "pincode": pincodeController.text,
//       "contact_no": contactController.text
//     };
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode(orderData),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print("Order placed successfully: \${response.body}");
//       } else {
//         print("Failed to place order: \${response.statusCode}, \${response.body}");
//       }
//     } catch (e) {
//       print("Error placing order: \$e");
//     }
//   }
//
//   void _pickFiles() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.any,
//     );
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         _pickedFiles = result.files;
//       });
//     }
//   }
//
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Location services are disabled. Please enable them.")),
//       );
//       return;
//     }
//
//     // Check location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Location permission denied")),
//         );
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Location permissions are permanently denied")),
//       );
//       return;
//     }
//
//     // Fetch the current location
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//
//         setState(() {
//           _addressController.text = [
//             place.street,
//             place.subLocality,
//             place.locality,
//             place.administrativeArea
//           ].where((e) => e != null && e.isNotEmpty).join(", ");
//
//           pincodeController.text = place.postalCode ?? "Not Available";
//           districtController.text = place.subAdministrativeArea ?? "Not Available";
//         });
//       } else {
//         print("No location details found.");
//       }
//     } catch (e) {
//       print("Error fetching location details: $e");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Prescription', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//
//           },
//         ),
//         elevation: 1,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Name Field
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Name',
//                 filled: true,
//                 fillColor: color1,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Contact Number Field
//             TextField(
//               controller: contactController,
//               decoration: InputDecoration(
//                 labelText: 'Contact Number',
//                 filled: true,
//                 fillColor: color1,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 16),
//             // Nearest Landmark Field
//             TextField(
//               controller: landmarkController,
//               decoration: InputDecoration(
//                 labelText: 'Nearest Landmark',
//                 filled: true,
//                 fillColor:color1,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Upload Prescription Button
//            SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: ElevatedButton(
//                 onPressed: _pickFiles,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 12.0,right: 12),
//                   child: Text(
//                     'Upload Prescription (Max 5 Files)',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             if (_pickedFiles != null && _pickedFiles!.isNotEmpty)
//               Text(
//                 '${_pickedFiles!.length} file(s) selected',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SizedBox(
//                   width: 200,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: color1,
//                     ),
//                     onPressed: _getCurrentLocation, // Call location function
//                     child: Row(
//                       children: [
//                         Icon(Icons.location_on_outlined, color: d1blue),
//                         Text('Use my location', style: TextStyle(color: d1blue)),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//
//             // Delivery Address Field
//             TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText: 'Delivery Address',
//                 filled: true,
//                 fillColor: color1,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // District Field
//             TextField(
//               controller: districtController,
//               decoration: InputDecoration(
//                 labelText: 'District',
//                 filled: true,
//                 fillColor: color1,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Pincode Field
//             TextField(
//               controller: pincodeController,
//               decoration: InputDecoration(
//                 labelText: 'Pincode',
//                 filled: true,
//                 fillColor:color1,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 16),
//
//             // Remarks Field
//             TextField(
//               controller: remarksController,
//               decoration: InputDecoration(
//                 labelText: 'Remarks',
//                 filled: true,
//                 fillColor: color1,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Consent Checkbox
//             Row(
//               children: [
//                 Checkbox(
//                   activeColor: d1blue,
//                   value: concent,
//                   onChanged: (value) {
//                     setState(() {
//                       concent =!concent;
//                     });
//                   },
//                 ),
//                 Expanded(
//                   child: Text(
//                     'I consent to be contacted regarding my submission.',
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Submit Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if(concent){
//                     Navigator.pop(context);
//                   }else{
//                     Util.toastMessage('please check the box to continue');
//                   }
//                   // Submit logic here
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: d1blue,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text('Submit',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../res/appUrl.dart';
import '../utils/utils.dart';
import 'bottomBar.dart';

class UploadPrescriptionPage extends StatefulWidget {
  @override
  _UploadPrescriptionPageState createState() => _UploadPrescriptionPageState();
}

class _UploadPrescriptionPageState extends State<UploadPrescriptionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController? nameController = TextEditingController();
  final TextEditingController? contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  List<Map<String, dynamic>> locationAddress = [];


  String orderType = "prescription"; // Default order type
  File? prescriptionImage;
  bool isLoading = false;
  bool isLoadingLocaiton = false;


  // Function to pick an image
  Future<void> pickImage() async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          prescriptionImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting image: $e")),
      );
    }
  }

  // Function to submit order
  Future<void> submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final uri = Uri.parse(AppUrl.salesOrder);
    var request = http.MultipartRequest('POST', uri);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');

    try {
      // Adding form fields
      String locationAddressJson = jsonDecode(locationAddress as String);
      request.fields.addAll({
        'name': nameController!.text,
        'contact_no': contactController!.text,
        'delivery_address': addressController.text,
        'delivery_location':locationAddressJson,
        'city': cityController.text,
        'district': districtController.text,
        'pincode': pincodeController.text,
        'remarks': remarksController.text,
        'order_type': orderType,
        'userId': "${userID}", // Replace with actual user ID
      });

      // Adding prescription image if applicable
      if (orderType == "prescription" && prescriptionImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'images', // Ensure this matches the backend field name
          prescriptionImage!.path,
        ));
      }

      print('eheeheh:${request.fields}');


      final response = await request.send();
      final responseBody = await response.stream.bytesToString();


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        Util.toastMessage('${jsonResponse['message'] ?? "Order placed successfully"}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(jsonResponse['message'] ?? "Order placed successfully")),
        // );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>DroneBottomNavigation(pageindx: 2,) ,));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${json.decode(responseBody)['message'] ?? "Failed to place order"}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $error")),
      );
    }

    setState(() => isLoading = false);
  }

  //using google map
  Future<void> _getCurrentLocation(BuildContext context) async {
    setState(() => isLoadingLocaiton = true); // Show loader

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled. Please enable them.")),
      );
      setState(() => isLoadingLocaiton = false); // Hide loader
      return;
    }

    try{

      // Check location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location permission denied")),
          );
          setState(() => isLoadingLocaiton = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permissions are permanently denied")),
        );
        setState(() => isLoadingLocaiton = false);
        return;
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _getAddressFromGoogleMaps(position.latitude, position.longitude, context);

    }finally{
      setState(() => isLoadingLocaiton = false); // Hide loader after operation
    }

  }

  Future<void> _getAddressFromGoogleMaps(double latitude, double longitude, BuildContext context) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${AppUrl.G_MAP_KEY}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "OK" && data["results"].isNotEmpty) {
          print('dataasss:$data');
          final address = data["results"][0]["formatted_address"];
          final components = data["results"][0]["address_components"];

          String pincode = "Not Available";
          String district = "Not Available";

          for (var component in components) {
            if (component["types"].contains("postal_code")) {
              pincode = component["long_name"];
            }
            if (component["types"].contains("administrative_area_level_2")) {
              district = component["long_name"];
            }
          }

          setState(() {
            addressController.text = address;
            pincodeController.text = pincode;
            districtController.text = district;
            // Store the location details in the list
            locationAddress.add({
              // "address": address,
              // "pincode": pincode,
              // "district": district,
              "lat": latitude,
              "lng": longitude
            });
          });
        } else {
          print("No location details found.");
        }
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }
  String? userName;
  String? phone;
  Future<void>getUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    nameController!.text = preferences.getString('userName')!;
    contactController!.text = preferences.getString('userPhone')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white ,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
              child: Icon(Icons.arrow_back,color: Colors.black,)),
          title: Text("Upload prescription",style: TextStyle(color: Colors.black),)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Customer Name",
                filled: true,
                border: InputBorder.none,
                fillColor: pharmacyBlueLight),
                validator: (value) =>
                value!.isEmpty ? "Enter customer name" : null,
              ),

              SizedBox(height: 10,),

              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: "Contact No.",
                    filled: true,
                    border: InputBorder.none,
                    fillColor: pharmacyBlueLight),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? "Enter contact number" : null,
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pharmacyBlueLight,
                    ),
                    onPressed: isLoadingLocaiton?null:()=>_getCurrentLocation(context),
                    child: isLoadingLocaiton?Center(child:Text("Fetching...."),):Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.black),
                        Text('Use my location', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ]
              ),

              SizedBox(height: 10,),

              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                    labelText: "Delivery Address",
                    filled: true,
                    border: InputBorder.none,
                    fillColor: pharmacyBlueLight),
                validator: (value) =>
                value!.isEmpty ? "Enter delivery address" : null,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: "City",
                    filled: true,
                    border: InputBorder.none,
                    fillColor: pharmacyBlueLight),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: districtController,
                decoration: InputDecoration(labelText: "District",
                    filled: true,
                    border: InputBorder.none,
                    fillColor: pharmacyBlueLight),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: pincodeController,
                decoration: InputDecoration(labelText: "Pincode",
                    filled: true,
                    border: InputBorder.none,
                    fillColor: pharmacyBlueLight),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: remarksController,
                decoration: InputDecoration(labelText: "Remarks (Optional)",
                    filled: true,
                    border: InputBorder.none,
                    fillColor: pharmacyBlueLight),
              ),
              SizedBox(height: 10,),
              SizedBox(height: 10,),

              // Show file upload option if prescription
              if (orderType == "prescription") ...[
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  ),
                    onPressed: pickImage, child: Text('Upload Prescription')),
                if (prescriptionImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Image Selected: ${prescriptionImage!.path.split('/').last}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
              InkWell(
                onTap: isLoading ? null : submitOrder,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Container(
                  width: MediaQuery.of(context).size.width/3,
                  decoration: BoxDecoration(
                    color: d1blue,
                    borderRadius: BorderRadius.circular(9)
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0,bottom: 12.0,left: 16,right: 16),
                      child: Center(child: Text("Submit Order",style: TextStyle(color: Colors.white),)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
