import 'package:doctor_one/Dr1/uploadPrescription.dart';
import 'package:doctor_one/constants/widgets/PrescriptionCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/constants.dart';
import '../res/appUrl.dart';
import 'AllProudctsPageNew.dart';
import 'MedicineCart.dart';

class Category {
  final int id;
  final String category;
  final String image;

  Category({
    required this.id,
    required this.category,
    required this.image
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['category'],
      image: json['image'],
    );
  }
}

class MedicineHomePage extends StatefulWidget {
  @override
  State<MedicineHomePage> createState() => _MedicineHomePageState();
}

class _MedicineHomePageState extends State<MedicineHomePage> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  String? categoryType;
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(AppUrl.productCategory));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchCartItems() async {
    if (!mounted) return; // Ensure the widget is still in the tree

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final url = Uri.parse(AppUrl.getCart);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userID}),
      );

      if (!mounted) return; // Check again after async operation

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            cartItems = data['data'];
            isLoading = false;
          });

          // Update cart count globally
          int totalItems = cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
          cartNotifier.updateCount(totalItems);
        }
      } else {
        throw Exception("Failed to load cart data");
      }
    } catch (error) {
      print("Error fetching cart data: $error");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search, color: pharmacyBlueLight),
                          filled: true,
                          fillColor: pharmacyBlueLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: pharmacyBlueLight,
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
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Stack(
                //     children: [
                //       Container(
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         padding: EdgeInsets.all(16),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'Get Your Medicine \nAt Home',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.w700,
                //               ),
                //             ),
                //             SizedBox(height: 8),
                //             Row(
                //               children: [
                //                 Icon(Icons.delivery_dining, color: Colors.white),
                //                 SizedBox(width: 8),
                //                 Text('Fast Delivery', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)),
                //                 SizedBox(width: 16),
                //                 Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
                //                 SizedBox(width: 8),
                //                 Text('Cash On Delivery', style: TextStyle(color: Colors.white)),
                //               ],
                //             ),
                //             SizedBox(height: 16),
                //           ],
                //         ),
                //       ),
                //       Positioned(
                //         right: 0,
                //         top: 20,
                //         child: InkWell(
                //           onTap: () {
                //             // Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPrescriptionPage( )));
                //             Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPrescriptionPage( )));
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: Colors.pink,
                //               borderRadius: BorderRadius.only(topLeft: Radius.circular(9), bottomLeft: Radius.circular(9)),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 'Upload Prescription',
                //                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MedicineCard(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Explore Our Shop',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<List<Category>>(
                  future: fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show shimmer effect while loading
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 4 / 2,
                          ),
                          itemCount: 6, // Temporary shimmer items
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade50!,
                              highlightColor: pharmacyBlueLight!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 14,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching categories'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No categories available'));
                    }

                    final categories = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 4 / 2,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductListPage(category: categories[index].category),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  pharmacyBlueLight,
                                  pharmacyBlue
                                ],
                                  begin: Alignment.topLeft, // Gradient starts from top-left
                                  end: Alignment.bottomRight, // Gradient ends at bottom-right
                                ),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(width: 90, child: Text(categories[index].category)),
                                      Image.network(
                                        categories[index].image ?? '',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CartNotifier extends ValueNotifier<int> {
  CartNotifier() : super(0);

  void updateCount(int count) {
    value = count;
  }
}

final cartNotifier = CartNotifier();
