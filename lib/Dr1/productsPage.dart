// import 'package:flutter/material.dart';
// import 'package:services/Dr1/ProductDetailsPage.dart';
// import 'package:services/constants/constants.dart';
//
// class AllProductPage extends StatefulWidget {
//   @override
//   _AllProductPageState createState() => _AllProductPageState();
// }
//
// class _AllProductPageState extends State<AllProductPage> {
//   List<Map<String, dynamic>> categories = [
//     {"name": "aaaa Care", "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png"},
//     {"name": "Skin Care & Beauty", "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png"},
//     {"name": "Medicines", "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png"},
//     {"name": "Feminine Hygiene", "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png"},
//     {"name": "Health Care", "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png"},
//     {"name": "Healthcare Devices", "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png"},
//   ];
//
//   List<Map<String, dynamic>> products = [
//     {
//       "name": "Himalaya Baby Dettol Combo",
//       "price": 800,
//       "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png",
//     },
//     {
//       "name": "VIVO Hair Oil",
//       "price": 700,
//       "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png",
//     },
//     {
//       "name": "Himalaya Baby Kit",
//       "price": 950,
//       "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png",
//     },
//     {
//       "name": "Johnson's Baby Care Set",
//       "price": 700,
//       "image": "https://dr1-storage.s3.ap-south-1.amazonaws.com/1725448231492-pngwing.com%20%2817%29.png",
//     }
//   ];
//
//   String searchQuery = "";
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> filteredProducts = products
//         .where((product) => product["name"].toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//         title: Container(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchQuery = value;
//               });
//             },
//             decoration: InputDecoration(
//               hintText: "Search...",
//               border: InputBorder.none,
//               icon: Icon(Icons.search, color: Colors.grey),
//             ),
//           ),
//         ),
//         actions: [
//           CircleAvatar(
//             backgroundColor: Colors.blue.shade100,
//             child: Icon(Icons.shopping_cart, color: Colors.blue),
//           ),
//           SizedBox(width: 15),
//         ],
//       ),
//       body: Row(
//         children: [
//           // Left Sidebar - Categories
//           Container(
//             width: 110,
//             color: color1,
//             child: ListView.builder(
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Column(
//                     children: [
//                       Image.network(
//                         categories[index]["image"],
//                         height: 40,
//                         width: 40,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         categories[index]["name"],
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // Right Side - Product Grid
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: GridView.builder(
//                 itemCount: filteredProducts.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.75,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemBuilder: (context, index) {
//                   return InkWell(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(),));
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Image.network(
//                             filteredProducts[index]["image"],
//                             height: 80,
//                             fit: BoxFit.cover,
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             filteredProducts[index]["name"],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "₹ ${filteredProducts[index]["price"]}",
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
//                           ),
//                           SizedBox(height: 10),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
