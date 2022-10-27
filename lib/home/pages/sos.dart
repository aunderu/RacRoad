import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/account_setting.dart';
import 'package:rac_road/home/pages/sos/setgps.dart';

import '../../controller/models_controller.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({super.key});

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SOSsetGPS(),
                      ),
                    );
                  },
                  child: Ink(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainGreen,
                          Color.fromARGB(255, 8, 206, 179),
                        ],
                        stops: [0, 1],
                        begin: AlignmentDirectional(1, 0),
                        end: AlignmentDirectional(-1, 0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          // child: Icon(
                          //   Icons.settings_outlined,
                          //   color: Colors.white,
                          //   size: 60,
                          // ),
                          child: Image.asset(
                            'assets/icons/wheel.png',
                            color: Colors.white,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 5, 10, 5),
                            child: AutoSizeText(
                              'เปลี่ยนล้อ ใส่ลมยาง',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () {},
                  child: Ink(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainGreen,
                          Color.fromARGB(255, 8, 206, 179),
                        ],
                        stops: [0, 1],
                        begin: AlignmentDirectional(1, 0),
                        end: AlignmentDirectional(-1, 0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          // child: Icon(
                          //   Icons.settings_outlined,
                          //   color: Colors.white,
                          //   size: 60,
                          // ),
                          child: Image.asset(
                            'assets/icons/towcar.png',
                            color: Colors.white,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 5, 10, 5),
                            child: AutoSizeText(
                              'บริการยกรถ รถลาก',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () {},
                  child: Ink(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainGreen,
                          Color.fromARGB(255, 8, 206, 179),
                        ],
                        stops: [0, 1],
                        begin: AlignmentDirectional(1, 0),
                        end: AlignmentDirectional(-1, 0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          // child: Icon(
                          //   Icons.settings_outlined,
                          //   color: Colors.white,
                          //   size: 60,
                          // ),
                          child: Image.asset(
                            'assets/icons/caroil.png',
                            color: Colors.white,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 5, 10, 5),
                            child: AutoSizeText(
                              'น้ำมันหมด เติมน้ำมัน',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () {},
                  child: Ink(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainGreen,
                          Color.fromARGB(255, 8, 206, 179),
                        ],
                        stops: [0, 1],
                        begin: AlignmentDirectional(1, 0),
                        end: AlignmentDirectional(-1, 0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          // child: Icon(
                          //   Icons.settings_outlined,
                          //   color: Colors.white,
                          //   size: 60,
                          // ),
                          child: Image.asset(
                            'assets/icons/carbattery.png',
                            color: Colors.white,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 5, 10, 5),
                            child: AutoSizeText(
                              'เปลี่ยนแบตเตอรี่',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () {},
                  child: Ink(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainGreen,
                          Color.fromARGB(255, 8, 206, 179),
                        ],
                        stops: [0, 1],
                        begin: AlignmentDirectional(1, 0),
                        end: AlignmentDirectional(-1, 0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          // child: Icon(
                          //   Icons.settings_outlined,
                          //   color: Colors.white,
                          //   size: 60,
                          // ),
                          child: Image.asset(
                            'assets/icons/orther.png',
                            color: Colors.white,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 5, 10, 5),
                            child: AutoSizeText(
                              'บริการอื่น ๆ',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
