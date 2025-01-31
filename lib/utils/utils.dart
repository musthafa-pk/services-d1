
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


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

  //
  // static flushBarErrorMessage(String message , BuildContext context){
  //   showFlushbar(context: context,
  //     flushbar: Flushbar(
  //       forwardAnimationCurve: Curves.decelerate,
  //       reverseAnimationCurve: Curves.easeOut,
  //       positionOffset: 20,
  //       flushbarPosition: FlushbarPosition.TOP,
  //       borderRadius: BorderRadius.circular(20),
  //       icon: const Icon(Icons.error ,size: 28,color: Colors.white,),
  //       margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //       padding: const EdgeInsets.all(15),
  //       message: message,
  //       backgroundColor: Colors.lightGreen,
  //       messageColor: Colors.white,
  //       duration: const Duration(seconds: 3),
  //     )..show(context),
  //   );}
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

}