import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'LabUrl.dart';


class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController totalAmountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController orderTypeController = TextEditingController(text: "normal_order");
  TextEditingController pincodeController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController patientNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController patientPhoneController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();
  TextEditingController deliveryPincodeController = TextEditingController();

  Future<void> submitCheckout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> requestBody = {
        "userId": userID,
        "total_amount": double.tryParse(totalAmountController.text) ?? 0,
        "status": "placed",
        "remarks": remarksController.text,
        "order_type": orderTypeController.text,
        "delivery_location": {
          "lat": 11.5378576,
          "lng": 75.65675590000001
        },
        "pincode": int.tryParse(pincodeController.text) ?? 0,
        "contact_no": contactNoController.text,
        "doctor_name": doctorNameController.text,
        "patientDetails": {
          "dob": dobController.text,
          "name": patientNameController.text,
          "gender": genderController.text,
          "phone_no": patientPhoneController.text,
        },
        "delivery_details": {
          "address": deliveryAddressController.text,
          "pincode": deliveryPincodeController.text,
          "location": {
            "lat": 11.5378576,
            "lng": 75.65675590000001
          }
        }
      };

      final response = await http.post(
        Uri.parse(LabUrl.Labcheckout),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order placed successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to place order.")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
          backgroundColor: Colors.white,
          title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextField("Total Amount", totalAmountController),
                buildTextField("Remarks", remarksController),
                buildTextField("Pincode", pincodeController),
                buildTextField("Contact No", contactNoController),
                buildTextField("Doctor Name", doctorNameController),
                Divider(),
                Text("Patient Details", style: TextStyle(fontWeight: FontWeight.bold)),
                buildTextField("DOB (YYYY-MM-DD)", dobController),
                buildTextField("Patient Name", patientNameController),
                buildTextField("Gender", genderController),
                buildTextField("Patient Phone No", patientPhoneController),
                Divider(),
                Text("Delivery Details", style: TextStyle(fontWeight: FontWeight.bold)),
                buildTextField("Delivery Address", deliveryAddressController),
                buildTextField("Delivery Pincode", deliveryPincodeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitCheckout,
                  child: Text("Submit Order"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }
}
