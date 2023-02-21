import 'dart:async';
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

import '../../../../../colors.dart';
import '../../../../../models/data/timeline_models.dart';

class StepFour extends StatefulWidget {
  const StepFour({
    super.key,
    required this.getToken,
    required this.stepOnetimeStamp,
    required this.userName,
    required this.userTel,
    required this.problem,
    required this.problemDetails,
    required this.location,
    required this.userProfile,
    required this.imgIncident,
    required this.stepTwoTimeStamp,
    required this.stepThreeTimeStamp,
    required this.stepFourTimeStamp,
    required this.repairPrice,
    required this.repairDetails,
    required this.tncName,
    required this.tncStatus,
    required this.tncProfile,
    required this.imgBfwork,
    this.priceTwoStatus,
    required this.sosId,
    this.repairPriceTwo,
    this.repairDetailsTwo,
    this.tuPriceTwoTimeStamp,
    this.userDealTwo,
    this.tuUserDealTwoTimeStamp,
  });

  final String getToken;
  final String? imgBfwork;
  final String imgIncident;
  final String location;
  final String? priceTwoStatus;
  final String problem;
  final String problemDetails;
  final String repairDetails;
  final String? repairDetailsTwo;
  final String repairPrice;
  final String? repairPriceTwo;
  final String sosId;
  final DateTime stepFourTimeStamp;
  final DateTime stepOnetimeStamp;
  final DateTime stepThreeTimeStamp;
  final DateTime stepTwoTimeStamp;
  final DateTime? tuPriceTwoTimeStamp;
  final String tncName;
  final String? tncProfile;
  final String tncStatus;
  final String userName;
  final String userProfile;
  final String userTel;
  final String? userDealTwo;
  final DateTime? tuUserDealTwoTimeStamp;

  @override
  State<StepFour> createState() => _StepFourState();
}

class _StepFourState extends State<StepFour> {
  final _formKey = GlobalKey<FormState>();
  late List<Timelines> timelines;
  TextEditingController userReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userReasonController = TextEditingController();

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
        widget.stepThreeTimeStamp,
        "ฉันยืนยันรับข้อเสนอดังกล่าว",
        Text(
          "ฉันได้ยืนยันค่าบริการ จำนวน ${widget.repairPrice} บาท",
          style: GoogleFonts.sarabun(),
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
      Timelines(
        widget.stepThreeTimeStamp,
        "เรียบร้อย! เรากำลังหาช่างในพื้นที่ใกล้เคียงให้คุณ",
        Text(
          "โปรดรอสักครู่",
          style: GoogleFonts.sarabun(),
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        widget.stepFourTimeStamp,
        "ช่างที่เลือก",
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: CachedNetworkImage(
                      imageUrl: widget.tncProfile ??
                          'https://racroad.com/img/admin.71db083f.jpg',
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.tncName,
                  style: GoogleFonts.sarabun(),
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
        widget.stepFourTimeStamp,
        "ช่างรับงานและออกปฎิบัติงาน",
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
              child: Text(
                'สถานะ : ${widget.tncStatus}',
                style: GoogleFonts.sarabun(),
              ),
            ),
            widget.tncStatus != "ช่างถึงหน้างานเเล้ว"
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                        child: Text(
                          'รูปก่อนเริ่มงาน : ',
                          style: GoogleFonts.sarabun(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: CachedNetworkImage(
                              imageUrl: widget.imgBfwork!,
                              alignment: Alignment.center,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        widget.tncProfile!,
        widget.tncName,
        "3",
      ),
    ].toList();

    isPriceTwoStatus();
  }

  Future<bool> userSendDeal(
      String sosId, String userDeal, String userReason) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/set/user/deal2/$sosId"),
      body: {
        'user_deal2': userDeal,
        'why_urd01': userReason,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  void isPriceTwoStatus() {
    if (widget.priceTwoStatus == "yes") {
      setState(() {
        timelines.add(
          Timelines(
            widget.tuPriceTwoTimeStamp!,
            "เนื่องจากมีการเสนอค่าบริการใหม่ นี้คือข้อเสนอบริการค่าซ่อมก่อนเริ่มงาน",
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
                      widget.repairDetailsTwo!,
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
                          "${widget.repairPriceTwo} บาท",
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
        );
        timelines.add(
          widget.userDealTwo != "yes"
              ? Timelines(
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
                )
              : Timelines(
                  widget.tuUserDealTwoTimeStamp!,
                  "ฉันยืนยันรับข้อเสนอดังกล่าว",
                  Text(
                    "ฉันได้ยืนยันค่าบริการ จำนวน ${widget.repairPriceTwo} บาท",
                    style: GoogleFonts.sarabun(),
                  ),
                  widget.userProfile,
                  widget.userName,
                  "1",
                ),
        );
      });
    }
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
  void dispose() {
    userReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GroupedListView<Timelines, DateTime>(
      elements: timelines,
      reverse: true,
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: true,
      floatingHeader: true,
      shrinkWrap: true,
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
              color: ((() {
                if (timelines.isSentByMe == "1") {
                  return const Color.fromARGB(255, 182, 235, 255);
                } else if (timelines.isSentByMe == "2") {
                  return const Color.fromARGB(255, 185, 195, 255);
                } else if (timelines.isSentByMe == "3") {
                  return const Color.fromARGB(255, 255, 239, 185);
                } else {
                  return const Color.fromARGB(255, 185, 195, 255);
                }
              })()),
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
                                padding: EdgeInsets.symmetric(vertical: 1),
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
                                  child: timelines.isSentByMe != "2"
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
