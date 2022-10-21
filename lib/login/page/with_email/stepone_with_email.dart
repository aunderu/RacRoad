import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/login/page/setup/set_name.dart';

class StepOneWithEmail extends StatefulWidget {
  const StepOneWithEmail({super.key});

  @override
  State<StepOneWithEmail> createState() => _StepOneWithEmailState();
}

class _StepOneWithEmailState extends State<StepOneWithEmail> {
  // Future googleSignIn() async {
  //   final user = await GoogleSignInApi.login();

  //   if (user == null) {
  //     Fluttertoast.showToast(msg: "เข้าสู่ระบบล้มเหลว");
  //   } else {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => ScreensPage(),
  //     ));
  //   }
  // }

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
                  'ยืนยันอีเมลของคุณ',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: "ใส่อีเมลแอดเดรส"),
                ),
                SizedBox(height: size.height * 0.05),
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
                        builder: (context) => const SetNamePage(),
                      ),
                    );
                  },
                  child: const Text('Send Email'),
                ),
                SizedBox(height: size.height * 0.05),
                OutlinedButton.icon(
                  icon: Image.asset(
                    "assets/icons/google_logo.png",
                    width: 25,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 1, size.height * 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => null,
                  label: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('ลงชื่อเข้าใช้ด้วย GOOGLE')),
                ),
                Text(
                  'ยืนยันตัวตนด้วยการเชื่อมต่อกับบัญชี Google',
                  style: GoogleFonts.sarabun(
                    fontSize: 12,
                    color: Colors.grey,
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
