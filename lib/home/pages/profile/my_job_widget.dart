import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';

class MyJobWidget extends StatefulWidget {
  const MyJobWidget({super.key});

  @override
  State<MyJobWidget> createState() => _MyJobWidgetState();
}

class _MyJobWidgetState extends State<MyJobWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Image.asset(
            "assets/imgs/mechanic.png",
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            'สนใจเป็นครอบครัวช่างเหมือนกันเหรอ',
            style: GoogleFonts.sarabun(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'สมัครเป็นช่าง',
            style: GoogleFonts.sarabun(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: mainGreen,
            ),
          ),
        ],
      ),
    );
  }
}
