import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'LabUrl.dart';

import 'Lab Cart.dart';

class TestDetailsScreen extends StatefulWidget {
  final int testId; // Receive test ID as a parameter

  TestDetailsScreen({required this.testId});

  @override
  _TestDetailsScreenState createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {
  Map<String, dynamic>? testDetails; // Store API response
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchTestDetails();
  }
  Future<int> fetchCartCount() async {
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
          return jsonData['data']['tests'].length;
        }
      }
    } catch (e) {
      print("Error fetching cart data: $e");
    }
    return 0;
  }
  /// Fetch Test Details from API
  Future<void> fetchTestDetails() async {
    final String apiUrl = LabUrl.testDetail;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.testId}), // Send test ID in body
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          setState(() {
            testDetails = jsonData['data'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching test details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loader
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text("Test Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  FutureBuilder<int>(
                    future: fetchCartCount(),
                    builder: (context, snapshot) {
                      int itemCount = snapshot.data ?? 0;

                      return Stack(
                        children: [
                          IconButton(
                            icon: Icon(Icons.shopping_cart,color: Colors.black,),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
                            },
                          ),
                          if (itemCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  itemCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Test Name
              Text(
                testDetails!["name"],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              // Price
              Text(
                "₹ ${testDetails!["mrp"]}/-",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              // Description
              Text(
                testDetails!["description"] ?? "No description available.",
                style: TextStyle(color: Colors.grey[700]),
              ),

              SizedBox(height: 10),

              // Home Collection
              if (testDetails!["home_collection"] == true)
                Row(
                  children: [
                    Icon(Icons.home, color: Colors.orange, size: 16),
                    SizedBox(width: 5),
                    Text("Home Collection", style: TextStyle(color: Colors.orange)),
                  ],
                ),

              SizedBox(height: 20),

              // Add Button
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
