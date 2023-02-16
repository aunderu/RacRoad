import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/models/sos/problem_type.dart';
import 'package:rac_road/models/sos/specific_problem.dart';
import 'package:rac_road/services/remote_service.dart';

import '../colors.dart';
import '../models/sos/my_current_sos_models.dart';
import 'sos/sos_form.dart';
import 'sos/timeline/timeline_page.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  String locationMessage = 'ยังไม่ได้เลือกที่อยู่ของคุณ';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var _address = "";
  dynamic _dataCurrentSos;
  dynamic _dataProblemType;
  SpecificProblem? _dataSpecificProblem;
  var _latitude = "";
  var _longitude = "";

  @override
  void initState() {
    super.initState();
    getData();

    setUpTimedFetch();
  }

  getData() {
    _dataCurrentSos = RemoteService().getMyCurrentSOS(widget.token);
    _dataProblemType = RemoteService().getProblemType();
  }

  List<String> prefixList = [];
  Future<bool> getSpecificProblem(String problemId) async {
    _dataSpecificProblem = await RemoteService().getSpecificProblem(problemId);

    for (int i = 0;
        i < _dataSpecificProblem!.data.problemInProblemType.length;
        i++) {
      prefixList.add(_dataSpecificProblem!.data.problemInProblemType[i].problem
          .toString());
    }

    if (_dataSpecificProblem == null) {
      return false;
    } else {
      return true;
    }
  }

  setUpTimedFetch() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _dataCurrentSos = RemoteService().getMyCurrentSOS(widget.token);
        });
      }
    });
  }

  Future<void> _getCurrentLocation(
      String sosTitle, List<String> problems) async {
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

    Get.back();

    Get.to(
      () => SOSFormPage(
        getToken: widget.token,
        problems: problems,
        sosTitle: sosTitle,
        location: _address,
        latitude: _latitude,
        longitude: _longitude,
      ),
    );
  }

  // เอาโลเคชันของผู้ใช้ รับเป็น ละติจุด ลองติจุด
  Future<Position> _determindePosition() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      Get.back();
      return Future.error('บริการระบุตำแหน่งปิดใช้งานอยู่');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.back();
        return Future.error("สิทธิ์ในการระบุตำแหน่งถูกปฏิเสธ");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.back();
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
                  : FutureBuilder<ProblemType?>(
                      future: _dataProblemType,
                      builder: (context, snapshot) {
                        var result = snapshot.data;
                        if (result != null) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1.5,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        mainGreen),
                                    strokeWidth: 8,
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                            default:
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                              } else if (snapshot
                                  .data!.data.problemTypeAll.isNotEmpty) {
                                return snapshot.hasData
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                          ),
                                          itemCount: snapshot
                                              .data!.data.problemTypeAll.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 15,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                child: Material(
                                                  child: InkWell(
                                                    splashColor: mainGreen,
                                                    onTap: () {
                                                      getSpecificProblem(result
                                                              .data
                                                              .problemTypeAll[
                                                                  index]
                                                              .id)
                                                          .then((value) {
                                                        if (value == true) {
                                                          _getCurrentLocation(
                                                            result
                                                                .data
                                                                .problemTypeAll[
                                                                    index]
                                                                .name,
                                                            prefixList,
                                                          ).then((value) {
                                                            setState(() {
                                                              locationMessage =
                                                                  _address;
                                                            });
                                                          });
                                                        }
                                                      });

                                                      prefixList.clear();
                                                    },
                                                    child: Ink(
                                                      width: double.infinity,
                                                      height: 70,
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            mainGreen,
                                                            Color.fromARGB(255,
                                                                8, 206, 179),
                                                          ],
                                                          stops: [0, 1],
                                                          begin:
                                                              AlignmentDirectional(
                                                                  1, 0),
                                                          end:
                                                              AlignmentDirectional(
                                                                  -1, 0),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    10,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: result
                                                                  .data
                                                                  .problemTypeAll[
                                                                      index]
                                                                  .image,
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                'assets/icons/404.png',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              width: 50,
                                                              height: 50,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      20,
                                                                      5,
                                                                      10,
                                                                      5),
                                                              child:
                                                                  AutoSizeText(
                                                                result
                                                                    .data
                                                                    .problemTypeAll[
                                                                        index]
                                                                    .name,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    GoogleFonts
                                                                        .sarabun(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white,
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
                                            );
                                          },
                                        ),
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.5,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    mainGreen),
                                            strokeWidth: 8,
                                          ),
                                        ),
                                      );
                              } else {
                                return Center(
                                  child: Text(
                                    'ดูเหมือนมีอะไรผิดปกติ',
                                    style: GoogleFonts.sarabun(),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                          }
                        }
                        return Center(
                          child: Text(
                            'ข้อมูลกำลังโหลดกรุณารอสักครู่...',
                            style: GoogleFonts.sarabun(),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
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
