import 'dart:convert';
import 'dart:io';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import '../../../../../colors.dart';
import '../../../../../models/data/timeline_models.dart';

class TncStepOne extends StatefulWidget {
  const TncStepOne({
    super.key,
    required this.stepOneTimeStamp,
    required this.getToken,
    required this.sosId,
    required this.userName,
    required this.userTel,
    required this.problem,
    required this.problemDetails,
    required this.location,
    required this.userProfile,
    required this.imgIncident,
    required this.tncName,
    required this.tncAvatar,
    required this.tncStatus,
    required this.latitude,
    required this.longitude,
    required this.imgBfwork,
  });

  final String getToken;
  final String? imgBfwork;
  final String imgIncident;
  final String latitude;
  final String location;
  final String longitude;
  final String problem;
  final String problemDetails;
  final String sosId;
  final DateTime stepOneTimeStamp;
  final String tncAvatar;
  final String tncName;
  final String tncStatus;
  final String userName;
  final String userProfile;
  final String userTel;

  @override
  State<TncStepOne> createState() => _TncStepOneState();
}

class _TncStepOneState extends State<TncStepOne> {
  File? imgFile;
  late List<Timelines> timelines;

  @override
  void initState() {
    super.initState();

    getTimelines();
  }

  void getTimelines() {
    timelines = [
      Timelines(
        widget.stepOneTimeStamp,
        "แจ้งเหตุการณ์",
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ชื่อผู้ใช้ : ${widget.userName}\nเบอร์โทร : ${widget.userTel}\n\nปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}',
              style: GoogleFonts.sarabun(),
            ),
            // const SizedBox(height: 10),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       _openMap(widget.latitude, widget.longitude);
            //     },
            //     icon: const Icon(Icons.pin_drop),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: mainGreen,
            //       minimumSize: const Size(200, 40),
            //     ),
            //     label: Text(
            //       "ดูใน Google Map",
            //       style: GoogleFonts.sarabun(
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: widget.imgIncident,
                    height: 200,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ],
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        DateTime.now(),
        "รับงาน",
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.tncStatus == "รอช่างตอบรับ"
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        mainGreen),
                                    strokeWidth: 8,
                                  ),
                                );
                                tncSendStatus(
                                    widget.sosId, "กำลังออกปฏิบัติงาน");
                                Get.offNamed('/profile-myjob');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                minimumSize: const Size(200, 40),
                              ),
                              child: Text(
                                "ฉันพร้อมและกำลังไป",
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : widget.tncStatus == "กำลังออกปฏิบัติงาน"
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 20, 7),
                              child: Text(
                                'รูปก่อนเริ่มงาน : ',
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ),
                          imgFile == null
                              ? Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                    child: Material(
                                      child: InkWell(
                                        onTap: () async {
                                          PermissionStatus cameraStatus =
                                              await Permission.camera.request();
                                          if (cameraStatus ==
                                              PermissionStatus.granted) {
                                            getFromCamera();
                                          }
                                          if (cameraStatus ==
                                              PermissionStatus.denied) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "This permission is recommended");
                                          }
                                          if (cameraStatus ==
                                              PermissionStatus
                                                  .permanentlyDenied) {
                                            openAppSettings();
                                          }
                                        },
                                        child: Ink(
                                          width: double.infinity,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEFEFEF),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Color(0xFF9D9D9D),
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Center(
                                    child: InkWell(
                                      onTap: getFromCamera,
                                      child: Image.file(
                                        imgFile!,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (imgFile != null) {
                                      tncSendBfImg(
                                        widget.sosId,
                                        imgFile!.path,
                                      );
                                      Get.offNamed('/profile-myjob');
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: 'คุณยังไม่ได้ถ่ายรูป',
                                        backgroundColor: Colors.yellow[100],
                                        textColor: Colors.black,
                                        fontSize: 15,
                                        gravity: ToastGravity.SNACKBAR,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainGreen,
                                    minimumSize: const Size(200, 40),
                                  ),
                                  child: Text(
                                    "ส่งรูปก่อนเริ่มงาน",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : widget.tncStatus == "ช่างถึงหน้างานเเล้ว"
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 20, 7),
                                  child: Text(
                                    'รูปก่อนเริ่มงาน : ',
                                    style: GoogleFonts.sarabun(),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.imgBfwork!,
                                      width: double.infinity,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 20, 7),
                                  child: Text(
                                    'รูปหลังเสร็จงาน : ',
                                    style: GoogleFonts.sarabun(),
                                  ),
                                ),
                              ),
                              imgFile == null
                                  ? Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 0),
                                        child: Material(
                                          child: InkWell(
                                            onTap: () async {
                                              PermissionStatus cameraStatus =
                                                  await Permission.camera
                                                      .request();
                                              if (cameraStatus ==
                                                  PermissionStatus.granted) {
                                                getFromCamera();
                                              }
                                              if (cameraStatus ==
                                                  PermissionStatus.denied) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "This permission is recommended");
                                              }
                                              if (cameraStatus ==
                                                  PermissionStatus
                                                      .permanentlyDenied) {
                                                openAppSettings();
                                              }
                                            },
                                            child: Ink(
                                              width: double.infinity,
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFEFEFEF),
                                              ),
                                              child: const Icon(
                                                Icons.camera_alt_outlined,
                                                color: Color(0xFF9D9D9D),
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Center(
                                        child: InkWell(
                                          onTap: getFromCamera,
                                          child: Image.file(
                                            imgFile!,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (imgFile != null) {
                                          tncSendAfImg(
                                            widget.sosId,
                                            imgFile!.path,
                                          );
                                          Get.offNamed('/profile-myjob');
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: 'คุณยังไม่ได้ถ่ายรูป',
                                            backgroundColor: Colors.yellow[100],
                                            textColor: Colors.black,
                                            fontSize: 15,
                                            gravity: ToastGravity.SNACKBAR,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: mainGreen,
                                        minimumSize: const Size(200, 40),
                                      ),
                                      child: Text(
                                        "ส่งรูปหลังเสร็จงาน",
                                        style: GoogleFonts.sarabun(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
          ],
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
    ].toList();
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imgFile = File(pickedFile.path);
        getTimelines();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'คุณยังไม่ได้เลือกรูป',
        backgroundColor: Colors.yellow[100],
        textColor: Colors.black,
        fontSize: 15,
        gravity: ToastGravity.SNACKBAR,
      );
    }
  }

  Future<void> tncSendStatus(String sosId, String tncSendStatus) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/sos/step/$sosId"),
      body: {
        'tnc_status': tncSendStatus,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  Future<bool> tncSendBfImg(
    String sosId,
    String imgFile,
  ) async {
    Map<String, String> headers = {"Context-Type": "multipart/formdata"};
    var requset = http.MultipartRequest(
        "POST", Uri.parse("https://api.racroad.com/api/sos/step/$sosId"))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image_bw', imgFile));
    var response = await requset.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.toString()));
    }
  }

  Future<bool> tncSendAfImg(
    String sosId,
    String imgFile,
  ) async {
    Map<String, String> headers = {"Context-Type": "multipart/formdata"};
    var requset = http.MultipartRequest(
        "POST", Uri.parse("https://api.racroad.com/api/sos/step/$sosId"))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image_aw', imgFile));
    var response = await requset.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.toString()));
    }
  }

  Future<void> _openMap(String latitude, String longitude) async {
    String googleURL =
        'https://www.google.co.th/maps/search/$latitude,$longitude';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GroupedListView<Timelines, DateTime>(
        elements: timelines,
        reverse: true,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        shrinkWrap: true,
        order: GroupedListOrder.DESC,
        padding: const EdgeInsets.only(top: 0),
        groupBy: (timelines) => DateTime(
          timelines.timestamp.month,
          timelines.timestamp.day,
          timelines.timestamp.hour,
        ),
        groupHeaderBuilder: (Timelines timelines) => SizedBox(
          height: 40,
          child: Center(
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DateFormat(
                          'd MMMM ${timelines.timestamp.yearInBuddhistCalendar}')
                      .format(timelines.timestamp),
                  style: GoogleFonts.sarabun(
                    color: darkGray,
                  ),
                ),
              ),
            ),
          ),
        ),
        itemBuilder: (context, Timelines timelines) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: timelines.isSentByMe == "1"
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              timelines.isSentByMe == "1"
                  ? Row(
                      children: [
                        Text(
                          DateFormat('KK:mm').format(timelines.timestamp),
                        ),
                        const SizedBox(width: 10),
                      ],
                    )
                  : const SizedBox.shrink(),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                color: timelines.isSentByMe == "1"
                    ? const Color.fromARGB(255, 182, 235, 255)
                    : const Color.fromARGB(255, 185, 195, 255),
                elevation: 8,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 20, 0),
                                  child: Text(
                                    timelines.title!,
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0x392E2E2E),
                                  ),
                                ),
                                timelines.body,
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: timelines.isSentByMe == "1"
                                        ? CachedNetworkImage(
                                            imageUrl: timelines.profile,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                    "assets/imgs/profile.png"),
                                          )
                                        : Image.asset(timelines.profile),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 0, 0, 0),
                                    child: Text(
                                      timelines.name,
                                      style: GoogleFonts.sarabun(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              timelines.isSentByMe != "1"
                  ? Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('KK:mm').format(timelines.timestamp),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
