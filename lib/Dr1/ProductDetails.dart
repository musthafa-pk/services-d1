//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:services/res/appUrl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
//
//
//
// class ProductDetailPage extends StatefulWidget {
//   @override
//   _ProductDetailPageState createState() => _ProductDetailPageState();
// }
//
// class _ProductDetailPageState extends State<ProductDetailPage> {
//   int quantity = 2; // Default quantity
//   final PageController _pageController = PageController();
//
//   Future<void> getProductDetails() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int? userID = await preferences.getInt('userId');
//     const String url = ""; // Replace with actual API URL
//
//     final Map<String, dynamic> body = {"id": userID};
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200) {
//         print("Success: ${response.body}");
//       } else {
//         print("Failed with status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   final List<String> imageUrls = [
//     "https://your-image-url.com/dettol1.png",
//     "https://your-image-url.com/dettol2.png",
//     "https://your-image-url.com/dettol3.png",
//     "https://your-image-url.com/dettol4.png",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back,color: Colors.black,),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Name & Brand
//               const Text(
//                 "Baby Dettol Combo",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 "Himalaya",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 16),
//
//               // Image Carousel with Page Indicator
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 250,
//                     child: PageView.builder(
//                       controller: _pageController,
//                       itemCount: imageUrls.length,
//                       itemBuilder: (context, index) {
//                         return Image.network(
//                           imageUrls[index],
//                           fit: BoxFit.contain,
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   SmoothPageIndicator(
//                     controller: _pageController,
//                     count: imageUrls.length,
//                     effect: const ExpandingDotsEffect(
//                       dotHeight: 8,
//                       dotWidth: 8,
//                       activeDotColor: Colors.blue, // Blue dot like in your image
//                       dotColor: Colors.grey, // Inactive dots
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // Price and Quantity Selector
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "₹ 800",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             if (quantity > 1) quantity--;
//                           });
//                         },
//                         icon: const Icon(Icons.remove_circle, color: Colors.green),
//                       ),
//                       Text(
//                         "$quantity",
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             quantity++;
//                           });
//                         },
//                         icon: const Icon(Icons.add_circle, color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // Description Box
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade300,
//                       blurRadius: 5,
//                       spreadRadius: 2,
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Description",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Applying lotion after a bath can help keep a newborn's skin hydrated and prevent dryness. Choose a mild baby lotion to maintain the skin's natural moisture barrier, especially in dry or cold climates.",
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: const [
//                         Icon(Icons.check_circle, color: Colors.blue),
//                         SizedBox(width: 8),
//                         Text("Feature options"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }