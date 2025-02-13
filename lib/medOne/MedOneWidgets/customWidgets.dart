
import 'package:flutter/material.dart';
import '../Constants/AppColors.dart';

class Dronewidgets {
  // Main button widget with customizable onPressed functionality
  static Widget mainButton({
    required String title,
    required VoidCallback onPressed,
    Color? backgroundColor, // Optional parameter for button background color
    Color? textColor, // Optional parameter for text color
    FocusNode? fieldFocus,
  }) {
    return Container(
      width: 350,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed, // Use the passed onPressed function
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor2, // Use passed background color or default
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36), // Rounded corners
          ),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: textColor
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title, // Use the passed title
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white, // Use passed text color or default to white
            ),
          ),
        ),
      ),
    );
  }

  // Back button widget
  static Widget backButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryColor,
        child: IconButton(
          padding: EdgeInsets.zero, // Remove the default padding
          constraints: BoxConstraints(), // Remove any size constraints
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  // Custom text form field widget with a controller
  static Widget customTextFormField({
    String? hintText,
    required TextEditingController controller, // Add controller parameter
    FocusNode? fieldFocus,
    bool obscureText = false, // Add obscureText parameter with a default value
    Widget? suffixIcon, // Add suffixIcon parameter
    String? Function(String?)? validator, // Add validator parameter
    String? Function(String?)? onFieldSubmitted,
  }) {
    return Container(
      width: 390,
      height: 55,
      child: TextFormField(
        controller: controller, // Use the passed controller
        focusNode:fieldFocus ,
        obscureText: obscureText, // Use the passed obscureText value
        decoration: InputDecoration(
          hintText: hintText ?? '', // Set the placeholder text if provided
          filled: true,
          fillColor: AppColors.textfiedlColorDr1,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20), // Padding inside the field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36), // Rounded corners
            borderSide: BorderSide.none, // No border by default
          ),
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.grey, // Hint text color
          ),
          suffixIcon: suffixIcon, // Add the suffixIcon if provided
        ),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.black, // Text color
        ),
        validator: validator, // Use the validator if provided
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }

// Widget for the two buttons and text displayed above them
  static Widget medicationOptions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Do you have any past orders or you need to add it manually',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        // "Past order" button
        mainButton(
          title: 'Past order',
          onPressed: () {
            // Action for Past order
          },
          backgroundColor: AppColors.primaryColor2, // Light blue color
          textColor: Colors.white,
        ),
        SizedBox(height: 12),
        // "Add Medication" button
        mainButton(
          title: 'Add Medication',
          onPressed: () {
            // Action for Add Medication
          },
          backgroundColor: AppColors.primaryColor2, // Light blue color
          textColor: Colors.white,
        ),
      ],
    );
  }
}