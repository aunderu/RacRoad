import 'dart:convert';
import 'dart:io';

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
import 'package:rac_road/home/pages/sos/list_problem_models.dart';

import '../../screens.dart';

class SOSFormPage extends StatefulWidget {
  final String getToken;
  final String sosTitle;
  String location;
  String latitude;
  String longitude;
  SOSFormPage({
    super.key,
    required this.getToken,
    required this.sosTitle,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<SOSFormPage> createState() => _SOSFormPageState();
}

class _SOSFormPageState extends State<SOSFormPage> {
  String locationMessage = 'ยังไม่ได้เลือกที่อยู่ของคุณ';
  TextEditingController? userProblemController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    userProblemController = TextEditingController();
    locationMessage = widget.location;
  }

  final problemLists = [];

  List<ProblemModel?> selectedProblems = [];

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
                  getFromCamera();
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
                  getFromGallery();
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

  void getFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
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
    Navigator.pop(context);
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
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
    Navigator.pop(context);
  }

  Future<bool> sosSend(String filePath, String userProblem) async {
    Map<String, String> headers = {"Context-Type": "multipart/formdata"};
    var requset = http.MultipartRequest(
        "POST", Uri.parse("https://api.racroad.com/api/event/sos"))
      ..fields.addAll({
        "user_id": widget.getToken,
        "problem": widget.sosTitle,
        "problem_detail": userProblem,
        "location": widget.location,
        "latitude": widget.latitude,
        "longitude": widget.longitude,
      })
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filePath));
    var response = await requset.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.toString()));
    }
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
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0x00000000),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0x00000000),
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
                        imageFile == null
                            ? Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 0),
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
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Center(
                                  child: InkWell(
                                    onTap: showImageDialog,
                                    child: Image.file(
                                      imageFile!,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (imageFile != null) {
                                  sosSend(
                                    imageFile!.path,
                                    userProblemController!.text,
                                  );

                                  Get.toNamed("/sos");

                                  // Get.offAll(
                                  //   ScreensPage(
                                  //     getToken: widget.getToken,
                                  //     pageIndex: 2,
                                  //     current: 0,
                                  //   ),
                                  // );
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
