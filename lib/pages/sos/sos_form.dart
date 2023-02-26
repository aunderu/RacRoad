import 'dart:convert';
import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:rac_road/colors.dart';
import 'package:http/http.dart' as http;

class SOSFormPage extends StatefulWidget {
  SOSFormPage({
    super.key,
    required this.getToken,
    required this.sosTitle,
    required this.problems,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  final String getToken;
  String latitude;
  String location;
  String longitude;
  List<String> problems;
  final String sosTitle;

  @override
  State<SOSFormPage> createState() => _SOSFormPageState();
}

class _SOSFormPageState extends State<SOSFormPage> {
  final formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  List<File> imageFile = <File>[];
  List<XFile> photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  XFile? camera;

  String locationMessage = 'ยังไม่ได้เลือกที่อยู่ของคุณ';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int tag = 1;
  TextEditingController? userProblemController;

  var _isLoading = false;
  List<String> _isSelected = [];

  @override
  void initState() {
    super.initState();
    userProblemController = TextEditingController();
    locationMessage = widget.location;
  }

  void showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('กรุณาเลือกรูป', textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.sarabun(
            color: Colors.black,
            fontSize: 20,
          ),
          alignment: Alignment.center,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  pickCamera();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'กล้อง',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  pickPhotoFromGallery();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'รูปภาพ',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage(imageQuality: 50);
    if (photo.isNotEmpty) {
      setState(() {
        itemImagesList += photo;
        photo.clear();
      });
    } else {
      Get.snackbar(
        'คำเตือน',
        'คุณยังไม่ได้เลือกรูป',
        backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 191, 0),
          Color.fromARGB(255, 255, 234, 172),
        ]),
        barBlur: 15,
        animationDuration: const Duration(milliseconds: 500),
        icon: const Icon(
          Icons.warning,
          size: 30,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    Get.back();
  }

  pickCamera() async {
    camera = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (camera != null) {
      setState(() {
        itemImagesList.add(camera!);
      });
    } else {
      Get.snackbar(
        'คำเตือน',
        'คุณยังไม่ได้เลือกรูป',
        backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 191, 0),
          Color.fromARGB(255, 255, 234, 172),
        ]),
        barBlur: 15,
        animationDuration: const Duration(milliseconds: 500),
        icon: const Icon(
          Icons.warning,
          size: 30,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    Get.back();
  }

  Future<bool> sosSend(List<File> imgFile, String userProblem) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.racroad.com/api/event/sos'))
      ..fields.addAll({
        "user_id": widget.getToken,
        "problem": widget.sosTitle,
        "problem_detail": userProblem,
        "location": widget.location,
        "latitude": widget.latitude,
        "longitude": widget.longitude,
      })
      ..headers.addAll(headers);
    for (var i = 0; i < imgFile.length; i++) {
      request.files.add(
        http.MultipartFile(
            'image[$i]',
            File(imgFile[i].path).readAsBytes().asStream(),
            File(imgFile[i].path).lengthSync(),
            filename: imgFile[i].path.split("/").last),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  // static final List<Problems> _problemList = [
  //   Problems(id: 1, problem: "ล้อยางแบน"),
  //   Problems(id: 2, problem: "ล้อยางระเบิด"),
  //   Problems(id: 3, problem: "ล้อหลุด"),
  // ];

  Future<void> _getCurrentLocation() async {
    Position pos = await _determindePosition();
    List<Placemark> pm =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      widget.latitude = pos.latitude.toString();
      widget.longitude = pos.longitude.toString();
      widget.location =
          "${pm.reversed.last.street}, ${pm.reversed.last.subLocality} ${pm.reversed.last.subAdministrativeArea} ${pm.reversed.last.administrativeArea}, ${pm.reversed.last.postalCode}";
    });
  }

  // เอาโลเคชันของผู้ใช้ รับเป็น ละติจุด ลองติจุด
  Future<Position> _determindePosition() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('บริการระบุตำแหน่งปิดใช้งานอยู่');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("สิทธิ์ในการระบุตำแหน่งถูกปฏิเสธ");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'สิทธิ์เข้าถึงตำแหน่งถูกปฏิเสธอย่างถาวร พวกเราไม่สามารถเข้าถึงการระบุตำแหน่งได้');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Text(
          widget.sosTitle,
          style: GoogleFonts.sarabun(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 50,
                          thickness: 1,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            'ที่อยู่',
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 10, 16, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Material(
                              child: InkWell(
                                onTap: _isLoading
                                    ? null
                                    : () {
                                        setState(
                                          () => _isLoading = true,
                                        );
                                        _getCurrentLocation().then((value) {
                                          setState(() {
                                            locationMessage = widget.location;
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                child: Ink(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _isLoading
                                        ? lightGrey
                                        : const Color(0x6939D2C0),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 10, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _isLoading
                                            ? Container(
                                                width: 20,
                                                height: 20,
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      105, 1, 61, 54),
                                                  strokeWidth: 3,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.location_on_sharp,
                                                color: Color.fromARGB(
                                                    105, 1, 61, 54),
                                                size: 24,
                                              ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            'เลือกที่อยู่ของคุณผ่าน GPS',
                                            style: GoogleFonts.sarabun(
                                              color: const Color.fromARGB(
                                                  105, 1, 61, 54),
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color.fromARGB(105, 1, 61, 54),
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 10, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "ที่อยู่ : $locationMessage",
                                  style: GoogleFonts.sarabun(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 50,
                          thickness: 1,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            'รายละเอียดที่พบ',
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 10, 16, 0),
                          child: TextFormField(
                            controller: userProblemController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'ปัญหาที่พบ',
                              hintStyle: GoogleFonts.sarabun(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: lightGrey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: mainGreen,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      20, 32, 20, 12),
                            ),
                            style: GoogleFonts.sarabun(),
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        widget.problems.isNotEmpty
                            ? ChipsChoice<String>.multiple(
                                value: _isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    _isSelected = value;
                                  });
                                  var stringList = _isSelected.join(", ");
                                  userProblemController?.text = stringList;
                                },
                                choiceItems: C2Choice.listFrom(
                                  source: widget.problems,
                                  value: (index, item) => item,
                                  label: (index, item) => item,
                                ),
                                choiceCheckmark: true,
                                choiceStyle: C2ChipStyle.toned(
                                  selectedStyle: const C2ChipStyle(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    foregroundColor: mainGreen,
                                    backgroundColor: mainGreen,
                                  ),
                                ),
                                wrapped: true,
                                textDirection: TextDirection.ltr,
                              )
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message: "แนบรูปภาพ",
                                verticalOffset: -55,
                                child: Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: InkWell(
                                    onTap: () async {
                                      PermissionStatus cameraStatus =
                                          await Permission.camera.request();
                                      if (cameraStatus ==
                                          PermissionStatus.granted) {
                                        showImageDialog();
                                      }
                                      if (cameraStatus ==
                                          PermissionStatus.denied) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "This permission is recommended");
                                      }
                                      if (cameraStatus ==
                                          PermissionStatus.permanentlyDenied) {
                                        openAppSettings();
                                      }
                                    },
                                    child: Ink(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEFEFEF),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Color(0xFF9D9D9D),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              itemImagesList.isNotEmpty
                                  ? Flexible(
                                      child: SizedBox(
                                        height: 100,
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 120,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 10,
                                          ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: itemImagesList.length,
                                          itemBuilder: (context, index) {
                                            return Stack(
                                              children: [
                                                SizedBox(
                                                  height: double.maxFinite,
                                                  width: double.maxFinite,
                                                  child: Image.file(
                                                    File(itemImagesList[
                                                            (itemImagesList
                                                                        .length -
                                                                    1) -
                                                                index]
                                                        .path),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: -1.0,
                                                  right: -1.0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        itemImagesList.removeAt(
                                                            (itemImagesList
                                                                        .length -
                                                                    1) -
                                                                index);
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (itemImagesList.isNotEmpty) {
                                  for (var i = 0;
                                      i < itemImagesList.length;
                                      i++) {
                                    // print('index $i , value ${itemImagesList[i].path}');

                                    imageFile.add(File(itemImagesList[i].path));
                                  }

                                  sosSend(
                                    imageFile,
                                    userProblemController!.text,
                                  );

                                  Get.offAllNamed('/sos');
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "กรุณาแนบรูปภาพมาด้วย",
                                    backgroundColor: Colors.yellowAccent,
                                    textColor: Colors.black,
                                  );
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
      ),
    );
  }
}
