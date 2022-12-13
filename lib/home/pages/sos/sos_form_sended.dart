import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:rac_road/home/screens.dart';
import '../../../colors.dart';

class SOSFormSended extends StatelessWidget {
  final String token;
  const SOSFormSended({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Get.to(() => ScreensPage(
                  getToken: token,
                  pageIndex: 2,
                ));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 80),
            Lottie.asset('assets/lotties/calling.json'),
            const SizedBox(height: 15),
            Text(
              "เราได้ข้อมูลของคุณแล้ว !",
              style: GoogleFonts.sarabun(fontSize: 25),
            ),
            Text(
              "เราจะทำการตรวจสอบข้อมูลของคุณ",
              style: GoogleFonts.sarabun(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => ScreensPage(
                      getToken: token,
                      pageIndex: 2,
                    ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: mainGreen),
              child: const Text('กลับหน้าแรก'),
            ),
          ],
        ),
      ),
    );
  }
}
