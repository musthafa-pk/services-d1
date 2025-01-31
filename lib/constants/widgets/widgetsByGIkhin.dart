import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';


class DroneAppWidgets {
  // Widget for a custom TextFormField with an optional suffix icon
  static Widget customTextFormField({
    String? hintText,
    IconData? icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool isIconOnRight = false,
    VoidCallback? onIconPressed, // Callback for icon tap
  }) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: !isIconOnRight && icon != null
            ? Icon(icon, color: Colors.grey)
            : null, // Icon on the left
        suffixIcon: isIconOnRight && icon != null
            ? GestureDetector(
          onTap: onIconPressed,
          child: Icon(icon, color: Colors.grey),
        )
            : null, // Icon on the right with tap handler
        hintText: hintText,hintStyle: TextStyle(fontSize: 12),
        filled: true,
        fillColor: color1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      validator: validator,
    );
  }


  // Widget for a customizable main button
  static Widget mainButton({
    required String title,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    FocusNode? fieldFocus, // Keep this if focus handling is intended
    double width = 350, // Optional width
    double height = 45, // Optional height
    double borderRadius = 10, // Customizable border radius
    TextStyle? textStyle, // Optional custom text style
  }) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: textStyle ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
  static Widget OutLinemainButton({
    required String title,
    required VoidCallback onPressed,
    Color? borderColor,
    Color? textColor,
    double width = 350,
    double height = 45,
    double borderRadius = 10,
    TextStyle? textStyle,
  }) {
    return Container(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: textStyle ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? primaryColor,
            ),
          ),
        ),
      ),
    );
  }

}