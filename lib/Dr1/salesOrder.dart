import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctor_one/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dash/flutter_dash.dart';

import '../constants/constants.dart';
import '../res/appUrl.dart';
import 'bottomBar.dart';
class SalesOrderPage extends StatefulWidget {
  String? totalAmount;
  var productData;
   SalesOrderPage({this.totalAmount,this.productData});
  @override
  _SalesOrderPageState createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoadingLocaiton = false;
  List<Map<String, dynamic>> locationAddress = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String orderType = "product"; // Default order type
  File? prescriptionImage;
  bool isLoading = false;

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
      request.fields.addAll({
        'userId': "${userID}",
        'name': nameController.text,
        'total_amount':"${widget.totalAmount}",
        "so_status":"placed",
        'remarks': remarksController.text,
        'order_type': "salesorder",
        'delivery_address': addressController.text,
        "delivery_location":"",
        'contact_no': contactController.text,
        'city': cityController.text,
        'district': districtController.text,
        'pincode': pincodeController.text,

      });
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(jsonResponse['message'] ?? "Order placed successfully")),
        // );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DroneBottomNavigation(pageindx: 2,),));
        Util.flushBarSuccessMessage(pharmacyBlue, jsonResponse['message'] ?? "Order placed successfully", context);
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

  Future<void>getUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    nameController!.text = preferences.getString('userName')!;
    contactController!.text = preferences.getString('userPhone')!;
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

          String pincode = "";
          String district = "";

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
              "address": address,
              "pincode": pincode,
              "district": district,
              "latitude": latitude,
              "longitude": longitude
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
          backgroundColor: Colors.white,
          title: Text("Place Sales Order",style: TextStyle(color: Colors.black),),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: pharmacyBlueLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: widget.productData != null && widget.productData is List
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...((widget.productData as List).map((product) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 100, // Adjust height
                                  enlargeCenterPage: true,
                                  autoPlay: true, // Enable auto-scroll
                                  viewportFraction: 1.0, // Show one image at a time
                                ),
                                items: [
                                  product['images']['image1'],
                                  product['images']['image2'],
                                  product['images']['image3'],
                                  product['images']['image4'],
                                ].where((imageUrl) => imageUrl != null).map((imageUrl) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          title: Text(
                            product['product_name'] ?? "Unknown Product",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "${product['quantity'] ?? '0'} x ₹${product['mrp'] ?? '0.00'}",
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ),
                      );
                    }).toList()),

                    // Dotted Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(),
                    ),

                    // Total Amount Section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            "₹${widget.totalAmount ?? '0.00'}",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : Text("No product data available"),
              ),

              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: InkWell(
                        onTap: isLoadingLocaiton ? null : () => _getCurrentLocation(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isLoadingLocaiton ? Colors.grey.shade300 : pharmacyBlueLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.black),
                              SizedBox(width: 5), // Space between icon and text
                              Text(
                                isLoadingLocaiton ? "Fetching..." : "Use my location",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
                    fillColor: pharmacyBlueLight
                ),
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
                    fillColor: pharmacyBlueLight
                ),
              ),
              SizedBox(height: 10,),

              // Order type selection
              SizedBox(height: 10,),

              SizedBox(height: 20),
              InkWell(
                onTap: isLoading ? null : submitOrder,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: pharmacyBlue,
                    borderRadius: BorderRadius.circular(9)
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0,bottom: 16.0,left: 16,right: 16),
                      child: Center(child: Text("Submit Order",style: TextStyle(
                        color: Colors.black
                      ),)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
