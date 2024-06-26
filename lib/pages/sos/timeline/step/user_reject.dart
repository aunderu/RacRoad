import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/colors.dart';
import '../../../../../models/data/timeline_models.dart';
import '../../../../models/sos/sos_details_models.dart';

class UserReject extends StatefulWidget {
  const UserReject({
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
  final DateTime stepOnetimeStamp;
  final DateTime stepThreeTimeStamp;
  final DateTime stepTwoTimeStamp;
  final String userName;
  final String userProfile;
  final String userTel;

  @override
  State<UserReject> createState() => _UserRejectState();
}

class _UserRejectState extends State<UserReject> {
  late List<Timelines> timelines;
  final controller = PageController();

  @override
  void initState() {
    super.initState();

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
        widget.stepThreeTimeStamp,
        "ฉันปฏิเสธค่าบริการดังกล่าว",
        Text(
          "ฉันได้ปฏิเสธค่าบริการ จำนวน ${widget.repairPrice} บาท",
          style: GoogleFonts.sarabun(),
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
    ].toList();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
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
    // return Column(
    //   mainAxisSize: MainAxisSize.max,
    //   children: [
    //     const SizedBox(height: 30),
    //     //ผู้ยืนยันค่าบริการ
    //     Padding(
    //       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
    //       child: Row(
    //         mainAxisSize: MainAxisSize.max,
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.75,
    //             decoration: BoxDecoration(
    //               color: const Color.fromARGB(255, 182, 235, 255),
    //               borderRadius: BorderRadius.circular(8),
    //               boxShadow: const [
    //                 BoxShadow(
    //                   color: Color(0x3571DAFF),
    //                   spreadRadius: 3,
    //                   blurRadius: 2,
    //                   offset: Offset(3, 3), // changes position of shadow
    //                 ),
    //               ],
    //             ),
    //             child: Padding(
    //               padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.max,
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         DateFormat(
    //                                 'd MMMM พ.ศ.${widget.stepThreeTimeStamp.yearInBuddhistCalendar} เวลา KK:mm น.')
    //                             .format(widget.stepThreeTimeStamp),
    //                         style: GoogleFonts.sarabun(),
    //                       ),
    //                     ],
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     color: Color(0x392E2E2E),
    //                   ),
    //                   Column(
    //                     mainAxisSize: MainAxisSize.max,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsetsDirectional.fromSTEB(
    //                             0, 0, 20, 0),
    //                         child: Text(
    //                           'ฉันปฏิเสธค่าบริการดังกล่าว',
    //                           style: GoogleFonts.sarabun(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 18,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Padding(
    //                     padding:
    //                         const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.max,
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           width: 30,
    //                           height: 30,
    //                           clipBehavior: Clip.antiAlias,
    //                           decoration: const BoxDecoration(
    //                             shape: BoxShape.circle,
    //                             color: Colors.white,
    //                           ),
    //                           child: Image.network(
    //                             widget.userProfile,
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsetsDirectional.fromSTEB(
    //                               8, 0, 0, 0),
    //                           child: Text(
    //                             widget.userName,
    //                             style: GoogleFonts.sarabun(),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     //รายละเอียดค่าบริการ
    //     Padding(
    //       padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
    //       child: Row(
    //         mainAxisSize: MainAxisSize.max,
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.75,
    //             decoration: BoxDecoration(
    //               color: const Color.fromARGB(255, 185, 195, 255),
    //               borderRadius: BorderRadius.circular(8),
    //               boxShadow: const [
    //                 BoxShadow(
    //                   color: Color(0x352F44CA),
    //                   spreadRadius: 3,
    //                   blurRadius: 2,
    //                   offset: Offset(-3, 3), // changes position of shadow
    //                 ),
    //               ],
    //             ),
    //             child: Padding(
    //               padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.max,
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         DateFormat(
    //                                 'd MMMM พ.ศ.${widget.stepTwoTimeStamp.yearInBuddhistCalendar} เวลา KK:mm น.')
    //                             .format(widget.stepTwoTimeStamp),
    //                         style: GoogleFonts.sarabun(),
    //                       ),
    //                     ],
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     color: Color(0x392E2E2E),
    //                   ),
    //                   Column(
    //                     mainAxisSize: MainAxisSize.max,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsetsDirectional.fromSTEB(
    //                             0, 0, 20, 0),
    //                         child: Text(
    //                           'เสนอบริการค่าซ่อม',
    //                           style: GoogleFonts.sarabun(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 18,
    //                           ),
    //                         ),
    //                       ),
    //                       const SizedBox(height: 5),
    //                       Card(
    //                         color: Colors.white,
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(10.0),
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Text(
    //                                 'รายละเอียดเพิ่มเติม :',
    //                                 style: GoogleFonts.sarabun(),
    //                               ),
    //                               const SizedBox(height: 5),
    //                               Text(
    //                                 widget.repairDetails,
    //                                 style: GoogleFonts.sarabun(),
    //                               ),
    //                               const SizedBox(height: 15),
    //                               const Divider(
    //                                 thickness: 1,
    //                               ),
    //                               Row(
    //                                 children: [
    //                                   Expanded(
    //                                     child: Text(
    //                                       'รวมทั้งหมด :',
    //                                       style: GoogleFonts.sarabun(),
    //                                     ),
    //                                   ),
    //                                   Text(
    //                                     "${widget.repairPrice} บาท",
    //                                     style: GoogleFonts.sarabun(),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 15),
    //                   Padding(
    //                     padding:
    //                         const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.max,
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           width: 30,
    //                           height: 30,
    //                           clipBehavior: Clip.antiAlias,
    //                           decoration: const BoxDecoration(
    //                             shape: BoxShape.circle,
    //                           ),
    //                           child: Container(
    //                             decoration:
    //                                 const BoxDecoration(color: Colors.white),
    //                             child: Image.asset(
    //                               'assets/imgs/oparator.png',
    //                             ),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsetsDirectional.fromSTEB(
    //                               8, 0, 0, 0),
    //                           child: Text(
    //                             'เจ้าหน้าที่ Racroad',
    //                             style: GoogleFonts.sarabun(),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),

    //     //ผู้ใช้แจ้งเหตุการณ์
    //     Padding(
    //       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
    //       child: Row(
    //         mainAxisSize: MainAxisSize.max,
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.75,
    //             decoration: BoxDecoration(
    //               color: const Color.fromARGB(255, 182, 235, 255),
    //               borderRadius: BorderRadius.circular(8),
    //               boxShadow: const [
    //                 BoxShadow(
    //                   color: Color(0x3571DAFF),
    //                   spreadRadius: 3,
    //                   blurRadius: 2,
    //                   offset: Offset(3, 3), // changes position of shadow
    //                 ),
    //               ],
    //             ),
    //             child: Padding(
    //               padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.max,
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         DateFormat(
    //                                 'd MMMM พ.ศ.${widget.stepOnetimeStamp.yearInBuddhistCalendar} เวลา KK:mm น.')
    //                             .format(widget.stepOnetimeStamp),
    //                         style: GoogleFonts.sarabun(),
    //                       ),
    //                     ],
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     color: Color(0x392E2E2E),
    //                   ),
    //                   Column(
    //                     mainAxisSize: MainAxisSize.max,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsetsDirectional.fromSTEB(
    //                             0, 0, 20, 0),
    //                         child: Text(
    //                           'เเจ้งเหตุการณ์',
    //                           style: GoogleFonts.sarabun(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 18,
    //                           ),
    //                         ),
    //                       ),
    //                       const SizedBox(height: 10),
    //                       Text(
    //                         'ปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}',
    //                         style: GoogleFonts.sarabun(),
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Align(
    //                     alignment: Alignment.topCenter,
    //                     child: Padding(
    //                       padding:
    //                           const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
    //                       child: ClipRRect(
    //                         borderRadius: BorderRadius.circular(20),
    //                         child: CachedNetworkImage(
    //                           imageUrl: widget.imgIncident,
    //                           height: 200,
    //                           errorWidget: (context, url, error) =>
    //                               const Icon(Icons.error),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding:
    //                         const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.max,
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           width: 30,
    //                           height: 30,
    //                           clipBehavior: Clip.antiAlias,
    //                           decoration: const BoxDecoration(
    //                             shape: BoxShape.circle,
    //                             color: Colors.white,
    //                           ),
    //                           child: Image.network(
    //                             widget.userProfile,
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsetsDirectional.fromSTEB(
    //                               8, 0, 0, 0),
    //                           child: Text(
    //                             widget.userName,
    //                             style: GoogleFonts.sarabun(),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
