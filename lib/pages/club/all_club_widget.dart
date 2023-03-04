import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';
import 'club_details.dart';

class AllClubWidget extends StatelessWidget {
  const AllClubWidget({
    super.key,
    required this.clubName,
    required this.clubZone,
    required this.clubAdmin,
    this.clubProfile,
    required this.clubStatus,
    required this.getToken,
    required this.clubId,
  });

  final String clubAdmin;
  final String clubId;
  final String clubName;
  final String? clubProfile;
  final String clubStatus;
  final String clubZone;
  final String getToken;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (clubStatus == "รอการอนุมัติ") {
          Fluttertoast.showToast(msg: "คลับกำลังรอการอนุมัติ");
        } else if (clubStatus == "ไม่อนุมัติ") {
          Fluttertoast.showToast(msg: "คลับไม่ได้รับการอนุมัติ");
        } else {
          Get.to(
            () => ClubDetailsPage(
              clubId: clubId,
              getToken: getToken,
            ),
          );
        }
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFEBEBEB),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: clubProfile != null
                    ? CachedNetworkImage(
                        imageUrl: clubProfile!,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) => Container(
                          width: 100,
                          height: 100,
                          color: const Color(0xFFEBEBEB),
                        ),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: const Color(0xFFEBEBEB),
                        child: const Icon(
                          Icons.group,
                          size: 50,
                          color: darkGray,
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clubName,
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        clubAdmin,
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        clubZone,
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Text(
                    'Unfollow',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
