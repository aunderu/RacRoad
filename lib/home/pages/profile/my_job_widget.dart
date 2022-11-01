import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/profile/apply_for_technician/TAF.dart';

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
          const SizedBox(height: 40),
          Image.asset(
            "assets/imgs/mechanic.png",
            height: 150,
          ),
          const SizedBox(height: 20),
          Text(
            'สนใจเป็นครอบครัวช่างเหมือนกันเหรอ',
            style: GoogleFonts.sarabun(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TAFpage(),
                ),
              );
            },
            child: Text(
              'สมัครเป็นช่าง',
              style: GoogleFonts.sarabun(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
