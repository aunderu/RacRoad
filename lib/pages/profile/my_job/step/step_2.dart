import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/colors.dart';
import '../../../../../models/data/timeline_models.dart';
import '../../../../models/sos/sos_details_models.dart';

class TncStepTwo extends StatefulWidget {
  const TncStepTwo({
    super.key,
    required this.stepOneTimeStamp,
    required this.stepTwoTimeStamp,
    required this.getToken,
    required this.sosId,
    required this.userName,
    required this.userTel,
    required this.problem,
    required this.problemDetails,
    required this.location,
    required this.userProfile,
    required this.imgIncident,
    required this.tncName,
    required this.tncAvatar,
    required this.tncStatus,
    required this.latitude,
    required this.longitude,
    required this.imgBfwork,
    required this.imgAfwork,
  });

  final String getToken;
  final List<Img> imgAfwork;
  final List<Img> imgBfwork;
  final List<Img> imgIncident;
  final String latitude;
  final String location;
  final String longitude;
  final String problem;
  final String problemDetails;
  final String sosId;
  final DateTime stepOneTimeStamp;
  final DateTime stepTwoTimeStamp;
  final String tncAvatar;
  final String tncName;
  final String tncStatus;
  final String userName;
  final String userProfile;
  final String userTel;

  @override
  State<TncStepTwo> createState() => _TncStepTwoState();
}

class _TncStepTwoState extends State<TncStepTwo> {
  late List<Timelines> timelines;
  final imageUserController = PageController();
  final imageBfController = PageController();
  final imageAfController = PageController();

  @override
  void initState() {
    super.initState();

    getTimelines();
  }

  @override
  void dispose() {
    imageUserController.dispose();
    imageBfController.dispose();
    imageAfController.dispose();

    super.dispose();
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
              child: ElevatedButton.icon(
                onPressed: () {
                  _openMap(widget.latitude, widget.longitude);
                },
                icon: const Icon(Icons.pin_drop),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  minimumSize: const Size(200, 40),
                ),
                label: Text(
                  "ดูใน Google Map",
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      controller: imageUserController,
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
                    controller: imageUserController,
                    count: widget.imgIncident.length,
                    effect: const WormEffect(
                      spacing: 20,
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: mainGreen,
                      dotColor: Colors.black26,
                    ),
                    onDotClicked: (index) => imageUserController.animateToPage(
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
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        widget.stepTwoTimeStamp,
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
                    'รูปก่อนเริ่มงาน : ',
                    style: GoogleFonts.sarabun(),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: PageView.builder(
                          controller: imageBfController,
                          itemCount: widget.imgBfwork.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.imgBfwork[index].image,
                              height: 250,
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
                        controller: imageBfController,
                        count: widget.imgBfwork.length,
                        effect: const WormEffect(
                          spacing: 20,
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: mainGreen,
                          dotColor: Colors.black26,
                        ),
                        onDotClicked: (index) =>
                            imageBfController.animateToPage(
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
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: PageView.builder(
                          controller: imageAfController,
                          itemCount: widget.imgAfwork.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.imgAfwork[index].image,
                              height: 250,
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
                        controller: imageAfController,
                        count: widget.imgAfwork.length,
                        effect: const WormEffect(
                          spacing: 20,
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: mainGreen,
                          dotColor: Colors.black26,
                        ),
                        onDotClicked: (index) =>
                            imageAfController.animateToPage(
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
          ],
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
      Timelines(
        widget.stepTwoTimeStamp,
        "ขอบคุณที่บริการ",
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เจ้าหน้าที่ได้ส่ง QR Code สำหรับการโอนให้ลูกค้าเรียบร้อย\n\nหลังจากลูกค้าโอนมาเราจะตรวจสอบยอดการโอนและจะโอนให้คุณภายใน 24 ชั่วโมง',
              style: GoogleFonts.sarabun(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/imgs/mechanic_icon.png',
                    height: 100,
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
    ];
  }

  Future<void> _openMap(String latitude, String longitude) async {
    String googleURL =
        'https://www.google.co.th/maps/search/?api=1&query=$latitude,$longitude';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
