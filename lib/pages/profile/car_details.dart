import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:rac_road/models/user/car_data_calculated.dart';

import '../../colors.dart';
import '../../models/data/menu_items.dart';
import '../../models/menu_item.dart';
import '../../models/user/my_car_details.dart';
import 'add_car/find_car.dart';

void deleteCar(String carId) async {
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

void onSelected(BuildContext context, CustomMenuItem item, String carId) {
  switch (item) {
    case CarMenuItems.itemDelete:
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "ลบข้อมูลรถของคุณ",
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
              'ข้อมูลรถนี้จะหายไปตลอดการและไม่สามารถย้อนกลับได้ คุณแน่ใช่แล้วใช่ไหม'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteCar(carId);
              },
              child: const Text('ลบข้อมูลรถ'),
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

Widget carDetailsWidget(
  BuildContext context,
  String getToken,
  MyCarDetails carDetails,
  CarDataCal carDataCal,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        carDetails.data!.mycarDetail!.carNo!,
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    PopupMenuButton<CustomMenuItem>(
                      onSelected: (item) => onSelected(context, item,
                          carDetails.data!.mycarDetail!.mycarId!),
                      itemBuilder: (context) => [
                        ...CarMenuItems.itemsDelete.map(buildItem).toList(),
                      ],
                      child: const Icon(
                        Icons.keyboard_control,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'รุ่น : ${carDetails.data!.mycarDetail!.carModel}\nโฉม : ${carDetails.data!.mycarDetail!.carMakeover}\nรุ่นย่อย : ${carDetails.data!.mycarDetail!.carSubversion}\nเชื้อเพลิง : ${carDetails.data!.mycarDetail!.carFuel}',
                          style: GoogleFonts.sarabun(),
                        ),
                      ),
                      SizedBox(
                        height: 75,
                        width: 100,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14)),
                          child: CachedNetworkImage(
                            imageUrl: carDetails.data!.mycarDetail!.carProfile!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) => Container(
                                color: Colors.white,
                                child: const Icon(Icons.error)),
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
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: GridView(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => Container());
                  },
                  child: Ink(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBEBEB),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'น้ำมัน',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เครื่อง',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent:
                                          carDataCal.data.engineOilCal == null
                                              ? 0
                                              : carDataCal.data.engineOilCal!
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.engineOilCal == null
                                            ? '0%'
                                            : '${carDataCal.data.engineOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เบรก',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent:
                                          carDataCal.data.brakeOilCal == null
                                              ? 0
                                              : carDataCal.data.brakeOilCal!
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.brakeOilCal == null
                                            ? '0%'
                                            : '${carDataCal.data.brakeOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เพาเวอร์',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent:
                                          carDataCal.data.powerOilCal == null
                                              ? 0
                                              : carDataCal.data.powerOilCal!
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.powerOilCal == null
                                            ? '0%'
                                            : '${carDataCal.data.powerOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เกียร์',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent:
                                          carDataCal.data.gearOilCal == null
                                              ? 0
                                              : carDataCal.data.gearOilCal!
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.gearOilCal == null
                                            ? '0%'
                                            : '${carDataCal.data.gearOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
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
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => Container(),
                    );
                  },
                  child: Ink(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'ยางรถ',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ผ้าเบรก',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent:
                                          carDataCal.data.brakeOilCal == null
                                              ? 0
                                              : carDataCal.data.brakeOilCal!
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.brakeOilCal == null
                                            ? '0%'
                                            : '${carDataCal.data.brakeOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ยางรถ',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent:
                                          carDataCal.data.carTireCal == null
                                              ? 0
                                              : carDataCal.data.carTireCal!
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.carTireCal == null
                                            ? '0%'
                                            : '${carDataCal.data.carTireCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
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
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => Container());
                  },
                  child: Ink(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'แบตเตอรี่',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'แบตเตอรี่',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent:
                                          carDataCal.data.batteryCal == null
                                              ? 0
                                              : carDataCal.data.batteryCal!
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.batteryCal == null
                                            ? '0%'
                                            : '${carDataCal.data.batteryCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
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
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => Container(),
                    );
                  },
                  child: Ink(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBEBEB),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Text(
                              'แอร์',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1, -1),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                            child: Icon(
                              Icons.keyboard_control,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'น้ำยา',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 12,
                                      ),
                                    ),
                                    LinearPercentIndicator(
                                      percent: carDataCal.data.airCal == null
                                          ? 0
                                          : carDataCal
                                                  .data.airCal!.dateRemainAvg! /
                                              100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.airCal == null
                                            ? '0%'
                                            : '${carDataCal.data.airCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                        style: GoogleFonts.sarabun(
                                          color: const Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      barRadius: const Radius.circular(50),
                                      padding: EdgeInsets.zero,
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
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            child: InkWell(
              onTap: () {
                Get.to(
                  () => FindCarPage(getToken: getToken),
                );
              },
              child: Ink(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black,
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
