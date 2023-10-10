import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rac_road/utils/colors.dart';

import 'package:rac_road/models/data/menu_items.dart';
import 'package:rac_road/models/menu_item.dart';

import '../../screens.dart';
import '../club/club_details.dart';

class AllMyClub extends StatefulWidget {
  const AllMyClub({
    super.key,
    required this.clubName,
    required this.clubProfile,
    required this.token,
    required this.clubId,
    required this.clubStatus, required this.userName,
  });

  final String clubId;
  final String clubName;
  final String clubProfile;
  final String clubStatus;
  final String token;
  final String userName;

  @override
  State<AllMyClub> createState() => _AllMyClubState();
}

class _AllMyClubState extends State<AllMyClub> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController clubNameController = TextEditingController();
  TextEditingController clubDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    clubNameController = TextEditingController();
    clubDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    clubNameController.dispose();
    clubDescriptionController.dispose();
    super.dispose();
  }

  void deleteClub(String clubId) async {
    var url = Uri.parse('https://api.racroad.com/api/club/destroy/$clubId');
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

  void showFormDialog(String clubName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            title: Text(
              'แก้ไขข้อมูลคลับ\n$clubName',
              textAlign: TextAlign.center,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            content: Stack(
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: clubNameController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณากรอกชื่อคลับด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกชื่อคลับของคุณ"),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(
                              Icons.looks_one_outlined,
                              color: mainGreen,
                            ),
                            filled: true,
                            fillColor: Color(0xffffffff),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainGreen,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: whiteGreen, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffEF4444), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainGreen, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: clubDescriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณาคำอธิบายคลับด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกคำอธิบายคลับของคุณ"),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(
                              Icons.looks_two_outlined,
                              color: mainGreen,
                            ),
                            filled: true,
                            fillColor: Color(0xffffffff),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainGreen,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: whiteGreen, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffEF4444), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainGreen, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // next
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          mainGreen),
                                      strokeWidth: 8,
                                    ),
                                  );
                                },
                              );

                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainGreen,
                            minimumSize: const Size(
                              300,
                              40,
                            ),
                          ),
                          child: Text(
                            'ยืนยัน',
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onSelected(BuildContext context, CustomMenuItem item) {
    switch (item) {
      case ClubMenuItems.itemEdit:
        showFormDialog(widget.clubName);
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
                  getToken: widget.token,
                  userName: widget.userName,
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
