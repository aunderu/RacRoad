import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/models/data/timeline_models.dart';

class StepOne extends StatefulWidget {
  final String getToken;
  final DateTime stepOnetimeStamp;
  final String userName;
  final String userTel;
  final String problem;
  final String problemDetails;
  final String location;
  final String userProfile;
  final String imgIncident;
  const StepOne({
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
  });

  @override
  State<StepOne> createState() => _StepOneState();
}

//ผู้ใช้แจ้งเหตุการณ์
class _StepOneState extends State<StepOne> {
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
    ].toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.78,
      child: GroupedListView<Timelines, DateTime>(
        elements: timelines,
        reverse: true,
        order: GroupedListOrder.DESC,
        groupBy: (message) => DateTime(
          widget.stepOnetimeStamp.day,
          widget.stepOnetimeStamp.hour,
        ),
        groupHeaderBuilder: (Timelines timelines) => SizedBox(
          height: 40,
          child: Center(
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
                color: const Color.fromARGB(255, 182, 235, 255),
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
                                  0, 4, 0, 0),
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
                                    child: CachedNetworkImage(
                                      imageUrl: timelines.profile,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              "assets/imgs/profile.png"),
                                    ),
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
