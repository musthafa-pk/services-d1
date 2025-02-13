import 'package:doctor_one/constants/constants.dart';
import 'package:doctor_one/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ServiceRequestDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;
  const ServiceRequestDetailsPage({
    required this.request,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Service Request Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Request Id: ${request}",
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),

            // Timeline Steps
            // _buildTimelineStep(
            //     isFirst: true,
            //     isLast: false,
            //     isCompleted:true,
            //     title: "Request Submitted",
            //     subtitle: "Started on Thu 22 Aug",
            //     iconColor: Colors.blue),
            // _buildTimelineStep(
            //     isFirst: false,
            //     isLast: false,
            //     isCompleted: true,
            //     title: "Confirmed",
            //     subtitle: "Expected on Thu 22 Aug",
            //     iconColor: Colors.green),
            // _buildTimelineStep(
            //     isFirst: false,
            //     isLast: true,
            //     isCompleted: false,
            //     title: "Completed",
            //     subtitle: "Expected on Thu 22 Aug",
            //     iconColor: Colors.grey),
            const SizedBox(height: 24),

            // Home Nurse Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${request['type'].toString().toUpperCase() ?? ''}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('₹${request['price'] ?? ''}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),

            // Patient Details
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(9)
              ),
              child: _buildCard(
                title: "Patient Details",
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Name", "${request['patient_name'] ?? ''}"),
                    _buildDetailRow("Age", "${request['patient_age'] ?? ''}"),
                    _buildDetailRow("Gender", "${request['patient_gender'] ?? ''}"),
                    _buildDetailRow("Contact Number", "${request['patient_contact_no'] ?? ''}"),
                    _buildDetailRow("Mobility", "${request['patient_mobility'] ?? ''}"),
                    _buildDetailRow("Days/Week", "${request['days_week'] ?? ''}"),
                    _buildDetailRow("General/Specialized", "${request['general_specialized'] ?? ''}"),
                    _buildDetailRow("Start Date", "${request['start_date'] ?? ''}"),
                    _buildDetailRow("End Date", "${request['end_date'] ?? ''}"),
                  ],
                ),
              ),
            ),

            // Address Section
            _buildCard(
              title: "Address",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "${request['patient_location'][0]['address'] ?? ''}",
                    style: TextStyle(fontSize: 14),
                  ),Text(
                    "${request['patient_location'][0]['pincode'] ?? ''}",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Util.openGoogleMaps(double.parse(request["patient_location"][0]["latitude"]),double.parse( request["patient_location"][0]["longitude"]));
                        },
                        child: const Text("View in Map"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Medical Condition
            _buildCard(
              title: "Requirements",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "${request['requirements'] ?? ''}",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            // PDF Reports
            // _buildCard(
            //   title: "Reports",
            //   content: Column(
            //     children: [
            //       _buildPdfRow("Report123.pdf"),
            //       _buildPdfRow("Report123.pdf"),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Timeline Step Widget
  Widget _buildTimelineStep({
    required bool isFirst,
    required bool isLast,
    required bool isCompleted,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(color: isCompleted ? iconColor : Colors.grey),
      indicatorStyle: IndicatorStyle(
        color: iconColor,
        iconStyle: IconStyle(iconData: Icons.check, color: Colors.white),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // Card Widget
  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12)
      ),
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  // Row for Details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  // Row for PDF Reports
  Widget _buildPdfRow(String fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fileName),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text("View"),
          ),
        ],
      ),
    );
  }
}
