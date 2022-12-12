import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/sos/sos_form_sended.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../services/remote_service.dart';

class SOSFormPage extends StatefulWidget {
  final String getToken;
  final String sosTitle;
  const SOSFormPage({
    super.key,
    required this.getToken,
    required this.sosTitle,
  });

  @override
  State<SOSFormPage> createState() => _SOSFormPageState();
}

class _SOSFormPageState extends State<SOSFormPage> {
  String locationMessage = 'ยังไม่ได้เลือกที่อยู่ของคุณ';
  TextEditingController? userNameController;
  TextEditingController? userPhoneNumContoller;
  TextEditingController? userProblemController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _latitude = "";
  var _longitude = "";
  var _address = "";

  Future<void> _getCurrentLocation() async {
    Position pos = await _determindePosition();
    List<Placemark> pm =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _address =
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

  Future<void> _openMap(String _latitude, String _longitude) async {
    String googleURL =
        'https://www.google.co.th/maps/search/?api=1&query=$_latitude,$_longitude';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
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
            Navigator.of(context).pop();
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
              child: FutureBuilder(
                future: RemoteService().getUserProfile(widget.getToken),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 0, 0),
                                child: Text(
                                  'ข้อมูลติดต่อ',
                                  style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: TextFormField(
                                  controller: userNameController,
                                  obscureText: false,
                                  initialValue:
                                      snapshot.data!.data.myProfile.name,
                                  decoration: InputDecoration(
                                    labelText: 'ชื่อ',
                                    labelStyle: GoogleFonts.sarabun(
                                      color: darkGray,
                                      fontWeight: FontWeight.normal,
                                    ),
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
                                  maxLines: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 10, 16, 0),
                                child: TextFormField(
                                  controller: userPhoneNumContoller,
                                  obscureText: false,
                                  initialValue:
                                      snapshot.data!.data.myProfile.tel,
                                  decoration: InputDecoration(
                                    labelText: 'เบอร์โทร',
                                    labelStyle: GoogleFonts.sarabun(
                                      color: darkGray,
                                      fontWeight: FontWeight.normal,
                                    ),
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
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              const Divider(
                                height: 50,
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 0, 0),
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
                                      onTap: () {
                                        // _getCurrentLocation().then((value) {
                                        //   _latitude = '${value.latitude}';
                                        //   _longitude = '${value.longitude}';
                                        //   setState(() {
                                        //     locationMessage =
                                        //         "latitude: $_latitude , longitude: $_longitude";
                                        //   });
                                        //   _liveLocation();
                                        //   // _openMap(lat, long);
                                        // });

                                        _getCurrentLocation().then((value) {
                                          setState(() {
                                            locationMessage = _address;
                                          });
                                        });
                                      },
                                      child: Ink(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0x6939D2C0),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.location_on_sharp,
                                                color: Color.fromARGB(
                                                    105, 1, 61, 54),
                                                size: 24,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'เลือกที่อยู่ของคุณ',
                                                  style: GoogleFonts.sarabun(
                                                    color: const Color.fromARGB(
                                                        105, 1, 61, 54),
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color.fromARGB(
                                                    105, 1, 61, 54),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 0, 0),
                                child: Text(
                                  'ปัญหา',
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
                              Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 0),
                                  child: Container(
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
                              Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(
                                        () => SOSFormSended(
                                            token: widget.getToken),
                                      );
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
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
