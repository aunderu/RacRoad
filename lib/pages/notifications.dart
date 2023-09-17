
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'club/search_club.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
    required this.token, required this.userName,
  });

  final String token;
  final String userName;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(
                          () => SearchClubsPage(
                            getToken: widget.token,
                            userName: widget.userName,
                          ),
                          transition: Transition.noTransition,
                        ),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Search',
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF757575),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.search,
                                  color: Color(0xFF757575),
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
              //   child: ListView(
              //     padding: EdgeInsets.zero,
              //     primary: false,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.vertical,
              //     children: [
              //       listTile(widget.token, 'assets/imgs/oparator.png',
              //           'ช่างได้ยืนยันรับงาน และกำลังไปแล้ว!'),
              //       listTile(widget.token, 'assets/imgs/oparator.png',
              //           'เราได้รับแจ้งปัญหาของคุณแล้ว!\nนี้คือรายละเอียดค่าบริการ'),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget listTile(String token, String imgUrl, String title) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
    child: GestureDetector(
      onTap: () {
        // Get.to(() => Pricing(getToken: token));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imgUrl),
          radius: 25,
        ),
        title: Text(
          title,
          style: GoogleFonts.sarabun(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
        ),
        subtitle: Text(
          '1 นาทีที่ผ่านมา',
          style: GoogleFonts.sarabun(
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.keyboard_control,
          color: Color(0xFF303030),
          size: 20,
        ),
        tileColor: const Color(0xFFF5F5F5),
        dense: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
