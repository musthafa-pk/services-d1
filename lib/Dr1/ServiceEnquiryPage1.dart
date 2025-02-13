import 'dart:convert';
import 'package:doctor_one/Dr1/ServiceEnquiryPage2.dart';
import 'package:doctor_one/res/appUrl.dart';
import 'package:doctor_one/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/constants.dart';

class ServiceEnqPage1 extends StatefulWidget {
  const ServiceEnqPage1({super.key});

  @override
  State<ServiceEnqPage1> createState() => _ServiceEnqPage1State();
}

class _ServiceEnqPage1State extends State<ServiceEnqPage1> {
  Future<dynamic> fetchServiceRequests() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userID = preferences.getInt('userId');
    try {
      final response = await http.post(
        Uri.parse(AppUrl.getserviceenquiries),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userID}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse["success"] == true) {
          var data = jsonResponse["data"];
          return data;
          //   data.map((request) {
          //   return {
          //     "id": "#${request["id"]}",
          //     "patient_name": "${request["patient_name"]}",
          //     "patient_contact": "${request["patient_contact_no"]}",
          //     "date": request["start_date"] ?? "N/A",
          //     "title": request["type"] ?? "Unknown",
          //     "status": request["status"] ?? "Pending",
          //     "statusColor": getStatusColor(request["status"] ?? "pending")
          //   };
          // }).toList();
        } else {
          throw Exception("API returned an error: ${jsonResponse['message']}");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching service requests: $e");
    }
  }


  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
        return Colors.blue;
      case "placed":
        return Colors.purple;
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Service Request List",style: TextStyle(color: Colors.black),),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_outlined,color: Colors.black,)),
      ),
        body: FutureBuilder(
          future: fetchServiceRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildShimmerEffect(); // Show shimmer while loading
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No service requests available"));
            }

            final serviceRequests = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: serviceRequests.length,
              itemBuilder: (context, index) {
                final request = serviceRequests[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceRequestDetailsPage(request: request),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: primaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Request Id: ${request['id']}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(Util.formatDate(request["created_date"])),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.pink.shade50),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request["type"].toString().toUpperCase() ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  request["status"] ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: request["status"] == 'confirmed' ? Colors.green : Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),

    );
  }


  Widget buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6, // Show 6 shimmer items
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
