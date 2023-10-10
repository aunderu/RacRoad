import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../utils/colors.dart';
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
    required this.adminName,
    required this.userName,
    this.memcId,
  });

  final String clubAdmin;
  final String clubId;
  final String clubName;
  final String? clubProfile;
  final String clubStatus;
  final String clubZone;
  final String getToken;
  final String adminName;
  final String userName;
  final String? memcId;

  @override
  Widget build(BuildContext context) {
    Future<bool> userJoinClub() async {
      final response = await http.post(
        Uri.parse("https://api.racroad.com/api/request/join/club"),
        body: {
          'user_id': getToken,
          'club_id': clubId,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    }

    Future<bool> userLeaveClub(String clubId) async {
      final response = await http.get(
        Uri.parse("https://api.racroad.com/api/leave/club/$clubId"),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
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
                userName: userName,
                memcId: memcId,
              ),
              transition: Transition.rightToLeftWithFade,
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
                adminName == userName
                    ? const SizedBox.shrink()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              clubStatus == 'Notjoin'
                                  // ? userJoinClub()
                                  //     .then((value) => Get.offAllNamed('/club'))
                                  ? Get.defaultDialog(
                                      title: 'ติดตามคลับ\n$clubName',
                                      titleStyle: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      titlePadding:
                                          const EdgeInsets.only(top: 20),
                                      middleText:
                                          'เมื่อคุณขอเข้าร่วมคลับ คุณอาจต้องรอการตอบรับคำขอเข้าร่วมของคุณ',
                                      confirm: ElevatedButton(
                                        onPressed: () {
                                          userJoinClub();
                                          Get.offAllNamed('/club');
                                          Fluttertoast.showToast(
                                            msg:
                                                "คุณกดขอเข้าคลับแล้ว กรุณารอการตอบรับเข้าคลับ",
                                            backgroundColor: lightGreen,
                                            textColor: Colors.black,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainGreen,
                                          minimumSize: const Size(100, 40),
                                        ),
                                        child: Text(
                                          "เข้าคลับ",
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      cancel: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: whiteGrey,
                                          foregroundColor: darkGray,
                                          minimumSize: const Size(100, 40),
                                        ),
                                        child: Text(
                                          "ยกเลิก",
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Get.defaultDialog(
                                      title: 'ออกจากคลับ\n$clubName',
                                      titleStyle: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      titlePadding: const EdgeInsets.only(
                                        top: 20,
                                        left: 10,
                                        right: 10,
                                      ),
                                      middleText: '',
                                      confirm: ElevatedButton(
                                        onPressed: () {
                                          userLeaveClub(memcId!).then((value) {
                                            Get.offAllNamed('/club');
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          minimumSize: const Size(100, 40),
                                        ),
                                        child: Text(
                                          "ออกจากคลับ",
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      cancel: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: whiteGrey,
                                          foregroundColor: darkGray,
                                          minimumSize: const Size(100, 40),
                                        ),
                                        child: Text(
                                          "ยกเลิก",
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                            },
                            child: Ink(
                              width: 100,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Text(
                                  clubStatus == 'Notjoin' ? 'Join' : 'Leave',
                                  style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
