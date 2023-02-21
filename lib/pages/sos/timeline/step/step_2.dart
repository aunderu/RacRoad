import 'dart:convert';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../../colors.dart';
import '../../../../../models/data/timeline_models.dart';

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
  final String imgIncident;
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
  late List<Timelines> timelines;
  final _formKey = GlobalKey<FormState>();

  TextEditingController userReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    userReasonController = TextEditingController();

    getTimelines();
  }

  @override
  void dispose() {
    userReasonController.dispose();
    super.dispose();
  }

  Future<bool> userSendDeal(
      String sosId, String userDeal, String userReason) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/sos/step/$sosId"),
      body: {
        'user_deal': userDeal,
        'why_urd01': userReason,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
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
              onPressed: () => showFormDialogReject(),
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
              onPressed: () => showFormDialogAccept(),
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

  void showFormDialogAccept() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: mainGreen,
              size: 50,
            ),
            title: Text(
              'คุณกำลังรับข้อเสนอ',
              textAlign: TextAlign.center,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            content: Stack(
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ElevatedButton(
                            onPressed: () {
                              // next
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          mainGreen),
                                      strokeWidth: 8,
                                    ),
                                  );
                                },
                              );

                              userSendDeal(
                                widget.sosId,
                                "yes",
                                "",
                              ).then((value) {
                                if (value == false) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                                    backgroundColor: Colors.yellowAccent,
                                    textColor: Colors.black,
                                  );
                                }

                                Get.offAllNamed('/sos');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainGreen,
                            ),
                            child: Text(
                              'ยืนยัน',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              userReasonController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightGrey,
                            ),
                            child: Text(
                              'ยกเลิก',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                color: darkGray,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFormDialogReject() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            icon: const Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 50,
            ),
            title: Text(
              'คุณกำลังปฏิเสธข้อเสนอ',
              textAlign: TextAlign.center,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            content: Stack(
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: userReasonController,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              label: Text("เหตุผลที่ปฏิเสธ"),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              counterText: "* ไม่จำเป็นต้องกรอก",
                              floatingLabelStyle: TextStyle(
                                fontSize: 20,
                                color: mainGreen,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(
                                Icons.question_mark_rounded,
                                color: mainGreen,
                              ),
                              filled: true,
                              fillColor: Color(0xffffffff),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 5.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: mainGreen,
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: whiteGreen, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffEF4444), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: mainGreen, width: 1.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'คุณสามารถช่วยกรอกเหตุผลที่ปฏิเสธข้อเสนอของคุณเพื่อให้เรานำมาปรับเปลี่ยนได้ในครั้งหน้า',
                              style: GoogleFonts.sarabun(
                                color: darkGray,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: FittedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // next
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      mainGreen),
                                              strokeWidth: 8,
                                            ),
                                          );
                                        },
                                      );

                                      if (userReasonController.text == "") {
                                        userSendDeal(
                                          widget.sosId,
                                          "no",
                                          "ผู้ใช้งานไม่ได้ให้เหตุผล",
                                        ).then((value) {
                                          if (value == false) {
                                            Fluttertoast.showToast(
                                              msg:
                                                  "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                                              backgroundColor:
                                                  Colors.yellowAccent,
                                              textColor: Colors.black,
                                            );
                                          }

                                          Get.offAllNamed('/sos');
                                        });
                                      } else {
                                        userSendDeal(
                                          widget.sosId,
                                          "no",
                                          userReasonController.text,
                                        ).then((value) {
                                          if (value == false) {
                                            Fluttertoast.showToast(
                                              msg:
                                                  "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                                              backgroundColor:
                                                  Colors.yellowAccent,
                                              textColor: Colors.black,
                                            );
                                          }

                                          Get.offAllNamed('/sos');
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: Text(
                                      'ยืนยัน',
                                      style: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      userReasonController.clear();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: lightGrey,
                                    ),
                                    child: Text(
                                      'ยกเลิก',
                                      style: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                        color: darkGray,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
