import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/constants.dart';
import '../res/appUrl.dart';
import '../utils/utils.dart';

class ProductDetailPage extends StatefulWidget {
  final int productID;
  ProductDetailPage({required this.productID,super.key});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1; // Default quantity
  final PageController _pageController = PageController();
  Map<String, dynamic>? productData;
  bool isLoading = true; // API loading state

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  // Fetch product data API
  Future<void> fetchProductData() async {
     String url = AppUrl.singleProduct; // Replace with actual API URL
     SharedPreferences preferences = await SharedPreferences.getInstance();
     int? userID = preferences.getInt('userId');
    final Map<String, dynamic> body = {"id": widget.productID};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(() {
          productData = jsonDecode(response.body)["data"];
          isLoading = false;
        });
      } else {
        print("Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Send POST request with extracted data
  Future<void> addToCart() async {
    if (productData == null) return;

     String postUrl = AppUrl.addToCart; // Replace with actual order API URL
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final Map<String, dynamic> orderBody = {
      "prod_id": int.parse(productData!["id"].toString()),
      "quantity": int.parse(quantity.toString()),
      "userId": userID
    };

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderBody),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseDate = jsonDecode(response.body);
        Util.toastMessage('${responseDate['message']}');
        Navigator.pop(context);
      } else {
        var responseDate = jsonDecode(response.body);
        Util.toastMessage('${responseDate['message']}');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name & Brand
              Text(
                productData?["name"] ?? "Product Name",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                productData?["brand"] ?? "Brand",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
        
              // Image Carousel
              Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: productData?["images"]?.length ?? 0,
                      itemBuilder: (context, index) {
                        String imageUrl = productData?["images"]["image${index + 1}"] ?? "";
                        return Image.network(imageUrl, fit: BoxFit.contain);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: productData?["images"]?.length ?? 0,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor:pharmacyBlue,
                      dotColor: Colors.grey,
                    ),
                  ),
                ],
              ),
        
              SizedBox(height: 16),
        
              // Price and Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹ ${productData?["mrp"] ?? "0"}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        icon: Icon(Icons.remove_circle, color: Colors.green),
                      ),
                      Text(
                        "$quantity",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add_circle, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
        
              SizedBox(height: 16),
        
              // Description Section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      productData?["description"] ?? "No description available.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: pharmacyBlue),
                        SizedBox(width: 8),
                        Text("Feature options"),
                      ],
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: 16),
        
              // Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pharmacyBlue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Add to cart",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
