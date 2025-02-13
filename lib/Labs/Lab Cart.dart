import 'dart:convert';
import 'package:doctor_one/Dr1/bottomBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'Lab Homepage.dart';
import 'LabUrl.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> _cartItems = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;
  bool _isCenter = false;
  String? patientName, patientDob, patientGender, patientPhone, doctorName, remarks;
  String? address, pincode, latitude, longitude, contactNumber;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final String apiUrl = LabUrl.getCartcountandGetCart;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userID}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          setState(() {
            _cartItems = jsonData['data']['tests'];
            _totalPrice = _cartItems.fold(0, (sum, item) => sum + (item["price"] ?? 0));

            // Check if any test has home_collection = false
            _isCenter = _cartItems.any((item) => item["home_collection"] == false);
          });
        }
      }
    } catch (e) {
      print("Error fetching cart data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPatientDetailsDialog() {
    TextEditingController nameController = TextEditingController(text: patientName);
    TextEditingController dobController = TextEditingController(text: patientDob);
    TextEditingController genderController = TextEditingController(text: patientGender);
    TextEditingController phoneController = TextEditingController(text: patientPhone);
    TextEditingController doctorController = TextEditingController(text: doctorName);
    TextEditingController remarksController = TextEditingController(text: remarks);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Patient Details"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Patient Name", nameController),
                _buildDatePickerField("Date of Birth", dobController, context),
                _buildTextField("Gender", genderController),
                _buildTextField("Phone Number", phoneController),
                _buildTextField("Doctor Name", doctorController),
                _buildTextField("Remarks", remarksController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  patientName = nameController.text;
                  patientDob = dobController.text;
                  patientGender = genderController.text;
                  patientPhone = phoneController.text;
                  doctorName = doctorController.text;
                  remarks = remarksController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: LabColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: LabColors.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          suffixIcon: Icon(Icons.calendar_today, color:LabColors.primaryColor),
        ),
        readOnly: true, // Prevent manual text input
        onTap: () async {
          // Open the date picker
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            // Format the date and set it to the controller
            String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
            controller.text = formattedDate;
          }
        },
      ),
    );
  }

  void _showLocationAddDialog() {
    TextEditingController addressController = TextEditingController(text: address);
    TextEditingController pincodeController = TextEditingController(text: pincode);
    TextEditingController latController = TextEditingController(text: latitude);
    TextEditingController lngController = TextEditingController(text: longitude);
    TextEditingController contactController = TextEditingController(text: contactNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Details"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Address", addressController),
                _buildTextField("Pincode", pincodeController),
                _buildTextField("Latitude", latController),
                _buildTextField("Longitude", lngController),
                // _buildTextField("Contact Number", contactController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  address = addressController.text;
                  pincode = pincodeController.text;
                  latitude = latController.text;
                  longitude = lngController.text;
                  contactNumber = contactController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Circular border
            borderSide: BorderSide(color: LabColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Circular border on focus
            borderSide: BorderSide(color: LabColors.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[100], // Light background for better visibility
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }


  Future<void> _sendDataToBackend() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final Map<String, dynamic> body = {
      "userId": userID,
      "total_amount": _totalPrice,
      "status": "placed",
      "remarks": remarks,
      "order_type": "normal_order",
      "delivery_location": {
        "lat": double.parse(latitude ?? "0.0"),
        "lng": double.parse(longitude ?? "0.0"),
      },
      "pincode": pincode,
      "contact_no": patientPhone,
      "doctor_name": doctorName,
      "patientDetails": {
        "dob": patientDob,
        "name": patientName,
        "gender": patientGender,
        "phone_no": patientPhone,
      },
      "delivery_details": {
        "address": address,
        "pincode": pincode,
        "location": {
          "lat": double.parse(latitude ?? "0.0"),
          "lng": double.parse(longitude ?? "0.0"),
        },
      },
    };

    final String apiUrl = LabUrl.Labcheckout;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DroneBottomNavigation(pageindx: 1,)),
              (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order placed successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to place order. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  Future<void> removeFromCart(Map<String, dynamic> item) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(LabUrl.removeFromCart),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "test_number": item["test_number"], // Use the test_number from the item
        "userId": userID, // Hardcoded userId for now
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // If the API call is successful, update the UI
      setState(() {
        _cartItems.removeWhere((cartItem) => cartItem["test_number"] == item["test_number"]);
        _totalPrice = _cartItems.fold(0, (sum, cartItem) => sum + (cartItem["price"] ?? 0));
        _isCenter = _cartItems.any((cartItem) => cartItem["home_collection"] == false);
      });
    } else {
      throw Exception('Failed to remove from cart: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Cart", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            // Patient Details
            _buildSectionHeader("Patient Details", _showPatientDetailsDialog, patientName != null),
            if (patientName != null) _buildPatientInfo(),



            // Location
            _buildSectionHeader("Location", _showLocationAddDialog, address != null),
            if (address != null) _buildLocationInfo(),

            SizedBox(height: 15),

            // Orders
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader("Orders", null, false),
                SizedBox(width: 5,),
                _buildOrderType(),
              ],
            ),


            SizedBox(height: 10),

            Expanded(
              child: _cartItems.isEmpty
                  ? Center(child: Text("No items in cart"))
                  : ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return ListTile(
                    title: Text(item["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: ()async {
                        await removeFromCart(item);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DroneBottomNavigation(pageindx: 1,)),
                        (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: LabColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text("Add More", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("₹ $_totalPrice/-", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sendDataToBackend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LabColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text("Check Out", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onPressed, bool isEditMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        if (onPressed != null)
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: LabColors.primaryColor),
            child: Text(isEditMode ? "Edit" : "Add", style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }

  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$patientName"),
        Text("$patientDob"),
        Text("$patientGender"),
        // Text("Phone: $patientPhone"),
        // Text("Doctor: $doctorName"),
        // Text("Remarks: $remarks"),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address: $address"),
        Text("Pincode: $pincode"),
        // Text("Latitude: $latitude"),
        // Text("Longitude: $longitude"),
        // Text("Contact: $contactNumber"),
      ],
    );
  }

  Widget _buildOrderType() {
    return Row(
      children: [
        Icon(_isCenter ? Icons.location_on : Icons.home, color: _isCenter ? LabColors.primaryColor : Colors.orange),
        SizedBox(width: 5),
        Text(_isCenter ? "Center" : "Home", style: TextStyle(color: _isCenter ? LabColors.primaryColor : Colors.orange)),
      ],
    );
  }
}