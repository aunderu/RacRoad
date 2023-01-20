import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PickInterests extends StatelessWidget {
  final String title;
  const PickInterests({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        title,
        style: GoogleFonts.sarabun(
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      backgroundColor: const Color.fromARGB(113, 0, 170, 170),
    );
  }
}