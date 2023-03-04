import 'dart:convert';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:rac_road/models/user/car_data_calculated.dart';

import '../../colors.dart';
import '../../models/data/menu_items.dart';
import '../../models/menu_item.dart';
import '../../models/user/my_car_details.dart';

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
                        '${carDetails.data!.mycarDetail!.carBrand!} ${carDetails.data!.mycarDetail!.carNo!}',
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                      useSafeArea: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => OilWidgets(
                        carDataCal: carDataCal,
                        carDetails: carDetails,
                      ),
                    );
                  },
                  child: Ink(
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
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                              ),
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
                          child: SingleChildScrollView(
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
                                      Flexible(
                                        child: Text(
                                          'เครื่อง',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.engineOilCal == null
                                                ? 0
                                                : carDataCal.data.engineOilCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.engineOilCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.engineOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.engineOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal
                                                      .data
                                                      .engineOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.engineOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.engineOilCal == null
                                              ? '0%'
                                              : '${carDataCal.data.engineOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                      Flexible(
                                        child: Text(
                                          'เบรก',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.brakeOilCal == null
                                                ? 0
                                                : carDataCal.data.brakeOilCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .brakeOilCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.brakeOilCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.brakeOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.brakeOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal
                                                      .data
                                                      .brakeOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.brakeOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.brakeOilCal == null
                                              ? '0%'
                                              : carDataCal.data.brakeOilCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? "0%"
                                                  : '${carDataCal.data.brakeOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                      Flexible(
                                        child: Text(
                                          'เพาเวอร์',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.powerOilCal == null
                                                ? 0
                                                : carDataCal.data.powerOilCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .powerOilCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.powerOilCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.powerOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.powerOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal
                                                      .data
                                                      .powerOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.powerOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.powerOilCal == null
                                              ? '0%'
                                              : carDataCal.data.powerOilCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.powerOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                      Flexible(
                                        child: Text(
                                          'เกียร์',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.gearOilCal == null
                                                ? 0
                                                : carDataCal.data.gearOilCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .gearOilCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.gearOilCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.gearOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.gearOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal.data.gearOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.gearOilCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.gearOilCal == null
                                              ? '0%'
                                              : carDataCal.data.gearOilCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.gearOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                      useSafeArea: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => TireWidgets(
                        carDataCal: carDataCal,
                        carDetails: carDetails,
                      ),
                    );
                  },
                  child: Ink(
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
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                              ),
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
                          child: SingleChildScrollView(
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
                                      Flexible(
                                        child: Text(
                                          'ผ้าเบรก',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.brakePadsCal == null
                                                ? 0
                                                : carDataCal.data.brakePadsCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .brakePadsCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.brakePadsCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.brakePadsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.brakePadsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal
                                                      .data
                                                      .brakePadsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.brakePadsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.brakePadsCal == null
                                              ? '0%'
                                              : carDataCal.data.brakePadsCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.brakePadsCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                      Flexible(
                                        child: Text(
                                          'ยางรถ',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.carTireCal == null
                                                ? 0
                                                : carDataCal.data.carTireCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .carTireCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.carTireCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.carTireCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.carTireCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal.data.carTireCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.carTireCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.carTireCal == null
                                              ? '0%'
                                              : carDataCal.data.carTireCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.carTireCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                      useSafeArea: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => BatteryWidgets(
                        carDataCal: carDataCal,
                        carDetails: carDetails,
                      ),
                    );
                  },
                  child: Ink(
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
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                              ),
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
                          child: SingleChildScrollView(
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
                                      Flexible(
                                        child: Text(
                                          'แบตเตอรี่',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.batteryCal == null
                                                ? 0
                                                : carDataCal.data.batteryCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .batteryCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.batteryCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.batteryCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.batteryCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal.data.batteryCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.batteryCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.batteryCal == null
                                              ? '0%'
                                              : carDataCal.data.batteryCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.batteryCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                      useSafeArea: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => AirWidgets(
                        carDataCal: carDataCal,
                        carDetails: carDetails,
                      ),
                    );
                  },
                  child: Ink(
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
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                              ),
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
                          child: SingleChildScrollView(
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
                                      Flexible(
                                        child: Text(
                                          'น้ำยา',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent: carDataCal.data.airCal == null
                                            ? 0
                                            : carDataCal.data.airCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : carDataCal.data.airCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.airCal == null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.airCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.airCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal.data.airCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.airCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.airCal == null
                                              ? '0%'
                                              : carDataCal.data.airCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.airCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                      Flexible(
                                        child: Text(
                                          'แผงคอยล์ร้อน',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.cleanHsCal == null
                                                ? 0
                                                : carDataCal.data.cleanHsCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .cleanHsCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.cleanHsCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.cleanHsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.cleanHsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal.data.cleanHsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.cleanHsCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.cleanHsCal == null
                                              ? '0%'
                                              : carDataCal.data.cleanHsCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.cleanHsCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                      Flexible(
                                        child: Text(
                                          'ตัวกรองแอร์',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        percent:
                                            carDataCal.data.changeAfCal == null
                                                ? 0
                                                : carDataCal.data.changeAfCal!
                                                            .dateRemainAvg! <
                                                        0
                                                    ? 0
                                                    : carDataCal
                                                            .data
                                                            .changeAfCal!
                                                            .dateRemainAvg!
                                                            .roundToDouble() /
                                                        100,
                                        width: 100,
                                        lineHeight: 24,
                                        animation: true,
                                        progressColor: (() {
                                          if (carDataCal.data.changeAfCal ==
                                              null) {
                                            return Colors.red;
                                          }
                                          if (carDataCal.data.changeAfCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <=
                                                  100.00 &&
                                              carDataCal.data.changeAfCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  50.00) {
                                            return mainGreen;
                                          } else if (carDataCal
                                                      .data
                                                      .changeAfCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() <
                                                  50.00 &&
                                              carDataCal.data.changeAfCal!
                                                      .dateRemainAvg!
                                                      .roundToDouble() >=
                                                  30.00) {
                                            return Colors.yellow;
                                          } else {
                                            return Colors.red;
                                          }
                                        }()),
                                        backgroundColor: Colors.white,
                                        center: Text(
                                          carDataCal.data.changeAfCal == null
                                              ? '0%'
                                              : carDataCal.data.changeAfCal!
                                                          .dateRemainAvg! <
                                                      0
                                                  ? '0%'
                                                  : '${carDataCal.data.changeAfCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
    ],
  );
}

class OilWidgets extends StatefulWidget {
  const OilWidgets({
    super.key,
    required this.carDataCal,
    required this.carDetails,
  });

  final CarDataCal carDataCal;
  final MyCarDetails carDetails;

  @override
  State<OilWidgets> createState() => _OilWidgetsState();
}

class _OilWidgetsState extends State<OilWidgets> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController mileNowController = TextEditingController();
    TextEditingController mileNextController = TextEditingController();

    DateTime date = DateTime.now();

    @override
    void initState() {
      super.initState();

      mileNowController = TextEditingController();
      mileNextController = TextEditingController();
    }

    @override
    void dispose() {
      mileNowController.dispose();
      mileNextController.dispose();
      super.dispose();
    }

    Future<bool> saveUpgc(
      String carId,
      String problemType,
      String mileNow,
      String mileNext,
      String date,
    ) async {
      final response = await http.post(
        Uri.parse("https://api.racroad.com/api/upgc/store"),
        body: {
          'mycar_id': carId,
          'type': problemType,
          'mile_now': mileNow,
          'mile_next': mileNext,
          'date': date,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    }

    void showFormDialog(String title, String changePart) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              title: Text(
                title,
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
                            controller: mileNowController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            validator: MultiValidator([
                              RequiredValidator(
                                errorText: "กรุณากรอกเลขไมล์ด้วย",
                              ),
                            ]),
                            decoration: const InputDecoration(
                              label: Text("กรอกเลขไมล์ปัจจุบัน"),
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
                            controller: mileNextController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            validator: MultiValidator([
                              RequiredValidator(
                                errorText: "กรุณากรอกเลขไมล์ด้วย",
                              ),
                            ]),
                            decoration: const InputDecoration(
                              label: Text("กรอกเลขไมล์ครั้งต่อไป"),
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
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                          child: InkWell(
                            splashColor: mainGreen,
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (newDate == null) return;

                              setState(() => date = newDate);

                              Get.appUpdate();
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: mainGreen,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range_rounded,
                                        color: mainGreen,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          '${date.day}/${date.month}/${date.year}',
                                          style: GoogleFonts.sarabun(),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '* วันเดือนปี ณ ตอนที่คุณเปลี่ยนอะไหล่ครั้งล่าสุด',
                              style: GoogleFonts.sarabun(
                                color: darkGray,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                mainGreen),
                                        strokeWidth: 8,
                                      ),
                                    );
                                  },
                                );

                                saveUpgc(
                                  widget.carDetails.data!.mycarDetail!.mycarId!,
                                  changePart,
                                  mileNowController.text,
                                  mileNextController.text,
                                  date.toString(),
                                ).then((value) {
                                  if (value == false) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                                      backgroundColor: Colors.yellowAccent,
                                      textColor: Colors.black,
                                    );
                                  }

                                  Get.offAllNamed('/profile');
                                });
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Center(
              child: Text(
                'น้ำมัน',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('น้ำมันเครื่อง', 'engine_oil'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.engineOilCal == null
                                      ? 'น้ำมันเครื่อง 0%'
                                      : widget.carDataCal.data.engineOilCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'น้ำมันเครื่อง 0%'
                                          : 'น้ำมันเครื่อง ${widget.carDataCal.data.engineOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.engineOilCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.engineOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.engineOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .engineOilCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.engineOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.engineOilCal ==
                                                null
                                            ? 0
                                            : widget
                                                        .carDataCal
                                                        .data
                                                        .engineOilCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .engineOilCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.engineOilCal ==
                                              null
                                          ? '0%'
                                          : widget.carDataCal.data.engineOilCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.engineOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    widget.carDataCal.data.engineOilCal == null
                                        ? 'คุณยังไม่ได้กรอกข้อมูล'
                                        : 'เริ่มต้น ${widget.carDataCal.data.engineOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.engineOilCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.engineOilCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.engineOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.engineOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.engineOilCal!.dateUpgradeNext!)}',
                                    style: GoogleFonts.sarabun(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('น้ำมันเบรก', 'brake_oil'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.brakeOilCal == null
                                      ? 'น้ำมันเบรก 0%'
                                      : widget.carDataCal.data.brakeOilCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'น้ำมันเบรก 0%'
                                          : 'น้ำมันเบรก ${widget.carDataCal.data.brakeOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.brakeOilCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.brakeOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.brakeOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .brakeOilCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.brakeOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.brakeOilCal ==
                                                null
                                            ? 0
                                            : widget
                                                        .carDataCal
                                                        .data
                                                        .brakeOilCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .brakeOilCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.brakeOilCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.brakeOilCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.brakeOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.brakeOilCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.brakeOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.brakeOilCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.brakeOilCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.brakeOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.brakeOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.brakeOilCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('น้ำมันเพาเวอร์', 'power_oil'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.powerOilCal == null
                                      ? 'น้ำมันเพาเวอร์ 0%'
                                      : widget.carDataCal.data.powerOilCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'น้ำมันเพาเวอร์ 0%'
                                          : 'น้ำมันเพาเวอร์ ${widget.carDataCal.data.powerOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.powerOilCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.powerOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.powerOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .powerOilCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.powerOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.powerOilCal ==
                                                null
                                            ? 0
                                            : widget
                                                        .carDataCal
                                                        .data
                                                        .powerOilCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .powerOilCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.powerOilCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.powerOilCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.powerOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.powerOilCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.powerOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.powerOilCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.powerOilCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.powerOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.powerOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.powerOilCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('น้ำมันเกียร์', 'gear_oil'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.gearOilCal == null
                                      ? 'น้ำมันเกียร์ 0%'
                                      : widget.carDataCal.data.gearOilCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'น้ำมันเกียร์ 0%'
                                          : 'น้ำมันเกียร์ ${widget.carDataCal.data.gearOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.gearOilCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.gearOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.gearOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .gearOilCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.gearOilCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.gearOilCal ==
                                                null
                                            ? 0
                                            : widget.carDataCal.data.gearOilCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .gearOilCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.gearOilCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.gearOilCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.gearOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.gearOilCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.gearOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.gearOilCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.gearOilCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.gearOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.gearOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.gearOilCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class TireWidgets extends StatefulWidget {
  const TireWidgets({
    super.key,
    required this.carDataCal,
    required this.carDetails,
  });

  final CarDataCal carDataCal;
  final MyCarDetails carDetails;

  @override
  State<TireWidgets> createState() => _TireWidgetsState();
}

class _TireWidgetsState extends State<TireWidgets> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mileNowController = TextEditingController();
  TextEditingController mileNextController = TextEditingController();

  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();

    mileNowController = TextEditingController();
    mileNextController = TextEditingController();
  }

  @override
  void dispose() {
    mileNowController.dispose();
    mileNextController.dispose();
    super.dispose();
  }

  Future<bool> saveUpgc(
    String carId,
    String problemType,
    String mileNow,
    String mileNext,
    String date,
  ) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/upgc/store"),
      body: {
        'mycar_id': carId,
        'type': problemType,
        'mile_now': mileNow,
        'mile_next': mileNext,
        'date': date,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  void showFormDialog(String title, String changePart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            title: Text(
              title,
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
                          controller: mileNowController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณากรอกเลขไมล์ด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกเลขไมล์ปัจจุบัน"),
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
                          controller: mileNextController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณากรอกเลขไมล์ด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกเลขไมล์ครั้งต่อไป"),
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
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                        child: InkWell(
                          splashColor: mainGreen,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (newDate == null) return;

                            setState(() => date = newDate);

                            Get.appUpdate();
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: mainGreen,
                              ),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      color: mainGreen,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        '${date.day}/${date.month}/${date.year}',
                                        style: GoogleFonts.sarabun(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '* วันเดือนปี ณ ตอนที่คุณเปลี่ยนอะไหล่ครั้งล่าสุด',
                            style: GoogleFonts.sarabun(
                              color: darkGray,
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

                              saveUpgc(
                                widget.carDetails.data!.mycarDetail!.mycarId!,
                                changePart,
                                mileNowController.text,
                                mileNextController.text,
                                date.toString(),
                              ).then((value) {
                                if (value == false) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                                    backgroundColor: Colors.yellowAccent,
                                    textColor: Colors.black,
                                  );
                                }

                                Get.offAllNamed('/profile');
                              });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Center(
              child: Text(
                'ยางรถ',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('ผ้าเบรค', 'brake_pads'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.brakePadsCal == null
                                      ? 'ผ้าเบรค 0%'
                                      : widget.carDataCal.data.brakePadsCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'ผ้าเบรค 0%'
                                          : 'ผ้าเบรค ${widget.carDataCal.data.brakePadsCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.brakePadsCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.brakePadsCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.brakePadsCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .brakePadsCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.brakePadsCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.brakePadsCal ==
                                                null
                                            ? 0
                                            : widget
                                                        .carDataCal
                                                        .data
                                                        .brakePadsCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .brakePadsCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.brakePadsCal ==
                                              null
                                          ? '0%'
                                          : widget.carDataCal.data.brakePadsCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.brakePadsCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.brakePadsCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.brakePadsCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.brakePadsCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.brakePadsCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.brakePadsCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.brakePadsCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.brakePadsCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('ยางรถ', 'car_tire'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.carTireCal == null
                                      ? 'ยางรถ 0%'
                                      : widget.carDataCal.data.carTireCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'ยางรถ 0%'
                                          : 'ยางรถ ${widget.carDataCal.data.carTireCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.carTireCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.carTireCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.carTireCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .carTireCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.carTireCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.carTireCal ==
                                                null
                                            ? 0
                                            : widget.carDataCal.data.carTireCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .carTireCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.carTireCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.carTireCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.carTireCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.carTireCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.carTireCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.carTireCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.carTireCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.carTireCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.carTireCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.carTireCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class BatteryWidgets extends StatefulWidget {
  const BatteryWidgets({
    super.key,
    required this.carDataCal,
    required this.carDetails,
  });

  final CarDataCal carDataCal;
  final MyCarDetails carDetails;

  @override
  State<BatteryWidgets> createState() => _BatteryWidgetsState();
}

class _BatteryWidgetsState extends State<BatteryWidgets> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mileNowController = TextEditingController();
  TextEditingController mileNextController = TextEditingController();

  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();

    mileNowController = TextEditingController();
    mileNextController = TextEditingController();
  }

  @override
  void dispose() {
    mileNowController.dispose();
    mileNextController.dispose();
    super.dispose();
  }

  Future<bool> saveUpgc(
    String carId,
    String problemType,
    String mileNow,
    String mileNext,
    String date,
  ) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/upgc/store"),
      body: {
        'mycar_id': carId,
        'type': problemType,
        'mile_now': mileNow,
        'mile_next': mileNext,
        'date': date,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  void showFormDialog(String title, String changePart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            title: Text(
              title,
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
                          controller: mileNowController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณากรอกเลขไมล์ด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกเลขไมล์ปัจจุบัน"),
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
                          controller: mileNextController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณากรอกเลขไมล์ด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกเลขไมล์ครั้งต่อไป"),
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
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                        child: InkWell(
                          splashColor: mainGreen,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (newDate == null) return;

                            setState(() => date = newDate);

                            Get.appUpdate();
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: mainGreen,
                              ),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      color: mainGreen,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        '${date.day}/${date.month}/${date.year}',
                                        style: GoogleFonts.sarabun(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '* วันเดือนปี ณ ตอนที่คุณเปลี่ยนอะไหล่ครั้งล่าสุด',
                            style: GoogleFonts.sarabun(
                              color: darkGray,
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

                              saveUpgc(
                                widget.carDetails.data!.mycarDetail!.mycarId!,
                                changePart,
                                mileNowController.text,
                                mileNextController.text,
                                date.toString(),
                              ).then((value) {
                                if (value == false) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                                    backgroundColor: Colors.yellowAccent,
                                    textColor: Colors.black,
                                  );
                                }

                                Get.offAllNamed('/profile');
                              });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Center(
              child: Text(
                'แบตเตอรี่',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('แบตเตอรี่', 'battery'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.batteryCal == null
                                      ? 'แบตเตอรี่ 0%'
                                      : widget.carDataCal.data.batteryCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'แบตเตอรี่ 0%'
                                          : 'แบตเตอรี่ ${widget.carDataCal.data.batteryCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.batteryCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.batteryCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.batteryCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .batteryCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.batteryCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.batteryCal ==
                                                null
                                            ? 0
                                            : widget.carDataCal.data.batteryCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .batteryCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.batteryCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.batteryCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.batteryCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.batteryCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.batteryCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.batteryCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.batteryCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.batteryCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.batteryCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.batteryCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class AirWidgets extends StatefulWidget {
  const AirWidgets({
    super.key,
    required this.carDataCal,
    required this.carDetails,
  });

  final CarDataCal carDataCal;
  final MyCarDetails carDetails;

  @override
  State<AirWidgets> createState() => _AirWidgetsState();
}

class _AirWidgetsState extends State<AirWidgets> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mileNowController = TextEditingController();
  TextEditingController mileNextController = TextEditingController();

  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();

    mileNowController = TextEditingController();
    mileNextController = TextEditingController();
  }

  @override
  void dispose() {
    mileNowController.dispose();
    mileNextController.dispose();
    super.dispose();
  }

  Future<bool> saveUpgc(
    String carId,
    String problemType,
    String mileNow,
    String mileNext,
    String date,
  ) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/upgc/store"),
      body: {
        'mycar_id': carId,
        'type': problemType,
        'mile_now': mileNow,
        'mile_next': mileNext,
        'date': date,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  void showFormDialog(String title, String changePart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            title: Text(
              title,
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
                          controller: mileNowController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณากรอกเลขไมล์ด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกเลขไมล์ปัจจุบัน"),
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
                          controller: mileNextController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณากรอกเลขไมล์ด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text("กรอกเลขไมล์ครั้งต่อไป"),
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
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                        child: InkWell(
                          splashColor: mainGreen,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (newDate == null) return;

                            setState(() => date = newDate);

                            Get.appUpdate();
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: mainGreen,
                              ),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      color: mainGreen,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        '${date.day}/${date.month}/${date.year}',
                                        style: GoogleFonts.sarabun(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '* วันเดือนปี ณ ตอนที่คุณเปลี่ยนอะไหล่ครั้งล่าสุด',
                            style: GoogleFonts.sarabun(
                              color: darkGray,
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

                              saveUpgc(
                                widget.carDetails.data!.mycarDetail!.mycarId!,
                                changePart,
                                mileNowController.text,
                                mileNextController.text,
                                date.toString(),
                              ).then((value) {
                                if (value == false) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                                    backgroundColor: Colors.yellowAccent,
                                    textColor: Colors.black,
                                  );
                                }

                                Get.offAllNamed('/profile');
                              });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Center(
              child: Text(
                'แอร์',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('น้ำยาแอร์', 'air'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.airCal == null
                                      ? 'น้ำยาแอร์ 0%'
                                      : widget.carDataCal.data.airCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'น้ำยาแอร์ 0%'
                                          : 'น้ำยาแอร์ ${widget.carDataCal.data.airCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.airCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.airCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.airCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data.airCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.airCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.airCal == null
                                            ? 0
                                            : widget.carDataCal.data.airCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget.carDataCal.data.airCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.airCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.airCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.airCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    widget.carDataCal.data.airCal == null
                                        ? 'คุณยังไม่ได้กรอกข้อมูล'
                                        : 'เริ่มต้น ${widget.carDataCal.data.airCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.airCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.airCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.airCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.airCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.airCal!.dateUpgradeNext!)}',
                                    style: GoogleFonts.sarabun(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('แผงคอยล์ร้อน', 'clean_hs'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.cleanHsCal == null
                                      ? 'แผงคอยล์ร้อน 0%'
                                      : widget.carDataCal.data.cleanHsCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'แผงคอยล์ร้อน 0%'
                                          : 'แผงคอยล์ร้อน ${widget.carDataCal.data.cleanHsCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.cleanHsCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.cleanHsCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.cleanHsCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .cleanHsCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.cleanHsCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.cleanHsCal ==
                                                null
                                            ? 0
                                            : widget.carDataCal.data.cleanHsCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .cleanHsCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.cleanHsCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.cleanHsCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.cleanHsCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.cleanHsCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.cleanHsCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.cleanHsCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.cleanHsCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.cleanHsCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.cleanHsCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.cleanHsCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                child: InkWell(
                  splashColor: mainGreen,
                  onTap: () => showFormDialog('ตัวกรองแอร์', 'change_af'),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          whiteGreen,
                          lightGreen,
                          mainGreen,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.carDataCal.data.changeAfCal == null
                                      ? 'ตัวกรองแอร์ 0%'
                                      : widget.carDataCal.data.changeAfCal!
                                                  .dateRemainAvg! <
                                              0
                                          ? 'ตัวกรองแอร์ 0%'
                                          : 'ตัวกรองแอร์ ${widget.carDataCal.data.changeAfCal!.dateRemainAvg!.toStringAsFixed(0)}%',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              ExpandablePanel(
                                header: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    lineHeight: 25,
                                    animation: true,
                                    progressColor: (() {
                                      if (widget.carDataCal.data.changeAfCal ==
                                          null) {
                                        return Colors.red;
                                      }
                                      if (widget.carDataCal.data.changeAfCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() <=
                                              100.00 &&
                                          widget.carDataCal.data.changeAfCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              50.00) {
                                        return mainGreen;
                                      } else if (widget.carDataCal.data
                                                  .changeAfCal!.dateRemainAvg!
                                                  .roundToDouble() <
                                              50.00 &&
                                          widget.carDataCal.data.changeAfCal!
                                                  .dateRemainAvg!
                                                  .roundToDouble() >=
                                              30.00) {
                                        return Colors.yellow;
                                      } else {
                                        return Colors.red;
                                      }
                                    }()),
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        widget.carDataCal.data.changeAfCal ==
                                                null
                                            ? 0
                                            : widget
                                                        .carDataCal
                                                        .data
                                                        .changeAfCal!
                                                        .dateRemainAvg! <
                                                    0
                                                ? 0
                                                : widget
                                                        .carDataCal
                                                        .data
                                                        .changeAfCal!
                                                        .dateRemainAvg!
                                                        .roundToDouble() /
                                                    100,
                                    center: Text(
                                      widget.carDataCal.data.changeAfCal == null
                                          ? '0%'
                                          : widget.carDataCal.data.changeAfCal!
                                                      .dateRemainAvg! <
                                                  0
                                              ? '0%'
                                              : '${widget.carDataCal.data.changeAfCal!.dateRemainAvg!.toStringAsFixed(2)}%',
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                                expanded: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                        widget.carDataCal.data.changeAfCal ==
                                                null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${widget.carDataCal.data.changeAfCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.changeAfCal!.dateSet!.yearInBuddhistCalendar}').format(widget.carDataCal.data.changeAfCal!.dateSet!)}\nสิ้นสุด ${widget.carDataCal.data.changeAfCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${widget.carDataCal.data.changeAfCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(widget.carDataCal.data.changeAfCal!.dateUpgradeNext!)}',
                                        style: GoogleFonts.sarabun(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                theme: const ExpandableThemeData(
                                  tapHeaderToExpand: true,
                                  tapBodyToExpand: true,
                                  tapBodyToCollapse: true,
                                  headerAlignment:
                                      ExpandablePanelHeaderAlignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
