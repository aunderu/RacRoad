import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../colors.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/imgs/profile.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'User Name',
                  style: GoogleFonts.sarabun(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: IconButton(
                  hoverColor: Colors.transparent,
                  iconSize: 60,
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            centerTitle: false,
            elevation: 0,
          ),
        ],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, -1),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Text(
                          'ชื่อรถ',
                          style: GoogleFonts.sarabun(),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: AlignmentDirectional(1, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                        child: Icon(
                          Icons.keyboard_control,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1, 1),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 5),
                        child: Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            'การเชื่อมต่อ',
                            style: GoogleFonts.sarabun(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 25, 0, 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'ผู้ผลิด : ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                'ปี : ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                'เชื้อเพลิง : ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                '(CC) : ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                'เลขไมล์ : ',
                                style: GoogleFonts.sarabun(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 25, 0, 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'บลา ๆ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                'บลา ๆ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                'บลา ๆ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                'บลา ๆ',
                                style: GoogleFonts.sarabun(),
                              ),
                              Text(
                                '20000 miles',
                                style: GoogleFonts.sarabun(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: GridView(
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'น้ำมัน',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เครื่อง',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: 0.5,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        '50%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เบรก',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: 0.5,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        '50%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เพาเวอร์',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: 0.5,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        '50%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'ยางรถ',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ผ้าเบรก',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: 0.5,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        '50%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ยางรถ',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: 0.5,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        '50%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'แบตเตอรี่',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'แบตเตอรี่',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: 0.5,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        '50%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'แอร์',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'น้ำยา',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: 0.5,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        '50%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
