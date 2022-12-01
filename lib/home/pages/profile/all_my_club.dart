import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/club/club_details.dart';
import 'package:rac_road/home/pages/club/club_settings.dart';
import 'package:rac_road/home/screens.dart';
import 'package:rac_road/models/club_details.dart';
import 'package:rac_road/models/data/menu_items.dart';
import 'package:rac_road/models/menu_item.dart';

class AllMyClub extends StatefulWidget {
  final String token;
  final String clubId;
  final String clubName;
  final String clubStatus;

  const AllMyClub({
    super.key,
    required this.clubName,
    required this.token,
    required this.clubId,
    required this.clubStatus,
  });

  @override
  State<AllMyClub> createState() => _AllMyClubState();
}

class _AllMyClubState extends State<AllMyClub> {
  void deleteClub(String clubId) async {
    var url = Uri.parse('https://api.racroad.com/api/club/destroy/$clubId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreensPage(
            getToken: widget.token,
            pageIndex: 4,
            isSOS: false,
            isConfirm: false,
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (widget.clubStatus != "รอการอนุมัติ") {
            Get.to(
              () => ClubDetailsPage(
                clubId: widget.clubId,
                getToken: widget.token,
              ),
            );
          } else {
            Fluttertoast.showToast(msg: "คลับกำลังรอการอนุมัติ");
          }
        },
        child: Ink(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              const Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                  child: Icon(
                    Icons.star_border_rounded,
                    color: darkGray,
                    size: 24,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                  child: PopupMenuButton<CustomMenuItem>(
                    onSelected: (item) => onSelected(context, item),
                    itemBuilder: (context) => [
                      ...MenuItems.itemsFirst.map(buildItem).toList(),
                      const PopupMenuDivider(),
                      ...MenuItems.itemsSecond.map(buildItem).toList(),
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
                  // child: Image.network(
                  //   '',
                  // ),
                  child: Container(
                    color: Colors.white,
                    child: const Icon(
                      Icons.group,
                      size: 50,
                      color: darkGray,
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
      case MenuItems.itemEdit:
        Get.to(() => const ClubSettings());
        break;
      case MenuItems.itemDelete:
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
}
