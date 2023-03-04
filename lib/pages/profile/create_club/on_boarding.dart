import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:rac_road/colors.dart';

import 'create_club.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key, required this.getToken});

  final String getToken;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/imgs/club-banner1.jpg"),
                  scale: 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0, -0.8),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'สร้างคลับของคุณ',
                        style: GoogleFonts.kanit(
                          fontSize: 40,
                          // fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 110, 110),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'ร่วมกันสร้างสังคมพูดคุยของคนที่ชอบรถยนต์ด้วยกันเถอะ!',
                        style: GoogleFonts.kanit(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 110, 110),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/imgs/club-banner2.jpg"),
                  scale: 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0, -0.85),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'พูดคุยและสื่อสาร',
                        style: GoogleFonts.kanit(
                          fontSize: 40,
                          // fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 110, 110),
                        ),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        'คุณและผู้คนที่เข้าคลับจะสามารถโพสต์และแสดงความคิดเห็นได้ร่วมกัน!',
                        style: GoogleFonts.kanit(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 110, 110),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/imgs/club-banner3.jpg"),
                  scale: 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0, -0.85),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'การค้นพบคลับ',
                        style: GoogleFonts.kanit(
                          fontSize: 40,
                          // fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 110, 110),
                        ),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        'หลายผู้คนจะเห็นคลับและแลกเปลี่ยนความรู้เรื่องรถยนต์ร่วมกันมากขึ้น',
                        style: GoogleFonts.kanit(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 110, 110),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
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
