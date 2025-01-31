import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services/constants/constants.dart';
import 'package:services/res/appUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final url = Uri.parse(AppUrl.getCart); // Replace with actual API URL

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userID}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            cartItems = data['data'];
            isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load cart data");
      }
    } catch (error) {
      print("Error fetching cart data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateQuantity(int index, bool increase) {
    setState(() {
      if (increase) {
        cartItems[index]['quantity']++;
      } else if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(color: Colors.black, fontSize: 20)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CartItemCard(
                  item: cartItems[index],
                  onQuantityChange: (increase) {
                    updateQuantity(index, increase);
                  },
                );
              },
            ),
          ),
          CheckoutSection(cartItems),
        ],
      ),
    );
  }
}


// Widget for each cart item
class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(bool) onQuantityChange;

  CartItemCard({required this.item, required this.onQuantityChange});

  @override
  Widget build(BuildContext context) {
    final images = item['images'] as Map<String, dynamic>;
    final firstImage = images.values.first;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            Image.network(
              firstImage,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['product_name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "₹ ${item['mrp']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            // Quantity Selector
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.green),
                  onPressed: () => onQuantityChange(false),
                ),
                Text(
                  "${item['quantity']}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () => onQuantityChange(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// Widget for checkout section
class CheckoutSection extends StatelessWidget {
  final List<dynamic> cartItems;

  CheckoutSection(this.cartItems);

  @override
  Widget build(BuildContext context) {
    int totalItems = cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
    int totalPrice = cartItems.fold(0, (sum, item) => sum + ((item['mrp'] as int) * (item['quantity'] as int)));


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "$totalItems Items in the cart",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹ $totalPrice",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    // Implement checkout functionality
                    print("Proceed to Checkout");
                  },
                  child: Container(
                    decoration: BoxDecoration(color: d1blue, borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


