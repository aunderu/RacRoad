import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                      builder: (context) => OilWidgets(carDataCal: carDataCal),
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
                      useSafeArea: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => TireWidgets(carDataCal: carDataCal),
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
                      useSafeArea: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) =>
                          BatteryWidgets(carDataCal: carDataCal),
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
                      useSafeArea: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => AirWidgets(carDataCal: carDataCal),
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
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.cleanHsCal == null
                                            ? '0%'
                                            : '${carDataCal.data.cleanHsCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                                      .dateRemainAvg! /
                                                  100,
                                      width: 100,
                                      lineHeight: 24,
                                      animation: true,
                                      progressColor: mainGreen,
                                      backgroundColor: Colors.white,
                                      center: Text(
                                        carDataCal.data.changeAfCal == null
                                            ? '0%'
                                            : '${carDataCal.data.changeAfCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
    ],
  );
}

class OilWidgets extends StatelessWidget {
  const OilWidgets({
    super.key,
    required this.carDataCal,
  });

  final CarDataCal carDataCal;

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
                  onTap: () {},
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
                                  carDataCal.data.engineOilCal == null
                                      ? 'น้ำมันเครื่อง 0%'
                                      : 'น้ำมันเครื่อง ${carDataCal.data.engineOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        carDataCal.data.engineOilCal == null
                                            ? 0
                                            : carDataCal.data.engineOilCal!
                                                    .dateRemainAvg! /
                                                100,
                                    center: Text(
                                      carDataCal.data.engineOilCal == null
                                          ? '0%'
                                          : '${carDataCal.data.engineOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                    carDataCal.data.engineOilCal == null
                                        ? 'คุณยังไม่ได้กรอกข้อมูล'
                                        : 'เริ่มต้น ${carDataCal.data.engineOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.engineOilCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.engineOilCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.engineOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.engineOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.engineOilCal!.dateUpgradeNext!)}',
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
                  onTap: () {},
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
                                  carDataCal.data.brakeOilCal == null
                                      ? 'น้ำมันเบรก 0%'
                                      : 'น้ำมันเบรก ${carDataCal.data.brakeOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.brakeOilCal == null
                                        ? 0
                                        : carDataCal.data.brakeOilCal!
                                                .dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.brakeOilCal == null
                                          ? '0%'
                                          : '${carDataCal.data.brakeOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.brakeOilCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.brakeOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.brakeOilCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.brakeOilCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.brakeOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.brakeOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.brakeOilCal!.dateUpgradeNext!)}',
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
                  onTap: () {},
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
                                  carDataCal.data.powerOilCal == null
                                      ? 'น้ำมันเพาเวอร์ 0%'
                                      : 'น้ำมันเพาเวอร์ ${carDataCal.data.powerOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.powerOilCal == null
                                        ? 0
                                        : carDataCal.data.powerOilCal!
                                                .dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.powerOilCal == null
                                          ? '0%'
                                          : '${carDataCal.data.powerOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.powerOilCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.powerOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.powerOilCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.powerOilCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.powerOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.powerOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.powerOilCal!.dateUpgradeNext!)}',
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
                  onTap: () {},
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
                                  carDataCal.data.gearOilCal == null
                                      ? 'น้ำมันเกียร์ 0%'
                                      : 'น้ำมันเกียร์ ${carDataCal.data.gearOilCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.gearOilCal == null
                                        ? 0
                                        : carDataCal.data.gearOilCal!
                                                .dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.gearOilCal == null
                                          ? '0%'
                                          : '${carDataCal.data.gearOilCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.gearOilCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.gearOilCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.gearOilCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.gearOilCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.gearOilCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.gearOilCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.gearOilCal!.dateUpgradeNext!)}',
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

class TireWidgets extends StatelessWidget {
  const TireWidgets({
    super.key,
    required this.carDataCal,
  });

  final CarDataCal carDataCal;

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
                  onTap: () {},
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
                                  carDataCal.data.brakePadsCal == null
                                      ? 'ผ้าเบรค 0%'
                                      : 'ผ้าเบรค ${carDataCal.data.brakePadsCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent:
                                        carDataCal.data.brakePadsCal == null
                                            ? 0
                                            : carDataCal.data.brakePadsCal!
                                                    .dateRemainAvg! /
                                                100,
                                    center: Text(
                                      carDataCal.data.brakePadsCal == null
                                          ? '0%'
                                          : '${carDataCal.data.brakePadsCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.brakePadsCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.brakePadsCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.brakePadsCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.brakePadsCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.brakePadsCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.brakePadsCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.brakePadsCal!.dateUpgradeNext!)}',
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
                  onTap: () {},
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
                                  carDataCal.data.carTireCal == null
                                      ? 'ยางรถ 0%'
                                      : 'ยางรถ ${carDataCal.data.carTireCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.carTireCal == null
                                        ? 0
                                        : carDataCal.data.carTireCal!
                                                .dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.carTireCal == null
                                          ? '0%'
                                          : '${carDataCal.data.carTireCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.carTireCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.carTireCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.carTireCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.carTireCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.carTireCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.carTireCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.carTireCal!.dateUpgradeNext!)}',
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

class BatteryWidgets extends StatelessWidget {
  const BatteryWidgets({
    super.key,
    required this.carDataCal,
  });

  final CarDataCal carDataCal;

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
                  onTap: () {},
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
                                  carDataCal.data.batteryCal == null
                                      ? 'แบตเตอรี่ 0%'
                                      : 'แบตเตอรี่ ${carDataCal.data.batteryCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.batteryCal == null
                                        ? 0
                                        : carDataCal.data.batteryCal!
                                                .dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.batteryCal == null
                                          ? '0%'
                                          : '${carDataCal.data.batteryCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.batteryCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.batteryCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.batteryCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.batteryCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.batteryCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.batteryCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.batteryCal!.dateUpgradeNext!)}',
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

class AirWidgets extends StatelessWidget {
  const AirWidgets({
    super.key,
    required this.carDataCal,
  });

  final CarDataCal carDataCal;

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
                  onTap: () {},
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
                                  carDataCal.data.airCal == null
                                      ? 'น้ำยาแอร์ 0%'
                                      : 'น้ำยาแอร์ ${carDataCal.data.airCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.airCal == null
                                        ? 0
                                        : carDataCal
                                                .data.airCal!.dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.airCal == null
                                          ? '0%'
                                          : '${carDataCal.data.airCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                    carDataCal.data.airCal == null
                                        ? 'คุณยังไม่ได้กรอกข้อมูล'
                                        : 'เริ่มต้น ${carDataCal.data.airCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.airCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.airCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.airCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.airCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.airCal!.dateUpgradeNext!)}',
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
                  onTap: () {},
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
                                  carDataCal.data.cleanHsCal == null
                                      ? 'แผงคอยล์ร้อน 0%'
                                      : 'แผงคอยล์ร้อน ${carDataCal.data.cleanHsCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.cleanHsCal == null
                                        ? 0
                                        : carDataCal.data.cleanHsCal!
                                                .dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.cleanHsCal == null
                                          ? '0%'
                                          : '${carDataCal.data.cleanHsCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.cleanHsCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.cleanHsCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.cleanHsCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.cleanHsCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.cleanHsCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.cleanHsCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.cleanHsCal!.dateUpgradeNext!)}',
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
                  onTap: () {},
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
                                  carDataCal.data.changeAfCal == null
                                      ? 'ตัวกรองแอร์ 0%'
                                      : 'ตัวกรองแอร์ ${carDataCal.data.changeAfCal!.dateRemainAvg!.toStringAsFixed(0)}%',
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
                                    progressColor: mainGreen,
                                    barRadius: const Radius.circular(50),
                                    percent: carDataCal.data.changeAfCal == null
                                        ? 0
                                        : carDataCal.data.changeAfCal!
                                                .dateRemainAvg! /
                                            100,
                                    center: Text(
                                      carDataCal.data.changeAfCal == null
                                          ? '0%'
                                          : '${carDataCal.data.changeAfCal!.dateRemainAvg!.toStringAsFixed(2)}%',
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
                                        carDataCal.data.changeAfCal == null
                                            ? 'คุณยังไม่ได้กรอกข้อมูล'
                                            : 'เริ่มต้น ${carDataCal.data.changeAfCal!.mileNow} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.changeAfCal!.dateSet!.yearInBuddhistCalendar}').format(carDataCal.data.changeAfCal!.dateSet!)}\nสิ้นสุด ${carDataCal.data.changeAfCal!.mileNext} ไมน์ วันที่ ${DateFormat('d MMMM ${carDataCal.data.changeAfCal!.dateUpgradeNext!.yearInBuddhistCalendar}').format(carDataCal.data.changeAfCal!.dateUpgradeNext!)}',
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
