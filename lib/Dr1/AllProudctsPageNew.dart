import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:services/Dr1/ProductDetailsPage.dart';
import 'package:http/http.dart' as http;
import 'package:services/constants/constants.dart';
import 'package:services/res/appUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Medicine.dart';
import 'MedicineCart.dart';

class ProductListPage extends StatefulWidget {
  final String category;  // Category passed from the previous page
  ProductListPage({required this.category, super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Category> categories = [];
  Category? selectedCategory;
  List<Product> allProducts = [];  // Store unfiltered list of products
  List<Product> filteredProducts = [];

  Future<void> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(AppUrl.allProduct_LoggedIn),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userID}),  // Sending the userId in the body
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['data'];
      setState(() {
        categories = jsonData.map((category) => Category.fromJson(category)).toList();
        // Find the category passed from the previous page
        selectedCategory = categories.firstWhere(
                (category) => category.categoryName == widget.category,
            orElse: () => categories[0]);  // Default to the first category
        allProducts = selectedCategory?.products ?? [];
        filteredProducts = allProducts; // Initialize filteredProducts with allProducts
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void filterSearchResults(String query) {
    List<Product> tempList = [];
    if (query.isNotEmpty) {
      tempList = allProducts
          .where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.brand.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      tempList = allProducts; // Reset to unfiltered products
    }
    setState(() {
      filteredProducts = tempList;
    });
  }

  void onCategorySelected(Category category) {
    setState(() {
      selectedCategory = category;          // Update the selected category
      filteredProducts = category.products; // Filter products by the selected category
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: color1,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: ValueListenableBuilder<int>(
                  valueListenable: cartNotifier,
                  builder: (context, count, child) {
                    return count > 0
                        ? Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "$count",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                        : SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => filterSearchResults(value),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: color1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Row(
                  children: [
                    // Sidebar - Categories
                    Container(
                      width: 100,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          bool isSelected = categories[index] == selectedCategory;
                          return InkWell(
                            onTap: () => onCategorySelected(categories[index]),
                            child: Column(
                              children: [
                                Container(
                                  height:80,
                                  width:80,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: isSelected ? color1 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(categories[index].categoryImage, width: 40, height: 40),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  categories[index].categoryName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Products Grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            var product = filteredProducts[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProductDetailPage()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(width: 1, color: color1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image
                                    Center(
                                      child: Container(
                                        height:50,width: 50,
                                        child: Image.network(
                                          product.images['image1']!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Brand Name
                                          Text(
                                            product.brand,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                          // Product Name
                                          Text(
                                            product.name,
                                            maxLines: 2,  // Limiting the text to 2 lines
                                            overflow: TextOverflow.ellipsis,  // Showing ellipsis for overflowed text
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          // Price
                                          Text(
                                            "₹ ${product.sellingPrice}",
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}





class Product {
  final int id;
  final String name;
  final String description;
  final double mrp;
  final double sellingPrice;
  final String brand;
  final Map<String, String> images;
  bool inCart;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.mrp,
    required this.sellingPrice,
    required this.brand,
    required this.images,
    this.inCart = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      mrp: json['mrp'].toDouble(),
      sellingPrice: json['selling_price'].toDouble(),
      brand: json['brand'],
      images: {
        "image1": json['images']['image1'],
        "image2": json['images']['image2'],
        "image3": json['images']['image3'],
        "image4": json['images']['image4'],
      },
    );
  }
}

class Category {
  final int id;
  final String categoryName;
  final String categoryImage;
  final List<Product> products;

  Category({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();
    return Category(
      id: json['id'],
      categoryName: json['categoryName'],
      categoryImage: json['categoryImage'],
      products: productList,
    );
  }
}
