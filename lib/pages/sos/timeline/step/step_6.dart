import 'dart:convert';
import 'dart:io';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../colors.dart';
import '../../../../../models/data/timeline_models.dart';
import '../../../../models/sos/sos_details_models.dart';

class StepSix extends StatefulWidget {
  const StepSix({
    super.key,
    required this.getToken,
    required this.sosId,
    required this.stepOnetimeStamp,
    required this.userName,
    required this.userTel,
    required this.problem,
    required this.problemDetails,
    required this.location,
    required this.userProfile,
    required this.imgIncident,
    required this.stepTwoTimeStamp,
    required this.stepThreeTimeStamp,
    required this.stepFourTimeStamp,
    required this.stepFiveTimeStamp,
    required this.stepSixTimeStamp,
    required this.repairPrice,
    required this.repairDetails,
    required this.tncName,
    required this.tncStatus,
    this.tncProfile,
    required this.imgBfwork,
    required this.imgAfwork,
    required this.qrCode,
    this.repairDetailsTwo,
    this.repairPriceTwo,
    this.tuPriceTwoTimeStamp,
    this.tuUserDealTwoTimeStamp,
    this.userDealTwo,
    required this.qrName,
    required this.qrType,
    required this.qrNumber,
    required this.priceTwoStatus,
  });

  final String getToken;
  final String sosId;
  final List<Img> imgAfwork;
  final List<Img> imgBfwork;
  final List<Img> imgIncident;
  final String location;
  final String problem;
  final String problemDetails;
  final String repairDetails;
  final String? repairDetailsTwo;
  final String repairPrice;
  final String? repairPriceTwo;
  final DateTime stepSixTimeStamp;
  final DateTime stepFiveTimeStamp;
  final DateTime stepFourTimeStamp;
  final DateTime stepOnetimeStamp;
  final DateTime stepThreeTimeStamp;
  final DateTime stepTwoTimeStamp;
  final String tncName;
  final String? tncProfile;
  final String tncStatus;
  final DateTime? tuPriceTwoTimeStamp;
  final DateTime? tuUserDealTwoTimeStamp;
  final String? userDealTwo;
  final String userName;
  final String userProfile;
  final String userTel;
  final String qrCode;
  final String qrName;
  final String qrType;
  final String qrNumber;
  final String priceTwoStatus;

  @override
  State<StepSix> createState() => _StepSixState();
}

class _StepSixState extends State<StepSix> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  File? imageFile;
  double rating = 0;
  late List<Timelines> timelines;
  TextEditingController? userReviewController;
  final imageUserController = PageController();
  final imageBfController = PageController();
  final imageAfController = PageController();

  @override
  void initState() {
    super.initState();
    userReviewController = TextEditingController();

    getTimelines();
  }

  void getTimelines() {
    timelines = [
      Timelines(
        widget.stepOnetimeStamp,
        "แจ้งเหตุการณ์",
        Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "ปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}",
                style: GoogleFonts.sarabun(),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView.builder(
                      controller: imageUserController,
                      itemCount: widget.imgIncident.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: widget.imgIncident[index].image,
                          height: 200,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SmoothPageIndicator(
                    controller: imageUserController,
                    count: widget.imgIncident.length,
                    effect: const WormEffect(
                      spacing: 20,
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: mainGreen,
                      dotColor: Colors.black26,
                    ),
                    onDotClicked: (index) => imageUserController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
      Timelines(
        widget.stepTwoTimeStamp,
        "เสนอบริการค่าซ่อม",
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายละเอียดเพิ่มเติม :',
                  style: GoogleFonts.sarabun(),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.repairDetails,
                  style: GoogleFonts.sarabun(),
                ),
                const SizedBox(height: 15),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'รวมทั้งหมด :',
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                    Text(
                      "${widget.repairPrice} บาท",
                      style: GoogleFonts.sarabun(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        widget.stepThreeTimeStamp,
        "ฉันยืนยันรับข้อเสนอดังกล่าว",
        Text(
          "ฉันได้ยืนยันค่าบริการ จำนวน ${widget.repairPrice} บาท",
          style: GoogleFonts.sarabun(),
        ),
        widget.userProfile,
        widget.userName,
        "1",
      ),
      Timelines(
        widget.stepThreeTimeStamp,
        "เรียบร้อย! เรากำลังหาช่างในพื้นที่ใกล้เคียงให้คุณ",
        Text(
          "โปรดรอสักครู่",
          style: GoogleFonts.sarabun(),
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        widget.stepFourTimeStamp,
        "ช่างที่เลือก",
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: CachedNetworkImage(
                      imageUrl: widget.tncProfile!,
                      height: 250,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/imgs/profile.png',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.tncName,
                  style: GoogleFonts.sarabun(),
                ),
              ],
            ),
          ),
        ),
        "assets/imgs/oparator.png",
        "เจ้าหน้าที่ Racroad",
        "2",
      ),
      Timelines(
        widget.stepFourTimeStamp,
        "ช่างรับงานและออกปฎิบัติงาน",
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
              child: Text(
                'สถานะ : ช่างถึงหน้างานเเล้ว',
                style: GoogleFonts.sarabun(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                  child: Text(
                    'รูปก่อนเริ่มงาน : ',
                    style: GoogleFonts.sarabun(),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: PageView.builder(
                          controller: imageBfController,
                          itemCount: widget.imgBfwork.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.imgBfwork[index].image,
                              height: 250,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SmoothPageIndicator(
                        controller: imageBfController,
                        count: widget.imgBfwork.length,
                        effect: const WormEffect(
                          spacing: 20,
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: mainGreen,
                          dotColor: Colors.black26,
                        ),
                        onDotClicked: (index) =>
                            imageBfController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        widget.tncProfile!,
        widget.tncName,
        "3",
      ),
    ].toList();

    isUserDeal();
  }

  @override
  void dispose() {
    imageUserController.dispose();
    imageBfController.dispose();
    imageAfController.dispose();

    super.dispose();
  }

  void isUserDeal() {
    if (widget.priceTwoStatus == "yes") {
      setState(() {
        timelines.addAll([
          Timelines(
            widget.tuPriceTwoTimeStamp!,
            "เนื่องจากมีการเสนอค่าบริการใหม่ นี้คือข้อเสนอบริการค่าซ่อมก่อนเริ่มงาน",
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายละเอียดเพิ่มเติม :',
                      style: GoogleFonts.sarabun(),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.repairDetailsTwo!,
                      style: GoogleFonts.sarabun(),
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'รวมทั้งหมด :',
                            style: GoogleFonts.sarabun(),
                          ),
                        ),
                        Text(
                          "${widget.repairPriceTwo} บาท",
                          style: GoogleFonts.sarabun(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            "assets/imgs/oparator.png",
            "เจ้าหน้าที่ Racroad",
            "2",
          ),
          Timelines(
            widget.tuUserDealTwoTimeStamp!,
            "ฉันยืนยันรับข้อเสนอดังกล่าว",
            Text(
              "ฉันได้ยืนยันค่าบริการ จำนวน ${widget.repairPriceTwo} บาท",
              style: GoogleFonts.sarabun(),
            ),
            widget.userProfile,
            widget.userName,
            "1",
          ),
          Timelines(
            widget.stepFiveTimeStamp,
            "เสร็จสิ้นงาน",
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                  child: Text(
                    'สถานะ : ${widget.tncStatus}',
                    style: GoogleFonts.sarabun(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                      child: Text(
                        'รูปหลังเสร็จงาน : ',
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: PageView.builder(
                              controller: imageAfController,
                              itemCount: widget.imgAfwork.length,
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: widget.imgAfwork[index].image,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SmoothPageIndicator(
                            controller: imageAfController,
                            count: widget.imgAfwork.length,
                            effect: const WormEffect(
                              spacing: 20,
                              dotHeight: 10,
                              dotWidth: 10,
                              activeDotColor: mainGreen,
                              dotColor: Colors.black26,
                            ),
                            onDotClicked: (index) =>
                                imageAfController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.tncProfile!,
            widget.tncName,
            "3",
          ),
          Timelines(
            widget.stepSixTimeStamp,
            "QR Code สำหรับโอน",
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "คุณสามารถกดค้างที่รูป เพื่อดาวห์โหลด QR Code นี้",
                  style: GoogleFonts.sarabun(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                    child: InkWell(
                      onLongPress: () async {
                        await GallerySaver.saveImage(widget.qrCode);
                        Fluttertoast.showToast(
                          msg: "โหลด QR Code เรียบร้อย",
                          fontSize: 18,
                          backgroundColor: mainGreen,
                          textColor: Colors.white,
                        );
                      },
                      child: Ink(
                        child: CachedNetworkImage(
                          imageUrl: widget.qrCode.toString(),
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "ชื่อบัญชี : ${widget.qrName}\nเลขบัญชี : ${widget.qrNumber}\nประเภทบัญชี : ${widget.qrType}",
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            "assets/imgs/oparator.png",
            "เจ้าหน้าที่ Racroad",
            "2",
          ),
          Timelines(
            DateTime.now(),
            "สลิปโอนเงินค่าบริการและรีวิว",
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'รีวิวช่าง',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  controller: userReviewController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'เล่าประสบการณ์บริการกับช่างคนนี้',
                    hintStyle: GoogleFonts.sarabun(),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
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
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                  ),
                  style: GoogleFonts.sarabun(),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 10),
                Text(
                  'สลิปการโอนของคุณ',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                imageFile == null
                    ? Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            child: InkWell(
                              onTap: () async {
                                PermissionStatus cameraStatus =
                                    await Permission.camera.request();
                                if (cameraStatus == PermissionStatus.granted) {
                                  getFromGallery();
                                }
                                if (cameraStatus == PermissionStatus.denied) {
                                  Fluttertoast.showToast(
                                      msg: "This permission is recommended");
                                }
                                if (cameraStatus ==
                                    PermissionStatus.permanentlyDenied) {
                                  openAppSettings();
                                }
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEFEFEF),
                                ),
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  color: Color(0xFF9D9D9D),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: InkWell(
                            onTap: getFromGallery,
                            child: Image.file(
                              imageFile!,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: RatingBar.builder(
                      minRating: 1,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      updateOnDrag: true,
                      onRatingUpdate: (rating) => setState(() {
                        this.rating = rating;
                      }),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (imageFile != null) {
                        if (userReviewController!.text == "") {
                          if (rating == 0) {
                            sosPayAndReview(
                              widget.sosId,
                              "ผู้ใช้ไม่ได้ให้ดาวช่าง",
                              "ผู้ใช้ไม่ได้มีการรีวิวช่าง",
                              imageFile!.path,
                            );
                          } else {
                            sosPayAndReview(
                              widget.sosId,
                              rating.toString(),
                              "ผู้ใช้ไม่ได้มีการรีวิวช่าง",
                              imageFile!.path,
                            );
                          }
                        } else {
                          if (rating != 0) {
                            sosPayAndReview(
                              widget.sosId,
                              rating.toString(),
                              userReviewController!.text,
                              imageFile!.path,
                            );
                          } else {
                            sosPayAndReview(
                              widget.sosId,
                              "ผู้ใช้ไม่ได้ให้ดาวช่าง",
                              userReviewController!.text,
                              imageFile!.path,
                            );
                          }
                        }

                        Get.offAllNamed('/sos');

                        Fluttertoast.showToast(
                          msg: "ส่งสลิปโอนเงินค่าบริการและรีวิว เรียบร้อย!",
                          backgroundColor: mainGreen,
                          fontSize: 17,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "กรุณาแนบสลิปด้วย",
                          backgroundColor: Colors.yellow[100],
                          fontSize: 17,
                          textColor: Colors.black,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      minimumSize: const Size(
                        200,
                        40,
                      ),
                    ),
                    child: Text(
                      'ยืนยันส่ง',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            widget.userProfile,
            widget.userName,
            "1",
          ),
        ]);
      });
    } else {
      setState(() {
        timelines.addAll([
          Timelines(
            widget.stepFiveTimeStamp,
            "เสร็จสิ้นงาน",
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                  child: Text(
                    'สถานะ : ${widget.tncStatus}',
                    style: GoogleFonts.sarabun(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                      child: Text(
                        'รูปหลังเสร็จงาน : ',
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: PageView.builder(
                              controller: imageAfController,
                              itemCount: widget.imgAfwork.length,
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: widget.imgAfwork[index].image,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SmoothPageIndicator(
                            controller: imageAfController,
                            count: widget.imgAfwork.length,
                            effect: const WormEffect(
                              spacing: 20,
                              dotHeight: 10,
                              dotWidth: 10,
                              activeDotColor: mainGreen,
                              dotColor: Colors.black26,
                            ),
                            onDotClicked: (index) =>
                                imageAfController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.tncProfile!,
            widget.tncName,
            "3",
          ),
          Timelines(
            widget.stepSixTimeStamp,
            "QR Code สำหรับโอน",
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "คุณสามารถกดค้างที่รูป เพื่อดาวห์โหลด QR Code นี้",
                  style: GoogleFonts.sarabun(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                    child: InkWell(
                      onLongPress: () async {
                        await GallerySaver.saveImage(widget.qrCode);
                        Fluttertoast.showToast(
                          msg: "โหลด QR Code เรียบร้อย",
                          fontSize: 18,
                          backgroundColor: mainGreen,
                          textColor: Colors.white,
                        );
                      },
                      child: Ink(
                        child: CachedNetworkImage(
                          imageUrl: widget.qrCode.toString(),
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "ชื่อบัญชี : ${widget.qrName}\nเลขบัญชี : ${widget.qrNumber}\nประเภทบัญชี : ${widget.qrType}",
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            "assets/imgs/oparator.png",
            "เจ้าหน้าที่ Racroad",
            "2",
          ),
          Timelines(
            DateTime.now(),
            "สลิปโอนเงินค่าบริการและรีวิว",
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'รีวิวช่าง',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  controller: userReviewController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'เล่าประสบการณ์บริการกับช่างคนนี้',
                    hintStyle: GoogleFonts.sarabun(),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
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
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                  ),
                  style: GoogleFonts.sarabun(),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 10),
                Text(
                  'สลิปการโอนของคุณ',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                imageFile == null
                    ? Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            child: InkWell(
                              onTap: () async {
                                PermissionStatus cameraStatus =
                                    await Permission.camera.request();
                                if (cameraStatus == PermissionStatus.granted) {
                                  getFromGallery();
                                }
                                if (cameraStatus == PermissionStatus.denied) {
                                  Fluttertoast.showToast(
                                      msg: "This permission is recommended");
                                }
                                if (cameraStatus ==
                                    PermissionStatus.permanentlyDenied) {
                                  openAppSettings();
                                }
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEFEFEF),
                                ),
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  color: Color(0xFF9D9D9D),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: InkWell(
                            onTap: getFromGallery,
                            child: Image.file(
                              imageFile!,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: RatingBar.builder(
                      minRating: 1,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      updateOnDrag: true,
                      onRatingUpdate: (rating) => setState(() {
                        this.rating = rating;
                      }),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (imageFile != null) {
                        if (userReviewController!.text == "") {
                          if (rating == 0) {
                            sosPayAndReview(
                              widget.sosId,
                              "ผู้ใช้ไม่ได้ให้ดาวช่าง",
                              "ผู้ใช้ไม่ได้มีการรีวิวช่าง",
                              imageFile!.path,
                            );
                          } else {
                            sosPayAndReview(
                              widget.sosId,
                              rating.toString(),
                              "ผู้ใช้ไม่ได้มีการรีวิวช่าง",
                              imageFile!.path,
                            );
                          }
                        } else {
                          if (rating != 0) {
                            sosPayAndReview(
                              widget.sosId,
                              rating.toString(),
                              userReviewController!.text,
                              imageFile!.path,
                            );
                          } else {
                            sosPayAndReview(
                              widget.sosId,
                              "ผู้ใช้ไม่ได้ให้ดาวช่าง",
                              userReviewController!.text,
                              imageFile!.path,
                            );
                          }
                        }

                        Get.offAllNamed('/sos');

                        Fluttertoast.showToast(
                          msg: "ส่งสลิปโอนเงินค่าบริการและรีวิว เรียบร้อย!",
                          backgroundColor: mainGreen,
                          fontSize: 17,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "กรุณาแนบสลิปด้วย",
                          backgroundColor: Colors.yellow[100],
                          fontSize: 17,
                          textColor: Colors.black,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      minimumSize: const Size(
                        200,
                        40,
                      ),
                    ),
                    child: Text(
                      'ยืนยันส่ง',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            widget.userProfile,
            widget.userName,
            "1",
          ),
        ]);
      });
    }
  }

  void getFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        getTimelines();
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
  }

  Future<bool> sosPayAndReview(
    String sosId,
    String userRating,
    String userReview,
    String imgPath,
  ) async {
    Map<String, String> headers = {"Context-Type": "multipart/formdata"};
    var requset = http.MultipartRequest(
        "POST", Uri.parse("https://api.racroad.com/api/sos/step/$sosId"))
      ..fields.addAll({
        "rate": userRating,
        "review": userReview,
      })
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', imgPath));
    var response = await requset.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: basicFormKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GroupedListView<Timelines, DateTime>(
          elements: timelines,
          reverse: true,
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          floatingHeader: true,
          shrinkWrap: true,
          groupBy: (timelines) => DateTime(
            timelines.timestamp.month,
            timelines.timestamp.day,
            timelines.timestamp.hour,
          ),
          groupHeaderBuilder: (Timelines timelines) => SizedBox(
            height: 40,
            child: Center(
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    DateFormat(
                            'd MMMM ${timelines.timestamp.yearInBuddhistCalendar}  เวลา hh:mm')
                        .format(timelines.timestamp),
                    style: GoogleFonts.sarabun(
                      color: darkGray,
                    ),
                  ),
                ),
              ),
            ),
          ),
          itemBuilder: (context, Timelines timelines) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: timelines.isSentByMe == "1"
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                timelines.isSentByMe == "1"
                    ? Row(
                        children: [
                          Text(
                            DateFormat('KK:mm').format(timelines.timestamp),
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                    : const SizedBox.shrink(),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(12.0),
                      bottomRight: timelines.isSentByMe == "1"
                          ? const Radius.circular(0)
                          : const Radius.circular(12.0),
                      topLeft: const Radius.circular(12.0),
                      bottomLeft: timelines.isSentByMe != "1"
                          ? const Radius.circular(0)
                          : const Radius.circular(12.0),
                    ),
                  ),
                  color: ((() {
                    if (timelines.isSentByMe == "1") {
                      return const Color.fromARGB(255, 182, 235, 255);
                    } else if (timelines.isSentByMe == "2") {
                      return const Color.fromARGB(255, 185, 195, 255);
                    } else if (timelines.isSentByMe == "3") {
                      return const Color.fromARGB(255, 255, 239, 185);
                    } else {
                      return const Color.fromARGB(255, 185, 195, 255);
                    }
                  })()),
                  elevation: 8,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 20, 0),
                                    child: Text(
                                      timelines.title!,
                                      style: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: Divider(
                                      thickness: 1,
                                      color: Color(0x392E2E2E),
                                    ),
                                  ),
                                  timelines.body,
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: timelines.isSentByMe != "2"
                                          ? CachedNetworkImage(
                                              imageUrl: timelines.profile,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      "assets/imgs/profile.png"),
                                            )
                                          : Image.asset(timelines.profile),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8, 0, 0, 0),
                                      child: Text(
                                        timelines.name,
                                        style: GoogleFonts.sarabun(),
                                      ),
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
                timelines.isSentByMe != "1"
                    ? Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('KK:mm').format(timelines.timestamp),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
