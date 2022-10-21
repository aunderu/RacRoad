import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rac_road/home/pages/sos/steptwo_pricing.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Pricing(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward_ios),
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lotties/calling.json'),
          Text(
            'เราได้เห็นคำขอของคุณแล้ว',
            textAlign: TextAlign.center,
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: const Color.fromARGB(255, 169, 223, 248),
            ),
          ),
          Text(
            'เรากำลังติดต่อไป โปรดรอสักครู่',
            textAlign: TextAlign.center,
            style: GoogleFonts.sarabun(
              fontSize: 25,
              color: const Color.fromARGB(255, 169, 223, 248),
            ),
          ),
        ],
      ),
    );
  }
}
