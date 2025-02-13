import "package:flutter/material.dart";
import "package:google_places_flutter/google_places_flutter.dart";

import "../../res/appUrl.dart";
import "../../utils/utils.dart";
import "../constants.dart";

Widget _buildGooglePlacesTextField({
  required String label,
  required TextEditingController addressController,
  required TextEditingController pincodeController,
  required Function(Map<String, dynamic>) onAddressSelected, // Callback function
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 8),
      GooglePlaceAutoCompleteTextField(
        textEditingController: addressController,
        googleAPIKey: AppUrl.G_MAP_KEY, // Replace with your API Key
        inputDecoration: InputDecoration(
          filled: true,
          fillColor: primaryColor2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        debounceTime: 800,
        countries: ["IN"], // Restrict to India (change as needed)
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (prediction) async {
          print("Place details: ${prediction.lng} , ${prediction.lat}");

          // Fetch pincode using Google Places API
          String? pincode = await Util.getPincodeFromLatLng(prediction.lat!, prediction.lng!);

          // Update controllers
          addressController.text = prediction.description!;
          pincodeController.text = pincode ?? "N/A";

          // Create an address entry
          Map<String, dynamic> selectedAddress = {
            "address": prediction.description,
            "latitude": prediction.lat.toString(),
            "longitude": prediction.lng.toString(),
            "pincode": pincode ?? "N/A"
          };

          // Update address list using callback
          onAddressSelected(selectedAddress);
        },
        itemClick: (prediction) {
          addressController.text = prediction.description!;
          addressController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description!.length),
          );
        },
        seperatedBuilder: const Divider(),
      ),
    ],
  );
}