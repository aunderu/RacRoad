import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:rac_road/colors.dart';

import 'create_club.dart';


class OnBoardingPage extends StatefulWidget {
  final String getToken;
  const OnBoardingPage({super.key, required this.getToken});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          children: const [
            Center(
              child: Text('Page 1'),
            ),
            Center(
              child: Text('Page 2'),
            ),
            Center(
              child: Text('Page 3'),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const WormEffect(
                  spacing: 20,
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: mainGreen,
                  dotColor: Colors.black26,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 100),
                        reverseDuration: const Duration(milliseconds: 100),
                        child: CreateClubPage(getToken: widget.getToken),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                    minimumSize: const Size(
                      300,
                      40,
                    ),
                  ),
                  child: Text(
                    'สร้างคลับ',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'โดยการสร้างคลับ คุณได้ยินยอมข้อตกลงแล้ว',
                  style: GoogleFonts.sarabun(),
                ),
                Text(
                  'อ่านข้อตกลง',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
