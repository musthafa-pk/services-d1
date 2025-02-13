import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int orderId;

  BookingDetailsScreen({required this.orderId});

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Map<String, dynamic>? bookingDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  Future<void> fetchBookingDetails() async {
    final String apiUrl = "https://test.apis.dr1.co.in/labtest/getorderdetails";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"order_id": widget.orderId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          setState(() {
            bookingDetails = jsonData['data'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching booking details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(elevation:0,

        backgroundColor: Colors.white,
        title: Text("Booking Details",style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Set color to black
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingDetails == null
          ? Center(child: Text("Failed to load details"))
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: 10),
            // Patient Details
            Text("Patient Details", style: sectionTitleStyle),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingDetails!['patient_details']['name'],
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      capitalize(bookingDetails!['patient_details']['gender']),
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "${calculateAge(bookingDetails!['patient_details']['dob'])} Years old",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Location
            Text("Location", style: sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              bookingDetails!['delivery_details']['address'],
              style: descriptionTextStyle,
            ),
            SizedBox(height: 20),
            // Bookings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bookings", style: sectionTitleStyle),
                Row(
                  children: [
                    Icon(
                      (bookingDetails!['test_collection'] ?? "home").toLowerCase() == "center"
                          ? Icons.location_on
                          : Icons.home,
                      color: (bookingDetails!['test_collection'] ?? "home").toLowerCase() == "center"
                          ? Colors.orange
                          : Colors.blue,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      capitalize(bookingDetails!['test_collection'] ?? "Home"),
                      style: TextStyle(
                        color: (bookingDetails!['test_collection'] ?? "home").toLowerCase() == "center"
                            ? Colors.orange
                            : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            // Test Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bookingDetails!['labtest_details']
                  .map<Widget>((test) => Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  test['name'],
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ))
                  .toList(),
            ),
            SizedBox(height: 20),
            // Date & Time
            Text("Date & Time", style: sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              formatDate(bookingDetails!['created_date']),
              style: descriptionTextStyle,
            ),
            SizedBox(height: 20),
            // Lab Details
            Text("Lab Details", style: sectionTitleStyle),
            SizedBox(height: 5),
            if (bookingDetails!['labtest_details'].isNotEmpty)
              Text(
                bookingDetails!['labtest_details'][0]['description'],
                style: descriptionTextStyle,
              )
            else
              Text("No Lab Details", style: descriptionTextStyle),
          ],
        ),
      ),
    );
  }

  // Utility function to capitalize first letter
  String capitalize(String? text) {
    if (text == null || text.isEmpty) return "";
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  // Format date as DD/MM/YYYY
  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      print("Error formatting date: $date");
      return "Invalid Date";
    }
  }

  // Calculate age from DOB
  int calculateAge(String dob) {
    try {
      // Convert '12/2/2000' -> DateTime
      DateFormat format = DateFormat("d/M/yyyy");
      DateTime birthDate = format.parse(dob);

      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      print("Error calculating age: $e");
      return 0;
    }
  }

  // Text Styles
  final sectionTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  final descriptionTextStyle = TextStyle(color: Colors.grey);
}