import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_url.dart';
import '../../utils/colors.dart';

class EditMyClubPage extends StatefulWidget {
  const EditMyClubPage({
    super.key,
    required this.clubName,
    required this.clubProfile,
    required this.userId,
    required this.clubId,
    required this.clubZone,
    required this.description,
  });

  final String clubName;
  final String clubProfile;
  final String userId;
  final String clubId;
  final String clubZone;
  final String description;

  @override
  State<EditMyClubPage> createState() => _EditMyClubPageState();
}

class _EditMyClubPageState extends State<EditMyClubPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController clubNameController = TextEditingController();
  TextEditingController clubDescriptionController = TextEditingController();

  File? imageFile;

  @override
  void initState() {
    super.initState();

    clubNameController = TextEditingController(text: widget.clubName);
    clubDescriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    clubNameController.dispose();
    clubDescriptionController.dispose();
    super.dispose();
  }

  Future<bool> editProfile(
    String userId,
    String clubId,
    String clubName,
    String clubZone,
    String description,
  ) async {
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
        'POST', Uri.parse("$currentApi/club/update/$clubId"))
      ..headers.addAll(headers)
      ..fields.addAll(
        {
          'user_id': userId,
          'club_name': clubName,
          'club_zone': clubZone,
          'description': description,
        },
      );

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'club_profile',
          imageFile!.path,
        ),
      );
    }

    var response = await request.send();

    Get.back();

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
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
                onTap: () async {
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
                onTap: () async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'แก้ไขคลับ ${widget.clubName}',
          style: GoogleFonts.sarabun(
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Card(
                elevation: 10.0,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: StatefulBuilder(
                        builder: (context, setState) => Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                imageFile == null
                                    ? InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          PermissionStatus cameraStatus =
                                              await Permission.camera.request();
                                          if (cameraStatus ==
                                              PermissionStatus.granted) {
                                            showImageDialog();
                                          }
                                          if (cameraStatus ==
                                              PermissionStatus.denied) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "This permission is recommended");
                                          }
                                          if (cameraStatus ==
                                              PermissionStatus
                                                  .permanentlyDenied) {
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
                                              child: Container(
                                                color: lightGrey,
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.clubProfile,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
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
                                          if (cameraStatus ==
                                              PermissionStatus.granted) {
                                            showImageDialog();
                                          }
                                          if (cameraStatus ==
                                              PermissionStatus.denied) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "This permission is recommended");
                                          }
                                          if (cameraStatus ==
                                              PermissionStatus
                                                  .permanentlyDenied) {
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
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: clubNameController,
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    validator: MultiValidator([
                                      RequiredValidator(
                                        errorText: "กรุณากรอกชื่อคลับด้วย",
                                      ),
                                    ]),
                                    decoration: const InputDecoration(
                                      label: Text("กรอกชื่อคลับของคุณ"),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: whiteGreen, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffEF4444),
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: mainGreen, width: 1.0),
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
                                    controller: clubDescriptionController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    // validator: MultiValidator([
                                    //   RequiredValidator(
                                    //     errorText: "กรุณาคำอธิบายคลับด้วย",
                                    //   ),
                                    // ]),
                                    decoration: const InputDecoration(
                                      label: Text("กรอกคำอธิบายคลับของคุณ"),
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
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: mainGreen,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: whiteGreen, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffEF4444),
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: mainGreen, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
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
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        // next

                                        editProfile(
                                          widget.userId,
                                          widget.clubId,
                                          clubNameController.text,
                                          widget.clubZone,
                                          clubDescriptionController.text,
                                        ).then((value) {
                                          if (value == true) {
                                            Get.offAndToNamed(
                                                '/profile-myclub');
                                            Fluttertoast.showToast(
                                              msg: "แก้ไขข้อมูลคลับ เรียบร้อย!",
                                              backgroundColor: mainGreen,
                                              fontSize: 17,
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg:
                                                  "ดูเหมือนมีบางอย่างผิดพลาด กรุณาลองอีกครั้งในภายหลัง",
                                              backgroundColor:
                                                  Colors.amber[100],
                                              textColor: Colors.black,
                                              fontSize: 17,
                                            );
                                          }
                                        });

                                        // String userId,
                                        // String clubId,
                                        // String clubName,
                                        // String clubZone,
                                        // String description,`
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
