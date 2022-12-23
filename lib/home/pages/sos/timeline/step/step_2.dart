import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rac_road/home/screens.dart';
import 'package:http/http.dart' as http;

import '../../../../../colors.dart';

class StepTwo extends StatefulWidget {
  final String getToken;
  final String sosId;
  final DateTime timeStamp;
  final String userName;
  final String userTel;
  final String problem;
  final String problemDetails;
  final String location;
  final String userProfile;
  final String imgIncident;
  final DateTime stepTwoTimeStamp;
  final String repairPrice;
  final String repairDetails;
  const StepTwo({
    super.key,
    required this.getToken,
    required this.sosId,
    required this.timeStamp,
    required this.userName,
    required this.userTel,
    required this.problem,
    required this.problemDetails,
    required this.location,
    required this.userProfile,
    required this.imgIncident,
    required this.stepTwoTimeStamp,
    required this.repairPrice,
    required this.repairDetails,
  });

  @override
  State<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  Future<void> userSendDeal(String sosId, String userDeal) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/sos/step/$sosId"),
      body: {
        'user_deal': userDeal,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 100),
        //ผู้ยืนยันค่าบริการ
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 182, 235, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3571DAFF),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'ฉันยืนยันค่าบริการดังกล่าว',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    userSendDeal(widget.sosId, "no");
                                    Get.to(
                                      () => ScreensPage(
                                        getToken: widget.getToken,
                                        pageIndex: 2,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: whiteGrey,
                                    foregroundColor: darkGray,
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: Text(
                                    "ปฏิเสธ",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    userSendDeal(widget.sosId, "yes");
                                    Get.to(
                                      () => ScreensPage(
                                        getToken: widget.getToken,
                                        pageIndex: 2,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainGreen,
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: Text(
                                    "รับข้อเสนอ",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Image.network(
                                widget.userProfile,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                widget.userName,
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //รายละเอียดค่าบริการ
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 195, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x352F44CA),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(-3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.stepTwoTimeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Get.to(() => Pricing(getToken: widget.getToken));
                          //   },
                          //   child: const Icon(
                          //     Icons.arrow_forward_ios,
                          //     color: darkGray,
                          //     size: 16,
                          //   ),
                          // ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'เสนอค่าบริการซ่อม',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            'ราคาการซ่อม : ${widget.repairPrice}\nรายละเอียดเพิ่มเติม : ${widget.repairDetails}',
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Image.asset(
                                  'assets/imgs/oparator.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                'เจ้าหน้าที่ Racroad',
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        //ผู้ใช้แจ้งเหตุการณ์
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 182, 235, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3571DAFF),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.timeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'เเจ้งเหตุการณ์',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'ชื่อผู้ใช้ : ${widget.userName}\nเบอร์โทร : ${widget.userTel}\n\nปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}',
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: widget.imgIncident,
                              height: 200,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Image.network(
                                widget.userProfile,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                widget.userName,
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
