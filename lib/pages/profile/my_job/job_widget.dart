import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../utils/colors.dart';
import '../../../../models/data/menu_items.dart';
import '../../../../models/menu_item.dart';
import 'job_history.dart';

class JobWidget extends StatefulWidget {
  const JobWidget({
    super.key,
    required this.getToken,
    required this.jobId,
    required this.clubProfile,
    required this.tncId,
    required this.tncName,
    required this.jobZone,
    required this.status,
  });

  final String clubProfile;
  final String getToken;
  final String jobId;
  final String jobZone;
  final String status;
  final String tncId;
  final String tncName;

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  void deleteJob(String jobId) async {
    var url =
        Uri.parse('https://api.racroad.com/api/technician/destroy/$jobId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      Get.toNamed('/profile-myjob');

      Fluttertoast.showToast(
        msg: "คุณลบเรียบร้อย",
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
      // case JobMenuItems.itemEdit:
      //   Get.to(() => const JobSettings());
      //   break;
      case JobMenuItems.itemDelete:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("ลบหรือไม่?"),
            content: const Text(
                'ข้อมูลนี้จะหายไปตลอดการและไม่สามารถย้อนกลับได้ คุณแน่ใช่แล้วใช่ไหม'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // missionUpdate(dataNewMission[index].id, "ปฏิเสธ");
                  deleteJob(widget.jobId);
                  // Get.to(() => ScreensPage(
                  //       getToken: widget.token,
                  //       pageIndex: 4,
                  //       isSOS: false,
                  //       isConfirm: false,
                  //     ));
                },
                child: const Text('ลบ'),
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
      borderRadius: BorderRadius.circular(30),
      child: Material(
        child: InkWell(
          onTap: () {
            if (widget.status != "รอการอนุมัติ") {
              Get.to(
                () => MyJobHistory(
                  getToken: widget.getToken,
                  tncId: widget.tncId,
                ),
                transition: Transition.rightToLeftWithFade,
              );
            } else {
              Fluttertoast.showToast(msg: "กำลังรอการอนุมัติ");
            }
          },
          child: Ink(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.status == "รอการอนุมัติ" ? lightGrey : whiteGrey,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(1, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                    child: PopupMenuButton<CustomMenuItem>(
                      onSelected: (item) => onSelected(context, item),
                      itemBuilder: (context) => [
                        ...JobMenuItems.itemsFirst.map(buildItem).toList(),
                        // const PopupMenuDivider(),
                        // ...JobMenuItems.itemsSecond.map(buildItem).toList(),
                      ],
                      child: const Icon(
                        Icons.keyboard_control,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          widget.clubProfile,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tncName,
                                style: GoogleFonts.kanit(
                                  fontSize: 25,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Zone : ',
                                    style: GoogleFonts.kanit(),
                                  ),
                                  Text(
                                    widget.jobZone,
                                    style: GoogleFonts.kanit(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Status : ',
                                    style: GoogleFonts.kanit(),
                                  ),
                                  Text(
                                    widget.status,
                                    style: GoogleFonts.kanit(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
