import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/colors.dart';
import 'step/step_page.dart';

class TncSosHistoryWidget extends StatelessWidget {
  const TncSosHistoryWidget({
    super.key,
    required this.userAvatar,
    required this.userProblem,
    required this.sosStatus,
    required this.timeStamp,
    required this.getToken,
    required this.sosId,
  });

  final String getToken;
  final String sosId;
  final String sosStatus;
  final DateTime timeStamp;
  final String userAvatar;
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
              Get.to(() => StepPage(getToken: getToken, sosId: sosId));
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
                            imageUrl: userAvatar,
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                          Text(
                            (() {
                              switch (sosStatus) {
                                case 'step4':
                                  return 'กำลังปฏิบัติงาน';
                                case 'step5':
                                  return 'ปฏิบัติงานสำเร็จ';
                                case 'step6':
                                  return 'ปฏิบัติงานสำเร็จ';
                                case 'step7':
                                  return 'ปฏิบัติงานสำเร็จ';
                                case 'step8':
                                  return 'ปฏิบัติงานสำเร็จ';
                                case 'success':
                                  return 'เสร็จสิ้น';
                                case 'user_reject_deal':
                                  return 'ผู้ใช้ปฏิเสธข้อเสนอ';
                                case 'user_reject_deal2':
                                  return 'ผู้ใช้ปฏิเสธข้อเสนอ';
                                default:
                              }
                              return 'เหตุฉุกเฉิน';
                            }()),
                            style: GoogleFonts.sarabun(
                              color: darkGray,
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
