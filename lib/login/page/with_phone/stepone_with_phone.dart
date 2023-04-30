import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:http/http.dart' as http;

import '../../../models/user/update_user_tel.dart';

const List<String> list = <String>['TH +66', 'MY +60', 'ID +62', 'SG +65'];

class StepOneWithPhoneNumber extends StatefulWidget {
  const StepOneWithPhoneNumber({super.key, required this.getToken});
  final String getToken;

  @override
  State<StepOneWithPhoneNumber> createState() => _StepOneWithPhoneNumberState();
}

class _StepOneWithPhoneNumberState extends State<StepOneWithPhoneNumber> {
  String dropdownValue = list.first;
  TextEditingController userTelController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    userTelController = TextEditingController();
  }

  @override
  void dispose() {
    userTelController.dispose();
    super.dispose();
  }

  Future<UpdateUserTel> saveUserTel(String userId, String userTel) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/user/tel/update/$userId"),
      body: {
        'tel': userTel,
      },
    );

    if (response.statusCode == 200) {
      String responseString = response.body;
      return updateUserTelFromJson(responseString);
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                size.width * 0.15,
                size.height * 0.2,
                size.width * 0.15,
                0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'หมายเลขโทรศัพท์ของฉันคือ',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: userTelController,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      validator: MultiValidator([
                        RequiredValidator(
                          errorText: "กรุณากรอกเบอร์มือถือด้วย",
                        ),
                      ]),
                      decoration: const InputDecoration(
                        label: Text("กรอกเบอร์มือถือปัจจุบัน"),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(
                          Icons.call,
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
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteGreen, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffEF4444), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainGreen, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'เมื่อคุณใช้บริการ SOS เจ้าหน้า RacRoad จะใช้เบอร์มือถือนี้พูดคุยค่าบริการต่าง ๆ ให้กับคุณและช่าง',
                      style: GoogleFonts.sarabun(
                        color: const Color.fromARGB(255, 109, 109, 109),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // RichText(
                  //   text: TextSpan(
                  //     style: GoogleFonts.sarabun(
                  //       color: Colors.grey,
                  //       fontSize: 14,
                  //     ),
                  //     children: [
                  //       const TextSpan(
                  //           text:
                  //               'เมื่อคุณกด " Next " Rac Road จะส่งข้อความพร้อมรหัสยืนยันให้กับคุณ อาจมีค่าบริการส่งข้อความและใช้งานข้อมูลอินเตอร์เน็ต คุณสามารถใช้หมายเลขโทรศัพท์ที่ได้รับการยืนยันแล้วหรือเข้าสู่ระบบได้'),
                  //       TextSpan(
                  //         text: '   อ่านเพิ่มเติม',
                  //         style: GoogleFonts.sarabun(
                  //           color: const Color.fromARGB(255, 109, 109, 109),
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () {
                  //             Fluttertoast.showToast(msg: 'กด อ่านเพิ่มเติม');
                  //           },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: size.height * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 1, size.height * 0.05),
                      backgroundColor: mainGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        // saveUserTel(widget.getToken, userTelController.text)
                        //     .then((value) {
                        //   value == true
                        //       ? Get.offAllNamed('/')
                        //       : Fluttertoast.showToast(
                        //           msg:
                        //               "มีบางอย่างผิดพลาด กรุณาเพิ่มข้อมูลภายหลัง",
                        //           backgroundColor: Colors.yellowAccent,
                        //           textColor: Colors.black,
                        //         );
                        // });
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(mainGreen),
                                strokeWidth: 8,
                              ),
                            );
                          },
                        );

                        final UpdateUserTel updateTel = await saveUserTel(
                          widget.getToken,
                          userTelController.text,
                        );

                        Get.back();

                        // print(userTelController.text);

                        if (updateTel.status == true) {
                          Get.offAllNamed('/');
                        } else {
                          Get.snackbar(
                            'โอ๊ะ !',
                            updateTel.message,
                            backgroundColor:
                                const Color.fromARGB(159, 255, 220, 115),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                    child: const Text('ยืนยัน'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
