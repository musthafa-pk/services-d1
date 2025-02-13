
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctor_one/Dr1/LoginPage.dart';
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../res/appUrl.dart';


class Util{

  // next field focused in textField
  static fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode nextFocus,){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static double averageRating(List<int>rating){
    var avgRating = 0;
    for(int i = 0; i<rating.length; i++){
      avgRating = avgRating+ rating[i];
    }
    return double.parse((avgRating/rating.length).toStringAsFixed(1));
  }

  static toastMessage(String message){
    Fluttertoast.showToast(msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );}

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // Convert 0 hour to 12 for AM/PM
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }

  static flushBarSuccessMessage(Color? bgColor,String message , BuildContext context){
    showFlushbar(context: context,
      flushbar:
      Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        positionOffset: 20,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(20),
        icon: const Icon(Icons.verified ,size: 28,color: Colors.white,),
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        backgroundColor: bgColor == null ?Colors.lightGreen:bgColor,
        messageColor: Colors.white,
        duration: const Duration(seconds: 3),
      )..show(context),
    );}

  static flushBarErrorMessage(String message , BuildContext context){
    showFlushbar(context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        positionOffset: 20,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(20),
        icon: const Icon(Icons.error ,size: 28,color: Colors.white,),
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        backgroundColor: Colors.red,
        messageColor: Colors.white,
        duration: const Duration(seconds: 3),
      )..show(context),
    );}

  //send fcm tokne to backend
  static Future<void> sendfcmtoken(String fcmtoken) async {
    try {
      // Retrieve the user ID from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      int? userID = preferences.getInt('userId');

      if (userID == null) {
        print('User ID not found');
        return;
      }

      // Define the API URL
      final String apiUrl = MedOneUrls.addtoken;

      // Create the JSON payload
      Map<String, dynamic> payload = {
        "id": userID,
        "token": fcmtoken
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl), // Parse the URL
        headers: {
          "Content-Type": "application/json", // Set the request headers
        },
        body: jsonEncode(payload), // Encode the payload as JSON
      );

      print('fcm token passing to backend...');
      print('check1:${response.body}');
      print('check2:${response.statusCode}');

      // Check the response status
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
      } else {
        print('Failed to send data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions and print the error
      print('An error occurred: $e');
    }
  }

  static Future<void> launchAsInAppWebViewWithCustomHeaders(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw Exception('Could not launch $url');
    }
  }
  //
  //
  //
  // static snackBar(String message , BuildContext context){
  //   return ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text(message))
  //   );
  // }

static Future<dynamic> logout(BuildContext context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>DroneLoginpage() ,));
}


  static Future<String?> getPincodeFromLatLng(String lat, String lng) async {
    String apiKey = AppUrl.G_MAP_KEY; // Replace with your API Key
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == "OK") {
        for (var result in data["results"]) {
          for (var component in result["address_components"]) {
            if (component["types"].contains("postal_code")) {
              return component["long_name"];
            }
          }
        }
      }
    }
    return null; // If pincode is not found
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );
  //
  //     final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //     final User? user = userCredential.user;
  //
  //     // Use the user object for further operations or navigate to a new screen.
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  static String formatDate(String? date) {
    if (date == null || date.isEmpty) return "N/A";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, hh:mm a").format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  static void openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch Google Maps";
    }
  }
}