import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'LabUrl.dart';

import 'Booking details.dart';

class MyBookingsScreen extends StatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class LabColors {
  static const Color primaryColor = Color.fromRGBO(76, 193, 170, 1.0);
  static const Color lightPrimaryColor1 = Color.fromRGBO(200, 230, 223, 1.0);

  static final Color extraLightPrimary = primaryColor.withOpacity(0.1); // 10% opacity
}
class _MyBookingsScreenState extends State<MyBookingsScreen> {
  Future<List<dynamic>> fetchBookings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final String apiUrl = LabUrl.myOrders;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userID}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        return jsonData['data'];
      }
    }
    return [];
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return Colors.green.shade100; // Light green for upcoming
      case 'confirmed':
        return Colors.blue.shade100; // Light blue for completed
      default:
        return Colors.grey.shade300; // Default grey
    }
  }

  Color getTextColor(String status) {
    return status == "placed" ? Colors.green : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Bookings", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No bookings available."));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return InkWell(
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen(orderId: int.parse(booking['order_id'].toString()),),));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking ID and Date
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: getStatusColor(booking['status']),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Booking Id: #${booking['order_number']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              booking['created_date'].substring(0, 10), // Extract only date
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                
                      // Order Details
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2 Tests 1 Package",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              booking['status'] == 'placed' ? 'Placed' : 'Confirmed',
                              style: TextStyle(
                                color: getTextColor(booking['status']),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
