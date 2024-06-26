import 'dart:convert';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/api_url.dart';
import '../../../../utils/colors.dart';
import '../../../../../models/data/timeline_models.dart';
import '../../../../models/sos/sos_details_models.dart';

class StepTwo extends StatefulWidget {
  const StepTwo({
    super.key,
    required this.getToken,
    required this.sosId,
    required this.stepOnetimeStamp,
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

  final String getToken;
  final List<Img> imgIncident;
  final String location;
  final String problem;
  final String problemDetails;
  final String repairDetails;
  final String repairPrice;
  final String sosId;
  final DateTime stepOnetimeStamp;
  final DateTime stepTwoTimeStamp;
  final String userName;
  final String userProfile;
  final String userTel;

  @override
  State<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  final controller = PageController();
  late List<Timelines> timelines;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getTimelines();
  }

  Future<void> userSendDeal(String sosId, String userDeal) async {
    final response = await http.post(
      Uri.parse("$currentApi/sos/step/$sosId"),
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

  void getTimelines() {
    timelines = [
      Timelines(
        widget.stepOnetimeStamp,
        "แจ้งเหตุการณ์",
        Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "ปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}",
                style: GoogleFonts.sarabun(),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView.builder(
                      controller: controller,
                      itemCount: widget.imgIncident.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: widget.imgIncident[index].image,
                          height: 200,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: widget.imgIncident.length,
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
              ),
            ),
          ],
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
      Timelines(
        widget.stepTwoTimeStamp,
        "เสนอบริการค่าซ่อม",
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายละเอียดเพิ่มเติม :',
                  style: GoogleFonts.sarabun(),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.repairDetails,
                  style: GoogleFonts.sarabun(),
                ),
                const SizedBox(height: 15),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'รวมทั้งหมด :',
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                    Text(
                      "${widget.repairPrice} บาท",
                      style: GoogleFonts.sarabun(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        DateTime.now(),
        "ฉันยืนยันรับข้อเสนอดังกล่าว",
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'ปฏิเสธข้อเสนอดังกล่าว',
                  titleStyle: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                  middleText:
                      'คุณกำลังปฏิเสธข้อเสนอ เมื่อคุณปฏิเสธจะไม่สามารถย้อนกลับได้',
                  confirm: ElevatedButton(
                    onPressed: () {
                      userSendDeal(widget.sosId, "no");

                      Get.offAllNamed('/sos');

                      Fluttertoast.showToast(
                        msg:
                            "คุณปฏิเสธข้อเสนอ สามารถดูประวัติของคุณได้ที่\nหน้าโปรไฟล์ -> ประวัติการแจ้งเหตุฉุกเฉินของฉัน",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 15,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteGrey,
                      foregroundColor: darkGray,
                      minimumSize: const Size(100, 40),
                    ),
                    child: Text(
                      "ยกเลิกข้อเสนอ",
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  cancel: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      minimumSize: const Size(100, 40),
                    ),
                    child: Text(
                      "ฉันขอคิดดูก่อน",
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'ยืนยันข้อเสนอดังกล่าว',
                  titleStyle: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                  middleText:
                      'คุณกำลังยืนยันข้อเสนอดังกล่าว เมื่อคุณยืนยันจะไม่สามารถย้อนกลับได้',
                  confirm: ElevatedButton(
                    onPressed: () {
                      userSendDeal(widget.sosId, "yes");
                      Get.offAllNamed('/sos');

                      Fluttertoast.showToast(
                        msg: "คุณได้ยืนยันรับข้อเสนอดังกล่าว",
                        backgroundColor: lightGreen,
                        textColor: Colors.white,
                        fontSize: 15,
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
                  cancel: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteGrey,
                      foregroundColor: darkGray,
                      minimumSize: const Size(100, 40),
                    ),
                    child: Text(
                      "ฉันขอคิดดูก่อน",
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
          ],
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
    ].toList();
  }

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Timelines, DateTime>(
      elements: timelines,
      reverse: true,
      useStickyGroupSeparators: true,
      floatingHeader: true,
      shrinkWrap: true,
      order: GroupedListOrder.DESC,
      groupBy: (timelines) => DateTime(
        timelines.timestamp.month,
        timelines.timestamp.day,
        timelines.timestamp.hour,
      ),
      groupHeaderBuilder: (Timelines timelines) => SizedBox(
        height: 40,
        child: Center(
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                DateFormat(
                        'd MMMM ${timelines.timestamp.yearInBuddhistCalendar}  เวลา hh:mm')
                    .format(timelines.timestamp),
                style: GoogleFonts.sarabun(
                  color: darkGray,
                ),
              ),
            ),
          ),
        ),
      ),
      itemBuilder: (context, Timelines timelines) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: timelines.isSentByMe == "1"
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            timelines.isSentByMe == "1"
                ? Row(
                    children: [
                      Text(
                        DateFormat('KK:mm').format(timelines.timestamp),
                      ),
                      const SizedBox(width: 10),
                    ],
                  )
                : const SizedBox.shrink(),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(12.0),
                  bottomRight: timelines.isSentByMe == "1"
                      ? const Radius.circular(0)
                      : const Radius.circular(12.0),
                  topLeft: const Radius.circular(12.0),
                  bottomLeft: timelines.isSentByMe != "1"
                      ? const Radius.circular(0)
                      : const Radius.circular(12.0),
                ),
              ),
              color: timelines.isSentByMe == "1"
                  ? const Color.fromARGB(255, 182, 235, 255)
                  : const Color.fromARGB(255, 185, 195, 255),
              elevation: 8,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 20, 0),
                                child: Text(
                                  timelines.title!,
                                  style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Divider(
                                  thickness: 1,
                                  color: Color(0x392E2E2E),
                                ),
                              ),
                              timelines.body,
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 10, 0, 0),
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
                                  child: timelines.isSentByMe == "1"
                                      ? CachedNetworkImage(
                                          imageUrl: timelines.profile,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  "assets/imgs/profile.png"),
                                        )
                                      : Image.asset(timelines.profile),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: Text(
                                    timelines.name,
                                    style: GoogleFonts.sarabun(),
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
            ),
            timelines.isSentByMe != "1"
                ? Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('KK:mm').format(timelines.timestamp),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
