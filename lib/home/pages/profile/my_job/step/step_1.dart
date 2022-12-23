import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rac_road/home/pages/profile/my_job/step/step_page.dart';
import 'package:rac_road/home/screens.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import '../../../../../colors.dart';

class TncStepOne extends StatefulWidget {
  final DateTime stepOneTimeStamp;
  final String getToken;
  final String sosId;
  final String userName;
  final String userTel;
  final String problem;
  final String problemDetails;
  final String location;
  final String userProfile;
  final String imgIncident;
  final String tncName;
  final String tncAvatar;
  final String tncStatus;
  final String latitude;
  final String longitude;
  final String? imgBfwork;
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

  @override
  State<TncStepOne> createState() => _TncStepOneState();
}

class _TncStepOneState extends State<TncStepOne> {
  File? imgFile;

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imgFile = File(pickedFile.path);
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

  Future<void> _openMap(String latitude, String longitude) async {
    String googleURL =
        'https://www.google.co.th/maps/search/?api=1&query=$latitude,$longitude';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        //ผู้ยืนยันค่าบริการ
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 182, 235, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3571DAFF),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.tncStatus == "รอช่างตอบรับ"
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 20, 0),
                                  child: Text(
                                    'รับงาน',
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 0, 16, 0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      mainGreen),
                                              strokeWidth: 8,
                                            ),
                                          );
                                          tncSendStatus(widget.sosId,
                                              "กำลังออกปฏิบัติงาน");
                                          Get.to(
                                            () => StepPage(
                                              getToken: widget.getToken,
                                              sosId: widget.sosId,
                                            ),
                                          );
                                          Navigator.of(context).pop();
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 20, 0),
                                      child: Text(
                                        'ก่อนปฏิบัติงาน',
                                        style: GoogleFonts.sarabun(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 20, 7),
                                        child: Text(
                                          'รูปก่อนเริ่มงาน : ',
                                          style: GoogleFonts.sarabun(),
                                        ),
                                      ),
                                    ),
                                    imgFile == null
                                        ? Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 0),
                                              child: Material(
                                                child: InkWell(
                                                  onTap: () async {
                                                    PermissionStatus
                                                        cameraStatus =
                                                        await Permission.camera
                                                            .request();
                                                    if (cameraStatus ==
                                                        PermissionStatus
                                                            .granted) {
                                                      getFromCamera();
                                                    }
                                                    if (cameraStatus ==
                                                        PermissionStatus
                                                            .denied) {
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
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 100,
                                                    decoration:
                                                        const BoxDecoration(
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
                                            padding:
                                                const EdgeInsets.only(top: 16),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16, 0, 16, 16),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (imgFile != null) {
                                                tncSendBfImg(
                                                  widget.sosId,
                                                  imgFile!.path,
                                                );
                                                Get.to(
                                                  () => ScreensPage(
                                                    getToken: widget.getToken,
                                                    pageIndex: 4,
                                                  ),
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: 'คุณยังไม่ได้ถ่ายรูป',
                                                  backgroundColor:
                                                      Colors.yellow[100],
                                                  textColor: Colors.black,
                                                  fontSize: 15,
                                                  gravity:
                                                      ToastGravity.SNACKBAR,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 20, 0),
                                          child: Text(
                                            'หลังปฏิบัติงานเสร็จสิ้น',
                                            style: GoogleFonts.sarabun(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 20, 7),
                                            child: Text(
                                              'รูปก่อนเริ่มงาน : ',
                                              style: GoogleFonts.sarabun(),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 5, 0, 5),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: CachedNetworkImage(
                                                imageUrl: widget.imgBfwork!,
                                                width: double.infinity,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 20, 7),
                                            child: Text(
                                              'รูปหลังเสร็จงาน : ',
                                              style: GoogleFonts.sarabun(),
                                            ),
                                          ),
                                        ),
                                        imgFile == null
                                            ? Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 10, 0, 0),
                                                  child: Material(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        PermissionStatus
                                                            cameraStatus =
                                                            await Permission
                                                                .camera
                                                                .request();
                                                        if (cameraStatus ==
                                                            PermissionStatus
                                                                .granted) {
                                                          getFromCamera();
                                                        }
                                                        if (cameraStatus ==
                                                            PermissionStatus
                                                                .denied) {
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
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 100,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFEFEFEF),
                                                        ),
                                                        child: const Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          color:
                                                              Color(0xFF9D9D9D),
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: getFromCamera,
                                                    child: Image.file(
                                                      imgFile!,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(16, 0, 16, 16),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (imgFile != null) {
                                                    tncSendAfImg(
                                                      widget.sosId,
                                                      imgFile!.path,
                                                    );
                                                    Get.to(
                                                      () => ScreensPage(
                                                        getToken:
                                                            widget.getToken,
                                                        pageIndex: 4,
                                                      ),
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          'คุณยังไม่ได้ถ่ายรูป',
                                                      backgroundColor:
                                                          Colors.yellow[100],
                                                      textColor: Colors.black,
                                                      fontSize: 15,
                                                      gravity:
                                                          ToastGravity.SNACKBAR,
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: mainGreen,
                                                  minimumSize:
                                                      const Size(200, 40),
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
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
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
                              child: Image.network(
                                widget.tncAvatar,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                widget.tncName,
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //รายละเอียดค่าบริการ
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 195, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x352F44CA),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(-3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy KK:mm:ss น.')
                                .format(widget.stepOneTimeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 10),
                            child: Text(
                              'มีเหตุแจ้งมาใหม่!',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            'ชื่อผู้ใช้ : ${widget.userName}\nเบอร์โทร : ${widget.userTel}\n\nปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}',
                            style: GoogleFonts.sarabun(),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topCenter,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _openMap(widget.latitude, widget.longitude);
                              },
                              icon: const Icon(Icons.pin_drop),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                minimumSize: const Size(200, 40),
                              ),
                              label: Text(
                                "ดูใน Google Map",
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 5),
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
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
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
                              ),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Image.asset(
                                  'assets/imgs/oparator.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                'เจ้าหน้าที่ Racroad',
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
