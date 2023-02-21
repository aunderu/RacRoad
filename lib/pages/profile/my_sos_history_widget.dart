import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../colors.dart';
import 'my_history_sos_details.dart';

class MySosHistoryWidget extends StatelessWidget {
  const MySosHistoryWidget({
    super.key,
    required this.imgAccident,
    required this.userName,
    required this.userProblem,
    required this.sosStatus,
    required this.timeStamp,
    required this.getToken,
    required this.sosId,
  });

  final String getToken;
  final String imgAccident;
  final String sosId;
  final String sosStatus;
  final DateTime timeStamp;
  final String userName;
  final String userProblem;

  @override
  Widget build(BuildContext context) {
    var thTimeStamp = timeStamp.yearInBuddhistCalendar;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          child: InkWell(
            onTap: () {
              Get.to(
                () => MyHistorySosDetails(
                  getToken: getToken,
                  sosId: sosId,
                ),
              );
            },
            child: Ink(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: secondaryBGColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: lightGrey,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: primaryBGColor,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: imgAccident,
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: mainGreen,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/icons/404.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProblem,
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Flexible(
                            child: Text(
                              (() {
                                switch (sosStatus) {
                                  case "step1":
                                    return "แจ้งเหตุการณ์";
                                  case "step2":
                                    return "การตอบรับข้อเสนอ";
                                  case "step3":
                                    return "เจ้าหน้าที่เลือกช่าง";
                                  case "step4":
                                    return "ช่างปฏิบัติหน้าที่";
                                  case "step5":
                                    return "ช่างปฏิบัติงานสำเร็จ";
                                  case "step6":
                                    return "ชำระเงินและรีวิว";
                                  case "step7":
                                    return "รอตรวจสอบการเงิน";
                                  case "step8":
                                    return "สำเร็จ";
                                  case "success":
                                    return "สำเร็จ";
                                  case "user_reject_deal":
                                    return "ปฏิเสธข้อเสนอ";
                                  case "user_reject_deal2":
                                    return "ปฏิเสธข้อเสนอ";
                                }
                                return "";
                              })(),
                              style: GoogleFonts.sarabun(
                                color: darkGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: Text(
                      DateFormat('d MMMM พ.ศ.$thTimeStamp').format(timeStamp),
                      style: GoogleFonts.sarabun(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
