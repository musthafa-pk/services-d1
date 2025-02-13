import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Lab Cart.dart';
import 'LabUrl.dart';
import 'Package details.dart';

class LabPackagesScreen extends StatefulWidget {
  @override
  _LabPackagesScreenState createState() => _LabPackagesScreenState();
}
class LabColors {
  static const Color primaryColor = Color.fromRGBO(76, 193, 170, 1.0);
  static const Color lightPrimaryColor1 = Color.fromRGBO(200, 230, 223, 1.0);

  static final Color extraLightPrimary = primaryColor.withOpacity(0.1); // 10% opacity
}
class _LabPackagesScreenState extends State<LabPackagesScreen> {
  List<dynamic> _allPackages = [];
  List<dynamic> _filteredPackages = [];
  TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "Popular"; // Default selected category

  // Add these variables for cart management
  Set<String> _cartItems = {}; // Track test numbers of items in the cart
  int _cartItemCount = 0; // Track the number of items in the cart
  bool _isLoading = false; // Track loading state for API calls

  @override
  void initState() {
    super.initState();
    fetchLabPackages();
    _searchController.addListener(_filterPackages);
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

  Future<void> addToCart(dynamic package) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final body = json.encode({
      "test_number": package["test_number"], // Use dynamic test number
      "userId": userID,
    });

    print('Request Body: $body');

    setState(() {
      _isLoading = true; // Show loading state
    });

    try {
      final response = await http.post(
        Uri.parse(LabUrl.addToCart),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      // Check for success
      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        setState(() {
          _cartItems.add(package["test_number"]); // Add to cart
          _cartItemCount = _cartItems.length; // Update cart count
        });
      } else {
        throw Exception('API responded with failure: ${data['message']}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }

  Future<void> removeFromCart(dynamic package) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final body = json.encode({
      "test_number": package["test_number"], // Use dynamic test number
      "userId": userID,
    });

    setState(() {
      _isLoading = true; // Show loading state
    });

    try {
      final response = await http.post(
        Uri.parse(LabUrl.removeFromCart),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _cartItems.remove(package["test_number"]); // Remove from cart
          _cartItemCount = _cartItems.length; // Update cart count
        });
      } else {
        throw Exception('Failed to remove from cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing from cart: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }
  /// Fetch Lab Packages from API
  Future<void> fetchLabPackages() async {
    final String apiUrl = LabUrl.getallPackages;

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          setState(() {
            _allPackages = jsonData['data'];
            _filterByCategory(); // Initially show all packages
          });
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  /// Filter Packages Based on Selected Category
  void _filterByCategory() {
    setState(() {
      if (_selectedCategory == "Popular") {
        _filteredPackages = _allPackages; // Show all packages
      } else if (_selectedCategory == "Center Visit") {
        _filteredPackages = _allPackages.where((p) => p["home_collection"] == false).toList();
      }
    });
  }

  /// Search Functionality
  void _filterPackages() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPackages = _filteredPackages
          .where((package) => package["package_name"].toLowerCase().contains(query))
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
        //       if (_cartItemCount > 0)
        //         Positioned(
        //           right: 0,
        //           top: 0,
        //           child: Container(
        //             padding: EdgeInsets.all(2),
        //             decoration: BoxDecoration(
        //               color: Colors.red,
        //               shape: BoxShape.circle,
        //             ),
        //             constraints: BoxConstraints(minWidth: 16, minHeight: 16),
        //             child: Text(
        //               '$_cartItemCount',
        //               style: TextStyle(color: Colors.white, fontSize: 10),
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
                          hintText: "Search Lab Packages",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    categoryButton("Popular"),
                    categoryButton("Center Visit"),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Packages List
              Expanded(
                child: _filteredPackages.isEmpty
                    ? Center(child: Text("No packages found"))
                    : ListView.builder(
                  itemCount: _filteredPackages.length,
                  itemBuilder: (context, index) {
                    return packageCard(_filteredPackages[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Category Button Widget (Switches Selection)
  Widget categoryButton(String text) {
    bool isSelected = _selectedCategory == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = text;
          _filterByCategory(); // Filter packages based on selection
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? LabColors.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
        ),
      ),
    );
  }

  /// Package Card Widget
  Widget packageCard(dynamic package) {
    bool isInCart = _cartItems.contains(package["test_number"]);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailsScreen(packageId: package["id"]),
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
            Text(package["package_name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(package["about"], style: TextStyle(color: Colors.grey[700]), maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.science, color: Colors.green, size: 16),
                SizedBox(width: 5),
                Text("${package["testslength"]} Lab Tests", style: TextStyle(color: Colors.green)),
              ],
            ),
            SizedBox(height: 8),
            package["home_collection"] == true
                ? Row(
              children: [
                Icon(Icons.home, color: Colors.orange, size: 16),
                SizedBox(width: 5),
                Text("Home", style: TextStyle(color: Colors.orange)),
              ],
            )
                : Row(
              children: [
                Icon(Icons.location_on, color: LabColors.primaryColor, size: 16),
                SizedBox(width: 5),
                Text("Center", style: TextStyle(color: LabColors.primaryColor)),
              ],
            ),
            SizedBox(height: 8),
            Text("₹ ${package["price"]}/-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  if (isInCart) {
                    removeFromCart(package);
                  } else {
                    addToCart(package);
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
