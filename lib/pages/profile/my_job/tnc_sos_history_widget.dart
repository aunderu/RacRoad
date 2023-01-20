import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../colors.dart';
import 'step/step_page.dart';

class TncSosHistoryWidget extends StatelessWidget {
  final String getToken;
  final String sosId;
  final String userAvatar;
  final String userProblem;
  final String sosStatus;
  final DateTime timeStamp;
  const TncSosHistoryWidget({
    super.key,
    required this.userAvatar,
    required this.userProblem,
    required this.sosStatus,
    required this.timeStamp,
    required this.getToken,
    required this.sosId,
  });

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
                            sosStatus,
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
