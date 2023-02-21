import 'dart:io';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../../../../colors.dart';
import '../../../../../models/data/timeline_models.dart';

class TncUserReject extends StatefulWidget {
  const TncUserReject({
    super.key,
    required this.getToken,
    required this.stepOneTimeStamp,
    required this.userProfile,
    required this.userName,
    required this.userTel,
    required this.problem,
    required this.problemDetails,
    required this.location,
    required this.imgIncident,
    this.tncNote,
    required this.imgBfwork,
    required this.tuUserDealTwo,
    required this.repairPriceTwo,
    required this.userReason,
  });

  final String getToken;
  final DateTime stepOneTimeStamp;
  final DateTime tuUserDealTwo;
  final String userProfile;
  final String userName;
  final String userTel;
  final String problem;
  final String problemDetails;
  final String location;
  final String imgIncident;
  final String? tncNote;
  final String imgBfwork;
  final String repairPriceTwo;
  final String userReason;

  @override
  State<TncUserReject> createState() => _TncUserRejectState();
}

class _TncUserRejectState extends State<TncUserReject> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? imgFile;
  late List<Timelines> timelines;
  TextEditingController? tncNoteController;

  @override
  void initState() {
    super.initState();
    tncNoteController = TextEditingController();

    getTimelines();
  }

  void getTimelines() {
    timelines = [
      Timelines(
        widget.stepOneTimeStamp,
        "แจ้งเหตุการณ์",
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ชื่อผู้ใช้ : ${widget.userName}\nเบอร์โทร : ${widget.userTel}\n\nปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}',
              style: GoogleFonts.sarabun(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: widget.imgIncident,
                    height: 200,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
        DateTime.now(),
        "รับงาน",
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.tncNote != null
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 10, 20, 7),
                          child: Text(
                            'ข้อเสนอเพิ่มเติมของคุณ : ${widget.tncNote}',
                            style: GoogleFonts.sarabun(),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 7),
                    child: Text(
                      'รูปก่อนเริ่มงาน : ',
                      style: GoogleFonts.sarabun(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: widget.imgBfwork,
                        width: double.infinity,
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
        widget.userProfile,
        widget.userName,
        "1",
      ),
      Timelines(
        widget.tuUserDealTwo,
        "ผู้ใช้งานได้ปฏิเสธค่าบริการดังกล่าว",
        Text(
          "ผู้ใช้งานได้ปฏิเสธค่าบริการ จำนวน ${widget.repairPriceTwo} บาท\nเหตุผล : ${widget.userReason}",
          style: GoogleFonts.sarabun(),
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
    ].toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GroupedListView<Timelines, DateTime>(
            elements: timelines,
            reverse: true,
            useStickyGroupSeparators: true,
            floatingHeader: true,
            shrinkWrap: true,
            order: GroupedListOrder.DESC,
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
                              'd MMMM ${timelines.timestamp.yearInBuddhistCalendar} เวลา hh:mm')
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 0, 0, 0),
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
        ),
      ),
    );
  }
}
