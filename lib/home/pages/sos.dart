import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/sos/sos_form.dart';
import 'package:rac_road/home/pages/sos/timeline/timeline_page.dart';
import 'package:rac_road/models/my_current_sos_models.dart';
import 'package:rac_road/services/remote_service.dart';

class SOSPage extends StatefulWidget {
  final String token;
  const SOSPage({super.key, required this.token});

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String locationMessage = 'ยังไม่ได้เลือกที่อยู่ของคุณ';
  var _latitude = "";
  var _longitude = "";
  var _address = "";
  var _dataCurrentSos;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    setState(() {
      _dataCurrentSos = RemoteService().getMyCurrentSOS(widget.token);
    });
  }

  Future<void> _getCurrentLocation(String sosTitle) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
            strokeWidth: 8,
          ),
        );
      },
    );

    Position pos = await _determindePosition();
    List<Placemark> pm =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _address =
          "${pm.reversed.last.street}, ${pm.reversed.last.subLocality} ${pm.reversed.last.subAdministrativeArea} ${pm.reversed.last.administrativeArea}, ${pm.reversed.last.postalCode}";
    });

    Navigator.of(context).pop();

    if (!mounted) return;
    bool isRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SOSFormPage(
          getToken: widget.token,
          sosTitle: sosTitle,
          location: _address,
          latitude: _latitude,
          longitude: _longitude,
        ),
      ),
    );
    if (isRefresh) {
      _fetchData();
    }

    // Get.to(
    //   () => SOSFormPage(
    //     getToken: widget.token,
    //     sosTitle: sosTitle,
    //     location: _address,
    //     latitude: _latitude,
    //     longitude: _longitude,
    //   ),
    // );

    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SOSFormPage(
    //       getToken: widget.token,
    //       sosTitle: "เปลี่ยนล้อ ใส่ลมยาง",
    //       latitude: _latitude,
    //       longitude: _longitude,
    //       location: _address,
    //     ),
    //   ),
    // );
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsetsDirectional.all(10),
        child: FutureBuilder<MyCurrentSos?>(
          future: _dataCurrentSos,
          builder: (context, snapshot) {
            var result = snapshot.data;
            if (result != null) {
              return result.count == 1
                  ? TimeLinePage(
                      getToken: widget.token,
                      sosId: result.data.mySosInProgress[0].sosId,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Material(
                            child: InkWell(
                              splashColor: mainGreen,
                              onTap: () async {
                                _getCurrentLocation("เปลี่ยนล้อ ใส่ลมยาง")
                                    .then((value) {
                                  setState(() {
                                    locationMessage = _address;
                                  });
                                });
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 70,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      mainGreen,
                                      Color.fromARGB(255, 8, 206, 179),
                                    ],
                                    stops: [0, 1],
                                    begin: AlignmentDirectional(1, 0),
                                    end: AlignmentDirectional(-1, 0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      child: Image.asset(
                                        'assets/icons/wheel.png',
                                        color: Colors.white,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 5, 10, 5),
                                        child: AutoSizeText(
                                          'เปลี่ยนล้อ ใส่ลมยาง',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Material(
                            child: InkWell(
                              splashColor: mainGreen,
                              onTap: () async {
                                _getCurrentLocation("บริการยกรถ รถลาก")
                                    .then((value) {
                                  setState(() {
                                    locationMessage = _address;
                                  });
                                });
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 70,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      mainGreen,
                                      Color.fromARGB(255, 8, 206, 179),
                                    ],
                                    stops: [0, 1],
                                    begin: AlignmentDirectional(1, 0),
                                    end: AlignmentDirectional(-1, 0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      child: Image.asset(
                                        'assets/icons/towcar.png',
                                        color: Colors.white,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 5, 10, 5),
                                        child: AutoSizeText(
                                          'บริการยกรถ รถลาก',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Material(
                            child: InkWell(
                              splashColor: mainGreen,
                              onTap: () async {
                                _getCurrentLocation("น้ำมันหมด เติมน้ำมัน")
                                    .then((value) {
                                  setState(() {
                                    locationMessage = _address;
                                  });
                                });
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 70,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      mainGreen,
                                      Color.fromARGB(255, 8, 206, 179),
                                    ],
                                    stops: [0, 1],
                                    begin: AlignmentDirectional(1, 0),
                                    end: AlignmentDirectional(-1, 0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      // child: Icon(
                                      //   Icons.settings_outlined,
                                      //   color: Colors.white,
                                      //   size: 60,
                                      // ),
                                      child: Image.asset(
                                        'assets/icons/caroil.png',
                                        color: Colors.white,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 5, 10, 5),
                                        child: AutoSizeText(
                                          'น้ำมันหมด เติมน้ำมัน',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Material(
                            child: InkWell(
                              splashColor: mainGreen,
                              onTap: () async {
                                _getCurrentLocation("เปลี่ยนแบตเตอรี่")
                                    .then((value) {
                                  setState(() {
                                    locationMessage = _address;
                                  });
                                });
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 70,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      mainGreen,
                                      Color.fromARGB(255, 8, 206, 179),
                                    ],
                                    stops: [0, 1],
                                    begin: AlignmentDirectional(1, 0),
                                    end: AlignmentDirectional(-1, 0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      // child: Icon(
                                      //   Icons.settings_outlined,
                                      //   color: Colors.white,
                                      //   size: 60,
                                      // ),
                                      child: Image.asset(
                                        'assets/icons/carbattery.png',
                                        color: Colors.white,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 5, 10, 5),
                                        child: AutoSizeText(
                                          'เปลี่ยนแบตเตอรี่',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Material(
                            child: InkWell(
                              splashColor: mainGreen,
                              onTap: () async {
                                _getCurrentLocation("บริการอื่น ๆ")
                                    .then((value) {
                                  setState(() {
                                    locationMessage = _address;
                                  });
                                });
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 70,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      mainGreen,
                                      Color.fromARGB(255, 8, 206, 179),
                                    ],
                                    stops: [0, 1],
                                    begin: AlignmentDirectional(1, 0),
                                    end: AlignmentDirectional(-1, 0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 0, 0),
                                      // child: Icon(
                                      //   Icons.settings_outlined,
                                      //   color: Colors.white,
                                      //   size: 60,
                                      // ),
                                      child: Image.asset(
                                        'assets/icons/orther.png',
                                        color: Colors.white,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 5, 10, 5),
                                        child: AutoSizeText(
                                          'บริการอื่น ๆ',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.sarabun(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            }
            return const Align(
              alignment: Alignment(0, 0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
                strokeWidth: 8,
              ),
            );
          },
        ),
      ),
    );
  }
}
