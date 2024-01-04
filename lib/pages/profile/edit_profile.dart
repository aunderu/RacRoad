
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rac_road/utils/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api_url.dart';
import '../../utils/colors.dart';
import '../../screens.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.userAvatar,
    required this.userEmail,
    required this.userTel,
    required this.userName,
    required this.getToken,
    required this.cardId,
  });

  final String getToken;
  final String userAvatar;
  final String userEmail;
  final String userName;
  final String userTel;
  final String cardId;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  TextEditingController? userEmailController;
  TextEditingController? userNameController;
  TextEditingController? userTelController;
  File? imageFile;

  @override
  void dispose() {
    userEmailController?.dispose();
    userNameController?.dispose();
    userTelController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userEmailController = TextEditingController(text: widget.userEmail);
    userNameController = TextEditingController(text: widget.userName);
    userTelController = TextEditingController(text: widget.userTel);
  }

  Future<bool> editProfile(
    String userId,
    String userName,
    String userTel,
    String userEmail,
    File? avatar,
    String cardId,
  ) async {

    Map<String, String> headers = {
      'Content-type': 'multipart/form-data',
    };

    var request =
        http.MultipartRequest('POST', Uri.parse("$currentApi/profile/update/$userId"))
          ..headers.addAll(headers)
          ..fields.addAll(
            {
              'name': userName,
              'email': userEmail,
              'tel': userTel,
              'card_id': cardId,
            },
          );

    // request.files.add(
    //     http.MultipartFile(
    //        'file',
    //         imageFile.readAsBytes().asStream(),
    //         imageFile.lengthSync(),
    //         filename: filename,
    //       contentType: MediaType('image','jpeg'),
    //     ),
    // );

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar',
          imageFile!.path,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar',
          widget.userAvatar,
        ),
      );
    }

    var response = await request.send();

    try {
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse("$currentApi/user/destroy/$userId"),
    );

    try {
      if (response.statusCode == 200) {
        // return Get.offAll(() => const LoginMainPage());
      }
    } catch (e) {
      throw Exception(e);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            hoverColor: Colors.transparent,
            iconSize: 60,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: basicFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stack(
                //   alignment: const AlignmentDirectional(0.2, 1),
                //   children: [
                //     Align(
                //       alignment: const AlignmentDirectional(0, 0),
                //       child: Container(
                //         width: 100,
                //         height: 100,
                //         clipBehavior: Clip.antiAlias,
                //         decoration: const BoxDecoration(
                //           shape: BoxShape.circle,
                //         ),
                //         child: CachedNetworkImage(
                //           imageUrl: widget.userAvatar,
                //           placeholder: (context, url) =>
                //               Image.asset('assets/imgs/profile.png'),
                //           errorWidget: (context, url, error) =>
                //               const Icon(Icons.error),
                //         ),
                //         // child: Container(color: Colors.grey),
                //       ),
                //     ),
                //     Container(
                //       width: 35,
                //       height: 35,
                //       decoration: const BoxDecoration(
                //         color: Colors.white,
                //         boxShadow: [
                //           BoxShadow(
                //             blurRadius: 4,
                //             color: Color(0x33000000),
                //             offset: Offset(0, 2),
                //           )
                //         ],
                //         shape: BoxShape.circle,
                //       ),
                //       child: const Icon(
                //         Icons.photo_library,
                //         color: Colors.black,
                //         size: 20,
                //       ),
                //     ),
                //   ],
                // ),
                imageFile == null
                    ? Center(
                        child: InkWell(
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
                                child: CachedNetworkImage(
                                  imageUrl: widget.userAvatar,
                                  placeholder: (context, url) =>
                                      Image.asset('assets/imgs/profile.png'),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
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
                        ),
                      )
                    : Center(
                        child: InkWell(
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
                      ),
                const Divider(
                  height: 50,
                  thickness: 1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Text(
                        'แก้ไขโปรไฟล์',
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: userEmailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'อีเมล',
                          labelStyle: GoogleFonts.sarabun(
                            color: darkGray,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: lightGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: whiteGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(
                            Icons.alternate_email_rounded,
                            color: lightGrey,
                          ),
                          enabled: false,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 32, 20, 12),
                        ),
                        style: GoogleFonts.sarabun(
                          color: const Color.fromARGB(255, 190, 190, 190),
                        ),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: userNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'ชื่อ',
                          labelStyle: GoogleFonts.sarabun(
                            color: darkGray,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: lightGrey,
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
                          prefixIcon: const Icon(
                            Icons.perm_identity_rounded,
                            color: mainGreen,
                          ),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 32, 20, 12),
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: "กรุณากรอกชื่อผู้ใช้งานด้วย",
                          ),
                          MinLengthValidator(
                            5,
                            errorText: "ชื่อผู้ใช้งานห้ามต่ำกว่า 5 ตัวอักษร",
                          ),
                        ]),
                        style: GoogleFonts.sarabun(),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: userTelController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทร',
                          labelStyle: GoogleFonts.sarabun(
                            color: darkGray,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: lightGrey,
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
                          prefixIcon: const Icon(
                            Icons.phone_iphone_rounded,
                            color: mainGreen,
                          ),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 32, 20, 12),
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: "กรุณาเบอร์ติดต่อด้วย",
                          ),
                          MinLengthValidator(
                            10,
                            errorText: "กรุณากรอกเบอร์โทรศัพท์ 10 หลัก",
                          ),
                          MaxLengthValidator(
                            10,
                            errorText: "กรุณากรอกเบอร์โทรศัพท์ 10 หลัก",
                          ),
                        ]),
                        style: GoogleFonts.sarabun(),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () => Get.defaultDialog(
                      title: 'คำเตือน!',
                      titleStyle: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                      titlePadding: const EdgeInsets.only(top: 20),
                      middleText:
                          'เมื่อคุณลบบัญชีของคุณ จะไม่สามารถกู้คืนข้อมูลใด ๆ ได้อีก\n\nคุณแน่ใจแล้วใช่ไหม ?',
                      confirm: ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();

                          sharedPreferences.clear();

                          // await GoogleSignInApi.handleSignOut();
                          GoogleSignIn googleSignIn = GoogleSignIn();

                          await googleSignIn.disconnect();

                          Get.offNamedUntil("/", (route) => false);

                          deleteUser(widget.getToken);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainRed,
                          minimumSize: const Size(100, 40),
                        ),
                        child: Text(
                          "ยืนยันลบข้อมูลของฉัน",
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      cancel: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: whiteGrey,
                          foregroundColor: darkGray,
                          minimumSize: const Size(100, 40),
                        ),
                        child: Text(
                          "ไม่ดีกว่า",
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300],
                        minimumSize: const Size(double.infinity, 30)),
                    child: Text(
                      'ฉันต้องการลบบัญชี',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // ปุ่มย้อนกลับ
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightGrey,
                            foregroundColor: darkGray,
                            minimumSize: const Size(
                              150,
                              40,
                            ),
                          ),
                          child: Text(
                            'ยกเลิก',
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // ปุ่มถัดไป
                        ElevatedButton(
                          onPressed: () async {
                            if (basicFormKey.currentState?.validate() ??
                                false) {
                              editProfile(
                                widget.getToken,
                                userNameController!.text,
                                userTelController!.text,
                                userEmailController!.text,
                                imageFile,
                                widget.cardId,
                              ).then((value) async {
                                if (value == true) {
                                  await UserPreferences.setName(
                                      userNameController!.text);
                                  await UserPreferences.setEmail(
                                      userEmailController!.text);
                                  await UserPreferences.setAvatar(
                                      widget.userAvatar);

                                  Get.to(
                                    () => ScreensPage(
                                      pageIndex: 0,
                                      current: 0,
                                    ),
                                  );
                                  Fluttertoast.showToast(
                                    msg: "แก้ไขข้อมูลโปรไฟล์ เรียบร้อย!",
                                    backgroundColor: mainGreen,
                                    fontSize: 17,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "ดูเหมือนมีบางอย่างผิดพลาด กรุณาลองอีกครั้งในภายหลัง",
                                    backgroundColor: Colors.amber[100],
                                    textColor: Colors.black,
                                    fontSize: 17,
                                  );
                                }
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
                            'แก้ไขโปรไฟล์',
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
        ),
      ),
    );
  }
}
