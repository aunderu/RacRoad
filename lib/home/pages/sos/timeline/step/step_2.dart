import 'dart:convert';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:rac_road/home/screens.dart';
import 'package:http/http.dart' as http;

import '../../../../../colors.dart';
import '../../../../../models/data/timeline_models.dart';

class StepTwo extends StatefulWidget {
  final String getToken;
  final String sosId;
  final DateTime stepOnetimeStamp;
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

  @override
  State<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  late List<Timelines> timelines;

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
  void initState() {
    super.initState();

    getTimelines();
  }

  void getTimelines() {
    timelines = [
      Timelines(
        widget.stepOnetimeStamp,
        "แจ้งเหตุการณ์",
        Column(
          children: [
            Text(
              "ปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}",
              style: GoogleFonts.sarabun(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.imgIncident,
                    height: 200,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
                "ปฏิเสธ",
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                userSendDeal(widget.sosId, "yes");
                Get.offNamed('/sos');
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
    Size size = MediaQuery.of(context).size;
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
                        'd MMMM ${timelines.timestamp.yearInBuddhistCalendar}')
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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
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
