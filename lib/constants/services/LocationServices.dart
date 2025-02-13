import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LocationService {
  final String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController districtController = TextEditingController();

  Future<void> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled. Please enable them.")),
      );
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission denied")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permissions are permanently denied")),
      );
      return;
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await _getAddressFromGoogleMaps(position.latitude, position.longitude, context);
  }

  Future<void> _getAddressFromGoogleMaps(double latitude, double longitude, BuildContext context) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleApiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "OK" && data["results"].isNotEmpty) {
          final address = data["results"][0]["formatted_address"];
          final components = data["results"][0]["address_components"];

          String pincode = "Not Available";
          String district = "Not Available";

          for (var component in components) {
            if (component["types"].contains("postal_code")) {
              pincode = component["long_name"];
            }
            if (component["types"].contains("administrative_area_level_2")) {
              district = component["long_name"];
            }
          }

            addressController.text = address;
            pincodeController.text = pincode;
            districtController.text = district;
        } else {
          print("No location details found.");
        }
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }
}
