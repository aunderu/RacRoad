import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../colors.dart';

class JobWidget extends StatelessWidget {
  final String getToken;
  final String clubProfile;
  final String tncName;
  final String jobZone;
  final String status;
  const JobWidget({
    super.key,
    required this.getToken,
    required this.clubProfile,
    required this.tncName,
    required this.jobZone,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Material(
          child: InkWell(
            onTap: () {
              if (status != "รอการอนุมัติ") {
                // Get.to(
                //   () => ,
                // );
              } else {
                Fluttertoast.showToast(msg: "กำลังรอการอนุมัติ");
              }
            },
            child: Ink(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: lightGrey,
              ),
              child: Stack(
                children: [
                  const Align(
                    alignment: AlignmentDirectional(1, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Icon(
                        Icons.keyboard_control,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            clubProfile,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tncName,
                                  style: GoogleFonts.sarabun(
                                    fontSize: 25,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Zone : ',
                                      style: GoogleFonts.sarabun(),
                                    ),
                                    Text(
                                      jobZone,
                                      style: GoogleFonts.sarabun(),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Status : ',
                                      style: GoogleFonts.sarabun(),
                                    ),
                                    Text(
                                      status,
                                      style: GoogleFonts.sarabun(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
