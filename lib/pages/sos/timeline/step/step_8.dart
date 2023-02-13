import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../../../../colors.dart';
import '../../../../../models/data/timeline_models.dart';

class StepEight extends StatefulWidget {
  const StepEight({
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
    required this.stepFiveTimeStamp,
    required this.stepSixTimeStamp,
    required this.repairPrice,
    required this.repairDetails,
    required this.tncName,
    required this.tncStatus,
    this.tncProfile,
    this.imgBfwork,
    this.imgAfwork,
    this.qrCode,
    required this.stepSevenTimeStamp,
    required this.rate,
    required this.review,
    required this.userSlip,
    required this.stepEightTimeStamp,
    required this.sosId,
    this.repairDetailsTwo,
    this.repairPriceTwo,
    this.tuPriceTwoTimeStamp,
    this.tuUserDealTwoTimeStamp,
    this.userDealTwo,
    required this.qrName,
    required this.qrType,
    required this.qrNumber,
  });

  final String getToken;
  final String? imgAfwork;
  final String? imgBfwork;
  final String imgIncident;
  final String location;
  final String problem;
  final String problemDetails;
  final String? qrCode;
  final String rate;
  final String repairDetails;
  final String repairPrice;
  final String review;
  final DateTime stepEightTimeStamp;
  final DateTime stepFiveTimeStamp;
  final DateTime stepFourTimeStamp;
  final DateTime stepOnetimeStamp;
  final DateTime stepSevenTimeStamp;
  final DateTime stepSixTimeStamp;
  final DateTime stepThreeTimeStamp;
  final DateTime stepTwoTimeStamp;
  final String tncName;
  final String? tncProfile;
  final String tncStatus;
  final String userName;
  final String userProfile;
  final String userSlip;
  final String userTel;
  final String sosId;
  final String? repairDetailsTwo;
  final String? repairPriceTwo;
  final DateTime? tuPriceTwoTimeStamp;
  final DateTime? tuUserDealTwoTimeStamp;
  final String? userDealTwo;
  final String qrName;
  final String qrType;
  final String qrNumber;

  @override
  State<StepEight> createState() => _StepEightState();
}

class _StepEightState extends State<StepEight> {
  late List<Timelines> timelines;

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
                    child: Image.network(
                      widget.tncProfile ??
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
                'สถานะ : ช่างถึงหน้างานเเล้ว',
                style: GoogleFonts.sarabun(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                  child: Text(
                    'รูปก่อนเริ่มงาน : ',
                    style: GoogleFonts.sarabun(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.imgBfwork.toString(),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
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
      Timelines(
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
      Timelines(
        widget.stepFiveTimeStamp,
        "เสร็จสิ้นงาน",
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                  child: Text(
                    'รูปหลังเสร็จงาน : ',
                    style: GoogleFonts.sarabun(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.imgAfwork.toString(),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
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
      Timelines(
        widget.stepSixTimeStamp,
        "QR Code สำหรับโอน",
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "คุณสามารถกดค้างที่รูป เพื่อดาวห์โหลด QR Code นี้",
              style: GoogleFonts.sarabun(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                child: InkWell(
                  onLongPress: () async {
                    await GallerySaver.saveImage(widget.qrCode!);
                    Fluttertoast.showToast(
                      msg: "โหลด QR Code เรียบร้อย",
                      fontSize: 18,
                      backgroundColor: mainGreen,
                      textColor: Colors.white,
                    );
                  },
                  child: Ink(
                    child: CachedNetworkImage(
                      imageUrl: widget.qrCode.toString(),
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "ชื่อบัญชี : ${widget.qrName}\nเลขบัญชี : ${widget.qrNumber}\nประเภทบัญชี : ${widget.qrType}",
                    style: GoogleFonts.sarabun(),
                  ),
                ),
              ),
            ),
          ],
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        widget.stepSevenTimeStamp,
        "โอนเงินค่าบริการ",
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ให้ดาวช่าง : ${widget.rate}\nรีวิว : ${widget.review}',
              style: GoogleFonts.sarabun(
                height: 1.5,
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                child: InteractiveViewer(
                  panEnabled: false,
                  minScale: 0.5,
                  maxScale: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.userSlip,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
        widget.stepEightTimeStamp,
        "ขอบคุณที่ใช้บริการ",
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เจ้าหน้าที่ตรวจการเงินและโอนเงินให้ช่างภายใน 24 ชั่วโมง ขอบคุณที่ใช้บริการกับเรา',
              style: GoogleFonts.sarabun(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imgs/thank.png',
                    height: 100,
                  ),
                  Image.asset(
                    'assets/imgs/thank_bubbles.png',
                    height: 70,
                  ),
                ],
              ),
            ),
          ],
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
    ].toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GroupedListView<Timelines, DateTime>(
        elements: timelines,
        reverse: true,
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 0),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
      ),
    );
  }
}
