import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:rac_road/models/data/menu_items.dart';
import 'package:rac_road/models/data/menu_item.dart';

import '../../screens.dart';
import '../../utils/api_url.dart';
import '../club/club_details.dart';
import 'edit_my_club.dart';

class AllMyClub extends StatefulWidget {
  const AllMyClub({
    super.key,
    required this.clubName,
    required this.clubProfile,
    required this.token,
    required this.clubId,
    required this.clubStatus,
    required this.userName,
    required this.clubZone, required this.clubDescription,
  });

  final String clubId;
  final String clubName;
  final String clubProfile;
  final String clubZone;
  final String clubStatus;
  final String token;
  final String userName;
  final String clubDescription;

  @override
  State<AllMyClub> createState() => _AllMyClubState();
}

class _AllMyClubState extends State<AllMyClub> {
  void deleteClub(String clubId) async {
    var url = Uri.parse('$currentApi/club/destroy/$clubId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreensPage(
            pageIndex: 4,
            current: 1,
          ),
        ),
      );

      Fluttertoast.showToast(
        msg: "คุณได้ลบคลับนี้แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  PopupMenuItem<CustomMenuItem> buildItem(CustomMenuItem item) =>
      PopupMenuItem<CustomMenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              item.text,
              style: GoogleFonts.sarabun(),
            ),
          ],
        ),
      );

  void onSelected(BuildContext context, CustomMenuItem item) {
    switch (item) {
      case ClubMenuItems.itemEdit:
        Get.to(
          () => EditMyClubPage(
            clubName: widget.clubName,
            clubProfile: widget.clubProfile,
            clubId: widget.clubId,
            clubZone: widget.clubZone,
            description: widget.clubDescription,
            userId: widget.token,
          ),
          transition: Transition.rightToLeft,
        );
        break;
      case ClubMenuItems.itemDelete:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("ลบคลับ ${widget.clubName}"),
            content: const Text(
                'คลับนี้จะหายไปตลอดการและไม่สามารถย้อนกลับได้ คุณแน่ใช่แล้วใช่ไหม'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // missionUpdate(dataNewMission[index].id, "ปฏิเสธ");
                  deleteClub(widget.clubId);
                  // Get.to(() => ScreensPage(
                  //       getToken: widget.token,
                  //       pageIndex: 4,
                  //       isSOS: false,
                  //       isConfirm: false,
                  //     ));
                },
                child: const Text('ลบคลับ'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก'),
              ),
            ],
            elevation: 24,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        child: InkWell(
          onTap: () {
            if (widget.clubStatus == "รอการอนุมัติ") {
              Fluttertoast.showToast(msg: "คลับกำลังรอการอนุมัติ");
            } else if (widget.clubStatus == "ไม่อนุมัติ") {
              Fluttertoast.showToast(msg: "คลับไม่ได้รับการอนุมัติ");
            } else {
              Get.to(
                () => ClubDetailsPage(
                  clubId: widget.clubId,
                  userName: widget.userName,
                  userId: widget.token,
                ),
              );
            }
          },
          child: Ink(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFEBEBEB),
            ),
            child: Stack(
              children: [
                // book mark
                // const Align(
                //   alignment: AlignmentDirectional(-1, -1),
                //   child: Padding(
                //     padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                //     child: Icon(
                //       Icons.star_border_rounded,
                //       color: darkGray,
                //       size: 24,
                //     ),
                //   ),
                // ),
                Align(
                  alignment: const AlignmentDirectional(1, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                    child: PopupMenuButton<CustomMenuItem>(
                      onSelected: (item) => onSelected(context, item),
                      itemBuilder: (context) => [
                        ...ClubMenuItems.itemsFirst.map(buildItem).toList(),
                        const PopupMenuDivider(),
                        ...ClubMenuItems.itemsSecond.map(buildItem).toList(),
                      ],
                      child: const Icon(
                        Icons.keyboard_control,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Text(
                      widget.clubName,
                      style: GoogleFonts.sarabun(),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -0.05),
                  child: Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.clubProfile,
                      fit: BoxFit.cover,
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
