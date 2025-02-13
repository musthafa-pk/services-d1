import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Lab Cart.dart';
import 'LabUrl.dart';

class PackageDetailsScreen extends StatefulWidget {
  final int packageId; // Accept package ID

  const PackageDetailsScreen({Key? key, required this.packageId}) : super(key: key);

  @override
  _PackageDetailsScreenState createState() => _PackageDetailsScreenState();
}
class LabColors {
  static const Color primaryColor = Color.fromRGBO(76, 193, 170, 1.0);
  static const Color lightPrimaryColor1 = Color.fromRGBO(200, 230, 223, 1.0);

  static final Color extraLightPrimary = primaryColor.withOpacity(0.1); // 10% opacity
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  Map<String, dynamic>? packageDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPackageDetails();
    print(widget.packageId);
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
  /// Fetch package details using API
  Future<void> fetchPackageDetails() async {
    final String apiUrl = LabUrl.packageDetail;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.packageId}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          setState(() {
            packageDetails = jsonData['data'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching package details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : packageDetails == null
          ? Center(child: Text("Package details not found"))
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button & Cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
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

              SizedBox(height: 10),

              // Main Content with ScrollView to avoid overflow
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package Name & Home Collection Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              packageDetails!["package_name"] ?? "Unknown Package",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (packageDetails!["home_collection"] == true)
                            Row(
                              children: [
                                Icon(Icons.home, color: Colors.orange, size: 20),
                                SizedBox(width: 5),
                                Text("Home", style: TextStyle(color: Colors.orange)),
                              ],
                            ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // Price
                      Text(
                        "₹ ${packageDetails!["price"] ?? "N/A"}/-",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 10),

                      // Description
                      Text(
                        packageDetails!["about"] ?? "No description available",
                        style: TextStyle(color: Colors.grey[700]),
                      ),

                      SizedBox(height: 15),

                      // Added Tests Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Added Tests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            "${packageDetails!["tests"]?.length ?? 0} Tests",
                            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // Tests List
                    packageDetails!["tests"] == null || packageDetails!["tests"].isEmpty
                        ? Center(child: Text("No tests available"))
                        : ListView.builder(
                      shrinkWrap: true, // Prevents scroll conflict
                      physics: NeverScrollableScrollPhysics(), // Uses parent scroll
                      itemCount: packageDetails!["tests"].length,
                      itemBuilder: (context, index) {
                        final test = packageDetails!["tests"][index];
                        return testCard(
                          test["name"] ?? "Unknown Test",
                          "₹ ${test["mrp"] ?? "N/A"}/-",
                          "", // Pass an empty string instead of description
                        );
                      },
                    ),


                    SizedBox(height: 20),

                      // Add Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LabColors.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text("Add", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Test Card Widget
  // Widget testCard(String testName, String price, String description) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 6),
  //     padding: EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.blue[50],
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(testName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         SizedBox(height: 5),
  //         Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         SizedBox(height: 5),
  //         Text(description, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
  //       ],
  //     ),
  //   );
  // }
  Widget testCard(String testName, String price, String? description) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LabColors.extraLightPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(testName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

          // Show description only if it's not null or empty
          if (description != null && description.isNotEmpty) ...[
            SizedBox(height: 5),
            Text(description, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          ],
        ],
      ),
    );
  }

}
