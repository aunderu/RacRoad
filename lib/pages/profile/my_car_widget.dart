import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rac_road/models/menu_item.dart';
import 'package:http/http.dart' as http;

import 'package:rac_road/models/all_my_car.dart';
import 'package:rac_road/services/remote_service.dart';
import '../../../colors.dart';
import '../../models/data/menu_items.dart';
import '../../models/my_car_details.dart';
import 'add_car/find_car.dart';
import 'car_details.dart';

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

  bool _haveCar = false;
  bool _isMultiCar = false;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getData();

    setUpTimedFetch();
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
        _isMultiCar = myCar!.data.mycarData.length > 1;
        if (mounted) {
          setState(() {
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

  setUpTimedFetch() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      myCar = await RemoteService().getMyCar(widget.getToken);
      if (mounted) {
        setState(() {
          myCar;
        });
      }
    });
  }

  void deleteCar(String carId) async {
    var url = Uri.parse('https://api.racroad.com/api/mycar/destroy/$carId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously

      Get.toNamed('/home');
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

  void onSelected(BuildContext context, CustomMenuItem item) {
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
                  deleteCar(myCar!.data.mycarData[0].mycarId);
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
        if (!_isMultiCar) {
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
                                myCar!.data.mycarData[0].carNo,
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            PopupMenuButton<CustomMenuItem>(
                              onSelected: (item) => onSelected(context, item),
                              itemBuilder: (context) => [
                                ...CarMenuItems.itemsDelete
                                    .map(buildItem)
                                    .toList(),
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
                                  'รุ่น : ${carDetails!.data!.mycarDetail!.carModel}\nโฉม : ${carDetails!.data!.mycarDetail!.carMakeover!}\nรุ่นย่อย : ${carDetails!.data!.mycarDetail!.carSubversion!}\nเชื้อเพลิง : ${carDetails!.data!.mycarDetail!.carFuel!}',
                                  style: GoogleFonts.sarabun(),
                                ),
                              ),
                              SizedBox(
                                height: 75,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        myCar!.data.mycarData[0].carProfile,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.white,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 10, 0),
                                    child: Icon(
                                      Icons.keyboard_control,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 25, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 0),
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
                                              percent: 1,
                                              width: 100,
                                              lineHeight: 24,
                                              animation: true,
                                              progressColor: mainGreen,
                                              backgroundColor: Colors.white,
                                              center: Text(
                                                '100%',
                                                style: GoogleFonts.sarabun(
                                                  color:
                                                      const Color(0xFF2E2E2E),
                                                ),
                                              ),
                                              barRadius:
                                                  const Radius.circular(50),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 0),
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
                                              percent: 1,
                                              width: 100,
                                              lineHeight: 24,
                                              animation: true,
                                              progressColor: mainGreen,
                                              backgroundColor: Colors.white,
                                              center: Text(
                                                '100%',
                                                style: GoogleFonts.sarabun(
                                                  color:
                                                      const Color(0xFF2E2E2E),
                                                ),
                                              ),
                                              barRadius:
                                                  const Radius.circular(50),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 0),
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
                                              percent: 1,
                                              width: 100,
                                              lineHeight: 24,
                                              animation: true,
                                              progressColor: mainGreen,
                                              backgroundColor: Colors.white,
                                              center: Text(
                                                '100%',
                                                style: GoogleFonts.sarabun(
                                                  color:
                                                      const Color(0xFF2E2E2E),
                                                ),
                                              ),
                                              barRadius:
                                                  const Radius.circular(50),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 10, 0),
                                    child: Icon(
                                      Icons.keyboard_control,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 25, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 0),
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
                                              percent: 1,
                                              width: 100,
                                              lineHeight: 24,
                                              animation: true,
                                              progressColor: mainGreen,
                                              backgroundColor: Colors.white,
                                              center: Text(
                                                '100%',
                                                style: GoogleFonts.sarabun(
                                                  color:
                                                      const Color(0xFF2E2E2E),
                                                ),
                                              ),
                                              barRadius:
                                                  const Radius.circular(50),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 0),
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
                                              percent: 1,
                                              width: 100,
                                              lineHeight: 24,
                                              animation: true,
                                              progressColor: mainGreen,
                                              backgroundColor: Colors.white,
                                              center: Text(
                                                '100%',
                                                style: GoogleFonts.sarabun(
                                                  color:
                                                      const Color(0xFF2E2E2E),
                                                ),
                                              ),
                                              barRadius:
                                                  const Radius.circular(50),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 10, 0),
                                    child: Icon(
                                      Icons.keyboard_control,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 25, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 0),
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
                                              percent: 1,
                                              width: 100,
                                              lineHeight: 24,
                                              animation: true,
                                              progressColor: mainGreen,
                                              backgroundColor: Colors.white,
                                              center: Text(
                                                '100%',
                                                style: GoogleFonts.sarabun(
                                                  color:
                                                      const Color(0xFF2E2E2E),
                                                ),
                                              ),
                                              barRadius:
                                                  const Radius.circular(50),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 10, 0),
                                    child: Icon(
                                      Icons.keyboard_control,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 25, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 0),
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
                                              percent: 1,
                                              width: 100,
                                              lineHeight: 24,
                                              animation: true,
                                              progressColor: mainGreen,
                                              backgroundColor: Colors.white,
                                              center: Text(
                                                '100%',
                                                style: GoogleFonts.sarabun(
                                                  color:
                                                      const Color(0xFF2E2E2E),
                                                ),
                                              ),
                                              barRadius:
                                                  const Radius.circular(50),
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
                          () => FindCarPage(getToken: widget.getToken),
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
        } else {
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
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CarDetails(),
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
                                      'คุณต้องการลบข้อมูลรถยนต์นี้หรือไม่?');
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
                                              'ชื่อยี่ห้อรถยนต์',
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
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
