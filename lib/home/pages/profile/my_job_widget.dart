import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/profile/apply_for_technician/tech_app_form.dart';

class MyJobWidget extends StatefulWidget {
  final String getToken;
  const MyJobWidget({super.key, required this.getToken});

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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 100),
                  child: TAFpage(getToken: widget.getToken),
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
