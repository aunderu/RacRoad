import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rac_road/home/pages/profile/my_job/step/step_page.dart';

import '../../../../colors.dart';

class TncSosHistoryWidget extends StatelessWidget {
  final String getToken;
  final String sosId;
  final String userAvatar;
  final String userName;
  final String sosStatus;
  final DateTime timeStamp;
  const TncSosHistoryWidget({
    super.key,
    required this.userAvatar,
    required this.userName,
    required this.sosStatus,
    required this.timeStamp,
    required this.getToken,
    required this.sosId,
  });

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
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
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.sarabun(),
                          ),
                          Text(
                            sosStatus,
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: Text(
                      DateFormat('yMMMMd').format(timeStamp),
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
