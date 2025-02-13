// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class APage extends StatefulWidget {
//   @override
//   _APageState createState() => _APageState();
// }
//
// class _APageState extends State<APage> {
//   final _formKey = GlobalKey<FormState>();
//   final _scrollController = ScrollController();
//   final int userId = 24; // Replace with actual user ID from auth context
//
//   Map<String, String> formData = {
//     'name': '',
//     'contact_no': '',
//     'delivery_address': '',
//     'district': '',
//     'nearest_landmark': '',
//     'pincode': '',
//     'remarks': '',
//     'location': '',
//   };
//
//   Map<String, String> errors = {};
//   bool checked = false;
//   bool loading = false;
//
//   void handleChange(String name, String value) {
//     setState(() {
//       formData[name] = value;
//     });
//   }
//   Map<String, String> validateForm() {
//     Map<String, String> newErrors = {};
//
//     // Name validation
//     if (formData['name']!.isEmpty) {
//       newErrors['name'] = 'Name is required';
//     }
//
//     // Contact number validation
//     if (formData['contact_no']!.isEmpty ||
//         !RegExp(r'^[6-9]\d{9}$').hasMatch(formData['contact_no']!)) {
//       newErrors['contact_no'] = 'Invalid Contact Number';
//     }
//
//     // Delivery address validation
//     if (formData['delivery_address']!.isEmpty) {
//       newErrors['delivery_address'] = 'Delivery details are required';
//     }
//
//     // District validation
//     if (formData['district']!.isEmpty) {
//       newErrors['district'] = 'District required';
//     }
//
//     // Pincode validation
//     if (formData['pincode']!.isEmpty || formData['pincode']!.length != 6) {
//       newErrors['pincode'] = 'Invalid Pincode';
//     }
//
//     // Remarks validation
//     if (formData['remarks']!.isEmpty) {
//       newErrors['remarks'] = 'Remarks are required';
//     }
//
//     // Landmark validation
//     if (formData['nearest_landmark']!.isEmpty) {
//       newErrors['nearest_landmark'] = 'Nearest landmark required';
//     }
//
//     // Consent checkbox validation
//     if (!checked) {
//       newErrors['checked'] = 'Please provide consent to be contacted';
//     }
//
//     return newErrors;
//   }
//
//   Future<void> handleSubmit() async {
//     final newErrors = validateForm();
//     if (newErrors.isNotEmpty) {
//       setState(() => errors = newErrors);
//       return;
//     }
//
//     setState(() => loading = true);
//
//     try {
//       final response = await http.post(
//         Uri.parse('http://13.232.117.141:3003/pharmacy/salesorder'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           "userId": userId,
//           "name": formData['name'],
//           "total_amount": "1600", // Replace with actual calculation
//           "so_status": "placed",
//           "remarks": formData['remarks'],
//           "order_type": "salesorder",
//           "created_by": userId,
//           "delivery_address": formData['delivery_address'],
//           "delivery_location": formData['nearest_landmark'],
//           "city": formData['district'], // Using district as city
//           "district": formData['district'],
//           "pincode": formData['pincode'],
//           "contact_no": formData['contact_no'],
//           // "products": [] // Add products if needed
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Order Placed Successfully')),
//         );
//       } else {
//         throw Exception('Failed with status: ${response.statusCode}');
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${error.toString()}')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }
//
//   // Keep other methods (validateForm, build methods) the same as before
//   // ...
//
//   Widget _buildTextField(String label, String key, {TextInputType? keyboardType, int maxLines = 1, List<TextInputFormatter>? inputFormatters}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: TextEditingController(text: formData[key]),
//             decoration: InputDecoration(
//               labelText: label,
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               filled: true,
//               fillColor: Colors.grey[200],
//             ),
//             keyboardType: keyboardType,
//             maxLines: maxLines,
//             inputFormatters: inputFormatters,
//             onChanged: (value) => handleChange(key, value),
//           ),
//           if (errors.containsKey(key))
//             Padding(
//               padding: const EdgeInsets.only(top: 5),
//               child: Text(
//                 errors[key]!,
//                 style: const TextStyle(color: Colors.red, fontSize: 14),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // Update the phone number and pincode fields in build method:
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Form')),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           controller: _scrollController,
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               _buildTextField('Name', 'name'),
//               _buildTextField(
//                 'Contact Number',
//                 'contact_no',
//                 keyboardType: TextInputType.phone,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(10),
//                 ],
//               ),
//               _buildLandmarkField(),
//               _buildTextField('Delivery Address', 'delivery_address', maxLines: 3),
//               _buildTextField('District', 'district'),
//               _buildTextField(
//                 'Pincode',
//                 'pincode',
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(6),
//                 ],
//               ),
//               _buildTextField('Remarks', 'remarks', maxLines: 3),
//               _buildConsentSection(),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }