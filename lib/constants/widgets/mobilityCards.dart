import 'package:flutter/material.dart';

import '../constants.dart';

class MobilityCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const MobilityCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(100, 100, 100, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    imagePath,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
