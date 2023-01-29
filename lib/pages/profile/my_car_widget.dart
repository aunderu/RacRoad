import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rac_road/models/menu_item.dart';
import 'package:http/http.dart' as http;

import 'package:rac_road/models/my_car_models.dart';
import 'package:rac_road/services/remote_service.dart';
import '../../../colors.dart';
import '../../models/data/menu_items.dart';
import 'add_car/add_car.dart';
import 'car_details.dart';

class MyCarWidget extends StatefulWidget {
  final String getToken;
  const MyCarWidget({super.key, required this.getToken});

  @override
  State<MyCarWidget> createState() => _MyCarWidgetState();
}

class _MyCarWidgetState extends State<MyCarWidget> {
  AllMyCar? myCar;
  bool isLoaded = true;
  bool _haveCar = false;
  final bool _isMultiCar = false;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getData(widget.getToken);
  }

  getData(String token) async {
    setState(() {
      isLoaded == true;
    });
    myCar = await RemoteService().getMyCar(token);
    if (myCar != null) {
      final bool? haveData = myCar?.data!.mycarData?.isNotEmpty;
      if (haveData == true) {
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

  void deleteCar(String carId) async {
    var url = Uri.parse('https://api.racroad.com/api/mycar/destroy/$carId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously

      Get.toNamed('/profile');
      Fluttertoast.showToast(
        msg: "คุณได้ลบคลับนี้แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
                                myCar!.data!.mycarData![0].carBrand!,
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
                                  'รุ่น : ${myCar!.data!.mycarData![0].carModel!}\nโฉม : ${myCar!.data!.mycarData![0].carMakeover!}\nรุ่นย่อย : ${myCar!.data!.mycarData![0].carSubversion!}\nเชื้อเพลิง : ${myCar!.data!.mycarData![0].carFuel!}',
                                  style: GoogleFonts.sarabun(),
                                ),
                              ),
                              SizedBox(
                                height: 75,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                  // child: Image.network(
                                  //   "",
                                  //   fit: BoxFit.fill,
                                  // ),
                                  child: Container(
                                    color: Colors.white,
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
                      onTap: () {},
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
            child: ListView(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarDetails(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x411D2429),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 1, 1, 1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                // child: Image.network(
                                //   '',
                                //   width: 80,
                                //   height: 80,
                                //   fit: BoxFit.cover,
                                // ),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 8, 4, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Car Title',
                                      style: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 4, 8, 0),
                                      child: AutoSizeText(
                                        'Subtext',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarDetails(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x411D2429),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 1, 1, 1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                // child: Image.network(
                                //   '',
                                //   width: 80,
                                //   height: 80,
                                //   fit: BoxFit.cover,
                                // ),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 8, 4, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Car Title',
                                      style: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 4, 8, 0),
                                      child: AutoSizeText(
                                        'Subtext',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarDetails(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x411D2429),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 1, 1, 1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                // child: Image.network(
                                //   '',
                                //   width: 80,
                                //   height: 80,
                                //   fit: BoxFit.cover,
                                // ),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 8, 4, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Car Title',
                                      style: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 4, 8, 0),
                                      child: AutoSizeText(
                                        'Subtext',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddCarPage(getToken: widget.getToken),
                    ),
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
                  deleteCar(myCar!.data!.mycarData![0].mycarId!);
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
}
