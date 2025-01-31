import 'dart:async';

import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';

class OrderTrackingPage extends StatelessWidget {
  final Map<String, dynamic> orderData;

  OrderTrackingPage({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Orders"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order No: ${orderData['so_number'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              OrderStatus(statusDetails: orderData['statusDetails']),
              Divider(),
              OrderDetails(salesList: orderData['sales_list'] ?? []),
              Divider(),
              AddressDetails(orderData: orderData),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final Map<String, dynamic> statusDetails;

  OrderStatus({required this.statusDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderStep("Order Placed", statusDetails['placed'], statusDetails['placedDate']),
        OrderStep("Order Confirmed", statusDetails['confirmed'], statusDetails['confirmedDate']),
        OrderStep("Order Packed", statusDetails['packed'], statusDetails['packedDate']),
        OrderStep("Shipped", statusDetails['shipped'], statusDetails['shippedDate']),
        OrderStep("Delivered", statusDetails['delivered'], statusDetails['deliveryDate']),
      ],
    );
  }
}

class OrderStep extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final String? date;

  OrderStep(this.title, this.isCompleted, this.date);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle,
        color: isCompleted ? d1blue : Colors.grey,
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        isCompleted ? "Completed on ${date?.split('T')[0]}" : "Pending",
        style: TextStyle(color: isCompleted ? Colors.green : Colors.red),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final List<dynamic> salesList;

  OrderDetails({required this.salesList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...salesList.map((item) => OrderItem(
          name: item['generic_prodid']['name'],
          price: item['generic_prodid']['mrp'],
          quantity: item['order_qty'],
          images: item['generic_prodid']['images'],
        )),
        SizedBox(height: 10),
        OrderSummary(totalAmount: salesList.fold(0, (sum, item) => sum + int.parse(item['net_amount'] ?? '0'))),
      ],
    );
  }
}


class OrderItem extends StatefulWidget {
  final String name;
  final int price;
  final int quantity;
  final Map<String, dynamic> images;

  OrderItem({required this.name, required this.price, required this.quantity, required this.images});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  // Auto-scroll function for images
  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < widget.images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Single container with auto-scrolling images
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color1,
                    borderRadius: BorderRadius.circular(9)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PageView(
                      controller: _pageController,
                      children: widget.images.entries.map((entry) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(entry.value, width: 120, height: 120, fit: BoxFit.cover),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Product details on the right side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₹${widget.price}", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text("x${widget.quantity}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


class OrderSummary extends StatelessWidget {
  final int totalAmount;

  OrderSummary({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryRow("Total Amount", "₹$totalAmount", isBold: true),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  SummaryRow(this.title, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class AddressDetails extends StatelessWidget {
  final Map<String, dynamic> orderData;

  AddressDetails({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("${orderData['delivery_address'] ?? 'N/A'}"),
        Text("${orderData['district'] ?? ''}"),
        Text("Pincode - ${orderData['pincode'] ?? ''}"),
        Text("Contact - ${orderData['contact_no'] ?? ''}"),
      ],
    );
  }
}
