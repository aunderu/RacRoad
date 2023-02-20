import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rac_road/models/user/car_data_calculated.dart';

import '../../../colors.dart';
import '../../models/user/all_my_car.dart';
import '../../models/user/my_car_details.dart';
import '../../services/remote_service.dart';
import 'add_car/find_car.dart';
import 'car_details_widgets.dart';

class MyCarWidget extends StatefulWidget {
  const MyCarWidget({super.key, required this.getToken});

  final String getToken;

  @override
  State<MyCarWidget> createState() => _MyCarWidgetState();
}

class _MyCarWidgetState extends State<MyCarWidget> {
  bool isLoaded = true;
  AllMyCar? myCar;
  MyCarDetails? carDetails;
  CarDataCal? carDataCal;

  bool _haveCar = false;
  bool _isMultiCar = false;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getData();
  }

  getData() async {
    setState(() {
      isLoaded == true;
    });
    myCar = await RemoteService().getMyCar(widget.getToken);

    if (myCar != null) {
      final bool haveData = myCar!.data.mycarData.isNotEmpty;
      if (haveData == true) {
        carDetails = await RemoteService()
            .getMyCarDetails(myCar!.data.mycarData[0].mycarId);
        carDataCal = await RemoteService()
            .getCarDataCal(myCar!.data.mycarData[0].mycarId);
        if (mounted) {
          setState(() {
            _isMultiCar = myCar!.data.mycarData.length > 1;
            _haveCar = true;
            isLoaded = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _haveCar = false;
            isLoaded = false;
          });
        }
      }
    }
  }

  void deleteCar(String carId) async {
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
    var url = Uri.parse('https://api.racroad.com/api/mycar/destroy/$carId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      Get.offAllNamed('/profile');
      Fluttertoast.showToast(
        msg: "คุณได้ลบคลับนี้แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded == true) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.5,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
            strokeWidth: 8,
          ),
        ),
      );
    } else {
      if (_haveCar == true) {
        if (_isMultiCar == true) {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Column(
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: myCar!.data.mycarData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x411D2429),
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                        child: Material(
                          child: InkWell(
                            onTap: () async {
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
                              MyCarDetails? specificCarDetails =
                                  await RemoteService().getMyCarDetails(
                                      myCar!.data.mycarData[index].mycarId);
                              CarDataCal? specificCarDataCal =
                                  await RemoteService().getCarDataCal(
                                      myCar!.data.mycarData[index].mycarId);

                              Get.back();

                              if (!mounted) return;
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                enableDrag: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: carDetailsWidget(
                                      context,
                                      widget.getToken,
                                      specificCarDetails!,
                                      specificCarDataCal!),
                                ),
                              );
                            },
                            onLongPress: () {
                              Get.defaultDialog(
                                title: 'ลบ',
                                titleStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                middleText:
                                    'คุณต้องการลบข้อมูลรถยนต์นี้หรือไม่?',
                                textConfirm: "ลบข้อมูล",
                                textCancel: "ยกเลิก",
                                confirmTextColor: Colors.white,
                                onConfirm: () => deleteCar(
                                    myCar!.data.mycarData[index].mycarId),
                              );
                            },
                            child: Ink(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: primaryBGColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 1, 1, 1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: myCar!
                                              .data.mycarData[index].carProfile,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/icons/404.png',
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 8, 4, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              myCar!.data.mycarData[index]
                                                  .carBrand,
                                              style: GoogleFonts.sarabun(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 8, 0),
                                              child: AutoSizeText(
                                                myCar!.data.mycarData[index]
                                                    .carNo,
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.sarabun(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 0, 0),
                                          child: Icon(
                                            Icons.chevron_right_rounded,
                                            color: Color(0xFF57636C),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => FindCarPage(getToken: widget.getToken),
                          );
                        },
                        child: Ink(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: lightGrey,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: darkGray,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              carDetailsWidget(
                context,
                widget.getToken,
                carDetails!,
                carDataCal!,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          () => FindCarPage(getToken: widget.getToken),
                        );
                      },
                      child: Ink(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: darkGray,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      } else {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                "assets/imgs/mycar.png",
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                'เพิ่มข้อมูลรถของคุณ',
                style: GoogleFonts.sarabun(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.to(
                    () => FindCarPage(getToken: widget.getToken),
                  );
                },
                child: Text(
                  'เพิ่มรถ',
                  style: GoogleFonts.sarabun(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: mainGreen,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
