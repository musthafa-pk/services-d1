import 'package:doctor_one/constants/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../Dr1/uploadPrescription.dart';

class MedicineCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              pharmacyBlue,
              pharmacyBlueLight
            ],
            begin: Alignment.topLeft, // Gradient starts from top-left
            end: Alignment.bottomRight, // Gradient ends at bottom-right
             ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get Your Medicine\nAt Home",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.local_shipping, size: 18),
                        SizedBox(width: 8),
                        Text("Fast Delivery"),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.verified, size: 18),
                        SizedBox(width: 8),
                        Text("100% Safe"),
                      ],
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPrescriptionPage()));
                      },
                      child: Text("Upload Prescription"),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/medic.png', // Replace with your actual image path
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
            right: 130,
            child: CircleAvatar(
              backgroundColor: Colors.white,
            )),
        Positioned(
            bottom: -20,
            right: 130,
            child: CircleAvatar(
              backgroundColor: Colors.white,
            )),
        // Dotted Line
        Positioned(
          top: 25,
          bottom: 25,
          right: 150, // Adjust position to center
          child: CustomPaint(
            size: Size(1, 150), // Height of the dotted line
            painter: DottedLinePainter(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}


class DottedLinePainter extends CustomPainter {
  final double dashHeight;
  final double dashSpace;
  final Color color;

  DottedLinePainter({this.dashHeight = 5, this.dashSpace = 5, this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
