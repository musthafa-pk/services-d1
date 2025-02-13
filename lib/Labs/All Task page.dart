import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Lab Cart.dart';
import 'LabUrl.dart';
import 'TestDetails.dart';

class LabTestsScreen extends StatefulWidget {
  @override
  _LabTestsScreenState createState() => _LabTestsScreenState();
}
class LabColors {
  static const Color primaryColor = Color.fromRGBO(76, 193, 170, 1.0);
  static const Color lightPrimaryColor1 = Color.fromRGBO(200, 230, 223, 1.0);

  // Change from `const` to `final`
  static final Color extraLightPrimary = primaryColor.withOpacity(0.1); // 10% opacity
}
class _LabTestsScreenState extends State<LabTestsScreen> {
  List<dynamic> _allTests = [];
  List<dynamic> _filteredTests = [];
  bool _isPopularSelected = true;
  TextEditingController _searchController = TextEditingController();
  Set<String> _cartItems = {}; // Track tests in the cart

  @override
  void initState() {
    super.initState();
    fetchLabTests();
    _searchController.addListener(_filterTests);
  }

  /// Fetch Lab Tests from API

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
  Future<void> fetchLabTests() async {
    final String apiUrl = LabUrl.getallTests;

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          setState(() {
            _allTests = jsonData['data'];
            _updateFilteredTests(); // Update list when data loads
          });
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  Future<void> addToCartTest(dynamic test) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(LabUrl.addToCart),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"test_number": test["test_number"], "userId": userID}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _cartItems.add(test["test_number"]); // Add test to cart
      });
    } else {
      print("Failed to add to cart: ${response.statusCode}");
    }
  }

  Future<void> removeFromCartTest(dynamic test) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(LabUrl.removeFromCart),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"test_number": test["test_number"], "userId": userID}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _cartItems.remove(test["test_number"]); // Remove test from cart
      });
    } else {
      print("Failed to remove from cart: ${response.statusCode}");
    }
  }

  /// Update filtered tests based on selected tab
  void _updateFilteredTests() {
    setState(() {
      _filteredTests = _isPopularSelected
          ? _allTests // Show all tests in Popular
          : _allTests.where((test) => test["home_collection"] == false).toList(); // Only Center Visit tests
    });
  }

  /// Search Functionality
  void _filterTests() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTests = (_isPopularSelected
          ? _allTests
          : _allTests.where((test) => test["home_collection"] == false).toList())
          .where((test) => test["name"].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset("assets/droneicons/location.png", width: 30, height: 30),
          ),
        ),
        // actions: [
        //   Stack(
        //     children: [
        //       IconButton(
        //         icon: Icon(Icons.shopping_cart, color: Colors.grey),
        //         onPressed: () {
        //           Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
        //         },
        //       ),
        //       if (_cartItems.isNotEmpty)
        //         Positioned(
        //           right: 0,
        //           top: 0,
        //           child: Container(
        //             padding: EdgeInsets.all(2),
        //             decoration: BoxDecoration(
        //               color: Colors.red,
        //               borderRadius: BorderRadius.circular(6),
        //             ),
        //             constraints: BoxConstraints(
        //               minWidth: 12,
        //               minHeight: 12,
        //             ),
        //             child: Text(
        //               '${_cartItems.length}',
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 8,
        //               ),
        //               textAlign: TextAlign.center,
        //             ),
        //           ),
        //         ),
        //     ],
        //   ),
        // ],
        actions: [
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Icon(Icons.location_on, color: Colors.red),
              //         SizedBox(width: 4),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text("Select Your Location", style: TextStyle(fontSize: 14)),
              //             Text("Kozhikode", style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold)),
              //           ],
              //         ),
              //       ],
              //     ),
              //     CircleAvatar(
              //       radius: 20,
              //       backgroundColor: Colors.grey[200],
              //       child: Icon(Icons.shopping_cart, color: Colors.black),
              //     ),
              //   ],
              // ),

              SizedBox(height: 20),

              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: LabColors.primaryColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search Lab Tests",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Category Tabs
              Row(
                children: [
                  categoryButton("Popular", _isPopularSelected, () {
                    setState(() {
                      _isPopularSelected = true;
                      _updateFilteredTests();
                    });
                  }),
                  categoryButton("Center Visit", !_isPopularSelected, () {
                    setState(() {
                      _isPopularSelected = false;
                      _updateFilteredTests();
                    });
                  }),
                ],
              ),

              SizedBox(height: 15),

              // Tests List
              Expanded(
                child: _filteredTests.isEmpty
                    ? Center(child: Text("No tests available"))
                    : ListView.builder(
                  itemCount: _filteredTests.length,
                  itemBuilder: (context, index) {
                    return testCard(_filteredTests[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Category Tab Button
  Widget categoryButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? LabColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  /// Test Card UI
  Widget testCard(dynamic test) {
    bool isInCart = _cartItems.contains(test["test_number"]); // Check if test is in cart

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestDetailsScreen(testId: test["id"]),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LabColors.extraLightPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(test["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("₹ ${test["mrp"]}/-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (isInCart) {
                    removeFromCartTest(test); // Remove from cart
                  } else {
                    addToCartTest(test); // Add to cart
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? Colors.red : LabColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(isInCart ? "Remove" : "Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
