import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationsPage extends StatefulWidget {
  final String token;
  const NotificationsPage({
    super.key,
    required this.token,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  TextEditingController? searchController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (_) => EasyDebounce.debounce(
                          'textController',
                          const Duration(milliseconds: 2000),
                          () => setState(() {}),
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                  ],
                ),
              ),
              // Generated code for this ListView Widget...
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                child: ListView(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    listTile(widget.token, 'assets/imgs/oparator.png',
                        'ช่างได้ยืนยันรับงาน และกำลังไปแล้ว!'),
                    listTile(widget.token, 'assets/imgs/oparator.png',
                        'เราได้รับแจ้งปัญหาของคุณแล้ว!\nนี้คือรายละเอียดค่าบริการ'),
                  ],
                ),
              )
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
