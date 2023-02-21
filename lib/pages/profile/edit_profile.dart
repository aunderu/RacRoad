import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../colors.dart';
import '../../screens.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.userAvatar,
    required this.userEmail,
    required this.userName,
    required this.getToken,
  });

  final String getToken;
  final String userAvatar;
  final String userEmail;
  final String userName;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  TextEditingController? userEmailController;
  TextEditingController? userNameController;

  @override
  void dispose() {
    userEmailController?.dispose();
    userNameController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userEmailController = TextEditingController(text: widget.userEmail);
    userNameController = TextEditingController(text: widget.userName);
  }

  Future<void> editProfile(
    String userId,
    String userName,
    // String userTel,
    String userEmail,
  ) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/user/update/$userId"),
      body: {
        'name': userName,
        'email': userEmail,
      },
    );
    try {
      if (response.statusCode == 200) {
        var encodefirst = json.encode(response.body);
        var data = json.decode(encodefirst);
        return data;
      }
    } catch (e) {
      throw Exception(jsonDecode(response.body));
    }
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
                Stack(
                  alignment: const AlignmentDirectional(0.2, 1),
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Container(
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
                        // child: Container(color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
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
                    // Padding(
                    //   padding:
                    //       const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                    //   child: TextFormField(
                    //     controller: userTelController,
                    //     obscureText: false,
                    //     decoration: InputDecoration(
                    //       labelText: 'เบอร์โทร',
                    //       labelStyle: GoogleFonts.sarabun(
                    //         color: darkGray,
                    //         fontWeight: FontWeight.normal,
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //           color: lightGrey,
                    //           width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //           color: mainGreen,
                    //           width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       errorBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //           color: Colors.red,
                    //           width: 1,
                    //         ),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       focusedErrorBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //           color: Colors.red,
                    //           width: 1,
                    //         ),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       prefixIcon: const Icon(
                    //         Icons.phone_iphone_rounded,
                    //         color: mainGreen,
                    //       ),
                    //       contentPadding: const EdgeInsetsDirectional.fromSTEB(
                    //           20, 32, 20, 12),
                    //     ),
                    //     validator: MultiValidator([
                    //       RequiredValidator(
                    //         errorText: "กรุณาเบอร์ติดต่อด้วย",
                    //       ),
                    //       MinLengthValidator(
                    //         10,
                    //         errorText: "กรุณากรอกเบอร์โทรศัพท์ 10 หลัก",
                    //       ),
                    //       MaxLengthValidator(
                    //         10,
                    //         errorText: "กรุณากรอกเบอร์โทรศัพท์ 10 หลัก",
                    //       ),
                    //     ]),
                    //     style: GoogleFonts.sarabun(),
                    //     textAlign: TextAlign.start,
                    //     keyboardType: TextInputType.phone,
                    //     maxLines: 1,
                    //   ),
                    // ),
                  ],
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
                          onPressed: () {
                            if (basicFormKey.currentState?.validate() ??
                                false) {
                              editProfile(
                                widget.getToken,
                                userNameController!.text,
                                // userTelController!.text,
                                userEmailController!.text,
                              );
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
