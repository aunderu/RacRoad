import 'dart:convert';
import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:rac_road/colors.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({super.key, required this.getToken});

  final String getToken;

  @override
  State<CreateClubPage> createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  int activeIndex = 0;
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  TextEditingController? clubDescriptionController;
  TextEditingController? clubNameController;
  TextEditingController? clubZoneController;
  List<String> pickInterest = [
    "กลุ่มพูดคุย",
    "ชื่อขาย",
    "แลกเปลี่ยนข้อมูล",
    "อื่น ๆ",
  ];
  List<String> _isSelected = [];
  int totalIndex = 5;
  File? imageFile;

  int _itemTotal = 0;

  @override
  void dispose() {
    clubNameController?.dispose();
    clubDescriptionController?.dispose();
    clubZoneController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    clubNameController = TextEditingController();
    clubDescriptionController = TextEditingController();
    clubZoneController = TextEditingController();
  }

  void showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('กรุณาเลือกรูปคลับของคุณ',
              textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.sarabun(
            color: Colors.black,
            fontSize: 20,
          ),
          alignment: Alignment.center,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  getFromCamera();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'กล้อง',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  getFromGallery();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'รูปภาพ',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
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
    Get.back();
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
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
    Get.back();
  }

  Future<bool> clubSubmit() async {
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

    Map<String, String> headers = {
      'Content-type': 'multipart/form-data',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse("https://api.racroad.com/api/club/store"))
      ..headers.addAll(headers)
      ..fields.addAll({
        'user_id': widget.getToken,
        'club_name': clubNameController!.text,
        'description': clubDescriptionController!.text,
        'club_zone': clubZoneController!.text,
      });

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'club_profile',
          imageFile!.path,
        ),
      );
    }

    for (var i = 0; i < _isSelected.length; i++) {
      request.fields.addAll({
        'tags[$i]': _isSelected[i],
      });
    }

    var response = await request.send();

    Get.back();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  Widget bodyBuilder(Size size) {
    switch (activeIndex) {
      case 0:
        return formClubName();
      case 1:
        return formClubDescription();
      case 2:
        return formClubZone();
      case 3:
        return formClubTags(size);
      case 4:
        return finishClubDetails();
      default:
        return formClubName();
    }
  }

  Widget formClubName() {
    return Form(
      key: basicFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotStepper(
                  indicatorDecoration: const IndicatorDecoration(
                    color: mainGreen,
                  ),
                  tappingEnabled: false,
                  activeStep: activeIndex,
                  dotCount: totalIndex,
                  dotRadius: 20.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                ),
                const SizedBox(height: 10),
                Text(
                  'ตั้งชื่อคลับของคุณ',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'คุณอาจใช้ชื่อรถที่คุณรัก เพื่อดึงดูดคนที่มีความสนใจเดียวกับคุณและร่วมพูดคุยแลกเปลี่ยนร่วมกัน',
                  style: GoogleFonts.sarabun(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: clubNameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อคลับ',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 204, 232, 255),
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
                ),
                validator: MultiValidator([
                  RequiredValidator(
                    errorText: "กรุณากรอกชื่อคลับด้วย",
                  ),
                  MinLengthValidator(
                    4,
                    errorText: "ชื่อคลับห้ามต่ำกว่า 3 ตัวอักษร",
                  )
                ]),
                style: GoogleFonts.sarabun(),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (basicFormKey.currentState?.validate() ?? false) {
                  // next
                  setState(() {
                    activeIndex++;
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
                'ถัดไป',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formClubDescription() {
    return Form(
      key: basicFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotStepper(
                  indicatorDecoration: const IndicatorDecoration(
                    color: mainGreen,
                  ),
                  tappingEnabled: false,
                  activeStep: activeIndex,
                  dotCount: totalIndex,
                  dotRadius: 20.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                ),
                const SizedBox(height: 10),
                Text(
                  'อธิบายคลับของคุณสักหน่อย',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'คำอธิบายคลับเป็นสิ่งที่ทำให้ผู้ที่สนใจคลับของคุณรู้ว่าคลับของคุณเกี่ยวกับสิ่งใด',
                  style: GoogleFonts.sarabun(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: clubDescriptionController,
                decoration: InputDecoration(
                  labelText: 'คำอธิบายคลับ',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 204, 232, 255),
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
                ),
                validator: RequiredValidator(
                  errorText: "กรุณากรอกคำอธิบายคลับด้วย",
                ),
                style: GoogleFonts.sarabun(),
                maxLines: 4,
                // expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ),
          // const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ปุ่มย้อนกลับ
                ElevatedButton(
                  onPressed: () {
                    // back
                    setState(() {
                      activeIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainRed,
                    minimumSize: const Size(
                      150,
                      40,
                    ),
                  ),
                  child: Text(
                    'ย้อนกลับ',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ปุ่มถัดไป
                ElevatedButton(
                  onPressed: () {
                    if (basicFormKey.currentState?.validate() ?? false) {
                      // next
                      setState(() {
                        activeIndex++;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                    minimumSize: const Size(
                      150,
                      40,
                    ),
                  ),
                  child: Text(
                    'ถัดไป',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formClubZone() {
    return Form(
      key: basicFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotStepper(
                  indicatorDecoration: const IndicatorDecoration(
                    color: mainGreen,
                  ),
                  tappingEnabled: false,
                  activeStep: activeIndex,
                  dotCount: totalIndex,
                  dotRadius: 20.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                ),
                const SizedBox(height: 10),
                Text(
                  'โซนของคลับคุณ',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'โซนที่ตั้งคลับของคุณ ช่วยดึงดูดให้คนใกล้เคียงเข้าคลับได้',
                  style: GoogleFonts.sarabun(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: clubZoneController,
                decoration: InputDecoration(
                  labelText: 'โซนของคลับ',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 204, 232, 255),
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
                ),
                validator: MultiValidator([
                  RequiredValidator(
                    errorText: "กรุณากรอกโซนของคลับด้วย",
                  ),
                  MinLengthValidator(
                    4,
                    errorText: "โซนของคลับห้ามต่ำกว่า 3 ตัวอักษร",
                  )
                ]),
                style: GoogleFonts.sarabun(),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ปุ่มย้อนกลับ
                ElevatedButton(
                  onPressed: () {
                    // back
                    setState(() {
                      activeIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainRed,
                    minimumSize: const Size(
                      150,
                      40,
                    ),
                  ),
                  child: Text(
                    'ย้อนกลับ',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ปุ่มถัดไป
                ElevatedButton(
                  onPressed: () {
                    if (basicFormKey.currentState?.validate() ?? false) {
                      // next
                      setState(() {
                        activeIndex++;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                    minimumSize: const Size(
                      150,
                      40,
                    ),
                  ),
                  child: Text(
                    'ถัดไป',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formClubTags(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotStepper(
                  indicatorDecoration: const IndicatorDecoration(
                    color: mainGreen,
                  ),
                  tappingEnabled: false,
                  activeStep: activeIndex,
                  dotCount: totalIndex,
                  dotRadius: 20.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                ),
                const SizedBox(height: 10),
                Text(
                  'คุณคิดว่าคลับ ${clubNameController!.text} ของคุณอยู่หมวดหมู่อะไร',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'หมวดหมู่จะช่วยให้คนที่มีความสนใจเดียวกันหาเจอได้ง่ายขึ้น คุณสามารถเลือกได้สูงสุด 3 หมวดหมู่',
                  style: GoogleFonts.sarabun(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
              child: ChipsChoice<String>.multiple(
                value: _isSelected,
                onChanged: (value) {
                  if (value.length <= 3) {
                    setState(() {
                      _isSelected = value;
                    });
                  }
                },
                choiceItems: C2Choice.listFrom(
                  source: pickInterest,
                  value: (index, item) => item,
                  label: (index, item) => item,
                ),
                choiceCheckmark: true,
                choiceStyle: C2ChipStyle.toned(
                  selectedStyle: const C2ChipStyle(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    foregroundColor: mainGreen,
                    backgroundColor: mainGreen,
                  ),
                ),
                wrapped: true,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ปุ่มย้อนกลับ
                ElevatedButton(
                  onPressed: () {
                    // back
                    setState(() {
                      activeIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainRed,
                    minimumSize: const Size(
                      150,
                      40,
                    ),
                  ),
                  child: Text(
                    'ย้อนกลับ',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ปุ่มถัดไป
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activeIndex++;
                    });
                    // if (basicFormKey.currentState?.validate() ?? false) {
                    //   // next
                    //   setState(() {
                    //     activeIndex++;
                    //   });
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                    minimumSize: const Size(
                      150,
                      40,
                    ),
                  ),
                  child: Text(
                    'ถัดไป',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget finishClubDetails() {
    //   return Row(
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             child: Padding(
    //               padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.max,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   DotStepper(
    //                     activeStep: activeIndex,
    //                     dotCount: totalIndex,
    //                     dotRadius: 20.0,
    //                     shape: Shape.pipe,
    //                     spacing: 10.0,
    //                   ),
    //                   SizedBox(height: 10),
    //                   Text(
    //                     'ชื่อคลับของคุณคือ :\n${clubNameController!.text}',
    //                     style: GoogleFonts.sarabun(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 25,
    //                     ),
    //                   ),
    //                   SizedBox(height: 10),
    //                   Text(
    //                     clubDescriptionController!.text,
    //                     style: GoogleFonts.sarabun(
    //                       fontSize: 17,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           SizedBox(height: 50),
    //           Align(
    //             alignment: Alignment.center,
    //             child: Padding(
    //               padding: const EdgeInsets.all(20.0),
    //               child: ElevatedButton(
    //                 onPressed: () {},
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: mainGreen,
    //                   minimumSize: const Size(
    //                     300,
    //                     40,
    //                   ),
    //                 ),
    //                 child: Text(
    //                   'ถัดไป',
    //                   style: GoogleFonts.sarabun(
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   );
    // }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DotStepper(
                        indicatorDecoration: const IndicatorDecoration(
                          color: mainGreen,
                        ),
                        tappingEnabled: false,
                        activeStep: activeIndex,
                        dotCount: totalIndex,
                        dotRadius: 20.0,
                        shape: Shape.pipe,
                        spacing: 10.0,
                      ),
                      const SizedBox(height: 20),
                      imageFile == null
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                PermissionStatus cameraStatus =
                                    await Permission.camera.request();
                                if (cameraStatus == PermissionStatus.granted) {
                                  showImageDialog();
                                }
                                if (cameraStatus == PermissionStatus.denied) {
                                  Fluttertoast.showToast(
                                      msg: "This permission is recommended");
                                }
                                if (cameraStatus ==
                                    PermissionStatus.permanentlyDenied) {
                                  openAppSettings();
                                }

                                setState(() {});
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(color: lightGrey),
                                  ),
                                  Positioned(
                                    bottom: 1.0,
                                    right: -1.0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: lightGrey,
                                          width: 2.2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                PermissionStatus cameraStatus =
                                    await Permission.camera.request();
                                if (cameraStatus == PermissionStatus.granted) {
                                  showImageDialog();
                                }
                                if (cameraStatus == PermissionStatus.denied) {
                                  Fluttertoast.showToast(
                                      msg: "This permission is recommended");
                                }
                                if (cameraStatus ==
                                    PermissionStatus.permanentlyDenied) {
                                  openAppSettings();
                                }

                                setState(() {});
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 1.0,
                                    right: -1.0,
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: darkGray,
                                          width: 2.2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(height: 30),
                      Text(
                        'ชื่อคลับของคุณคือ\n${clubNameController!.text}',
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Tags : ${_isSelected.join(", ")}",
                        style: GoogleFonts.sarabun(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "คำอธิบายคลับ\n${clubDescriptionController!.text} ,${clubZoneController!.text}",
                        style: GoogleFonts.sarabun(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ปุ่มย้อนกลับ
                      ElevatedButton(
                        onPressed: () {
                          // back
                          setState(() {
                            activeIndex--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainRed,
                          minimumSize: const Size(
                            150,
                            40,
                          ),
                        ),
                        child: Text(
                          'ย้อนกลับ',
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // ปุ่มถัดไป
                      ElevatedButton(
                        onPressed: () {
                          //ส่งข้อมูลทั้งหมดไปยัง ฐานข้อมูล
                          clubSubmit().then((value) {
                            if (value == true) {
                              Fluttertoast.showToast(
                                msg: "สร้างคลับเรียบร้อย",
                                backgroundColor: mainGreen,
                                fontSize: 17,
                              );

                              Get.offAllNamed('/profile-myclub');
                            } else {
                              Fluttertoast.showToast(
                                msg: "มีบางอย่างผิดพลาด กรุณาลองในภายหลัง",
                                backgroundColor: Colors.yellowAccent,
                                textColor: Colors.black,
                              );
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainGreen,
                          minimumSize: const Size(
                            150,
                            40,
                          ),
                        ),
                        child: Text(
                          'สร้างคลับ',
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (activeIndex != 0) {
            activeIndex--;
            setState(() {});
            return true;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
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
          ),
          body: bodyBuilder(size),
        ),
      ),
    );
  }
}
