import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/sos/sos_form.dart';
import 'package:rac_road/home/pages/sos/timeline/timeline_page.dart';
import 'package:rac_road/models/my_current_sos_models.dart';
import 'package:rac_road/services/remote_service.dart';

class SOSPage extends StatefulWidget {
  final String token;
  const SOSPage({super.key, required this.token});

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
        padding: const EdgeInsetsDirectional.all(10),
        child: FutureBuilder<MyCurrentSos?>(
          future: RemoteService().getMyCurrentSOS(widget.token),
          builder: (context, snapshot) {
            var result = snapshot.data;
            if (result != null) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  result.count == 1
                      ? Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: ListView.builder(
                            itemCount: result.count,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => TimeLinePage(
                                            getToken: widget.token,
                                            sosId: result.data
                                                .mySosInProgress[index].sosId,
                                          ));
                                    },
                                    child: Ink(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: lightGrey,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        children: [
                                          const Align(
                                            alignment:
                                                AlignmentDirectional(0.8, -1),
                                            child: Icon(
                                              Icons.new_releases_sharp,
                                              color: Color(0x47FF6767),
                                              size: 100,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                              30,
                                              16,
                                              30,
                                              16,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  'ติดตามสถานะ Timeline',
                                                  style: GoogleFonts.sarabun(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  'แจ้งเหตุฉุกเฉินปัจจุบันของคุณ',
                                                  style: GoogleFonts.sarabun(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Material(
                      child: InkWell(
                        splashColor: mainGreen,
                        onTap: () async {
                          result.count != 1
                              ? await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SOSFormPage(
                                      getToken: widget.token,
                                      sosTitle: "เปลี่ยนล้อ ใส่ลมยาง",
                                    ),
                                  ),
                                )
                              : Fluttertoast.showToast(
                                  msg: "คุณได้แจ้งเหตุแล้ว",
                                  backgroundColor: mainRed,
                                  fontSize: 20,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
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
                        onTap: () async {
                          result.count != 1
                              ? await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SOSFormPage(
                                      getToken: widget.token,
                                      sosTitle: "บริการยกรถ รถลาก",
                                    ),
                                  ),
                                )
                              : Fluttertoast.showToast(
                                  msg: "คุณได้แจ้งเหตุแล้ว",
                                  backgroundColor: mainRed,
                                  fontSize: 20,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
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
                        onTap: () async {
                          result.count != 1
                              ? await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SOSFormPage(
                                      getToken: widget.token,
                                      sosTitle: "น้ำมันหมด เติมน้ำมัน",
                                    ),
                                  ),
                                )
                              : Fluttertoast.showToast(
                                  msg: "คุณได้แจ้งเหตุแล้ว",
                                  backgroundColor: mainRed,
                                  fontSize: 20,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
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
                        onTap: () async {
                          result.count != 1
                              ? await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SOSFormPage(
                                      getToken: widget.token,
                                      sosTitle: "เปลี่ยนแบตเตอรี่",
                                    ),
                                  ),
                                )
                              : Fluttertoast.showToast(
                                  msg: "คุณได้แจ้งเหตุแล้ว",
                                  backgroundColor: mainRed,
                                  fontSize: 20,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
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
                        onTap: () async {
                          result.count != 1
                              ? await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SOSFormPage(
                                      getToken: widget.token,
                                      sosTitle: "บริการอื่น ๆ",
                                    ),
                                  ),
                                )
                              : Fluttertoast.showToast(
                                  msg: "คุณได้แจ้งเหตุแล้ว",
                                  backgroundColor: mainRed,
                                  fontSize: 20,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
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
              );
            }
            return const Align(
              alignment: Alignment(0, 0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
                strokeWidth: 8,
              ),
            );
          },
        ),
      ),
    );
  }
}
