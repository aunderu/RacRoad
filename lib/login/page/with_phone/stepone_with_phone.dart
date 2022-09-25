import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';

import 'steptwo_otp.dart';

const List<String> list = <String>['TH +66', 'MY +60', 'ID +62', 'SG +65'];

class StepOneWithPhoneNumber extends StatefulWidget {
  const StepOneWithPhoneNumber({super.key});

  @override
  State<StepOneWithPhoneNumber> createState() => _StepOneWithPhoneNumberState();
}

class _StepOneWithPhoneNumberState extends State<StepOneWithPhoneNumber> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                Row(
                  children: [
                    DropdownButton(
                      value: dropdownValue,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.sarabun(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    children: [
                      const TextSpan(
                          text:
                              'เมื่อคุณกด " Next " Rac Road จะส่งข้อความพร้อมรหัสยืนยันให้กับคุณ อาจมีค่าบริการส่งข้อความและใช้งานข้อมูลอินเตอร์เน็ต คุณสามารถใช้หมายเลขโทรศัพท์ที่ได้รับการยืนยันแล้วหรือเข้าสู่ระบบได้'),
                      TextSpan(
                        text: '   อ่านเพิ่มเติม',
                        style: GoogleFonts.sarabun(
                          color: const Color.fromARGB(255, 109, 109, 109),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Fluttertoast.showToast(msg: 'กด อ่านเพิ่มเติม');
                          },
                      ),
                    ],
                  ),
                ),
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
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StepTwoOTPPage(),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
