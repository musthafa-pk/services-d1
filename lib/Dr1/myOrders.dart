import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../res/appUrl.dart';
import 'TrackOrder.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    String url = AppUrl.myorders;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({"userId": userID}),
      headers: {'Content-Type': 'application/json'},
    );
    print('respnso:${response.body}');
    if (response.statusCode == 200) {
      print('respnso:${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        orders = data['data'];
        print('ddd:${orders}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("My Orders", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final productList = order['sales_list'];
          final product = productList.isNotEmpty ? productList[0]['generic_prodid'] : null;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order # ${order['so_number']}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Expected on ${order['statusDetails']['placedDate'] ?? 'N/A'}",
                          style: TextStyle(color:primaryColor, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        if (product != null)
                          Row(
                            children: [
                              if (product['images']['image1'] != null)
                                Image.network(
                                  product['images']['image1'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  product['name'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10),




                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingPage(orderData: order),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: pharmacyBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      child: Text("Track Order", style: TextStyle(color: Colors.black)),
                    ),
                  ),

                ),
              ],
            ),
          );
        },
      ),
    );
  }
}