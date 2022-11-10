import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rac_road/main.dart';
import 'package:rac_road/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import 'page/with_email/stepone_with_email.dart';
import 'page/with_phone/stepone_with_phone.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginMainPage extends StatefulWidget {
  const LoginMainPage({super.key});

  @override
  State<LoginMainPage> createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Widget loginWithMail(BuildContext context, Size size) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.email,
        size: 40,
        color: Colors.grey,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size.width * 1, size.height * 0.07),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StepOneWithEmail(),
          ),
        );
      },
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'เข้าสู่ระบบด้วยอีเมล',
          style: GoogleFonts.sarabun(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget loginWithGoogle(BuildContext context, Size size) {
    bool isTel = true;

    Future<UserLogin> googleSignIn() async {
      final result = await _googleSignIn.signIn();
      if (result != null) {
        final response = await http.post(
          Uri.parse('https://api.racroad.com/api/google/login'),
          body: {
            'email': result.email,
            'name': result.displayName,
            'avatar': result.photoUrl,
          },
        );
        if (response.statusCode == 200) {
          String responseString = response.body;
          return userLoginFromJson(responseString);
        } else {
          throw Fluttertoast.showToast(msg: "กรุณาทำการเข้าสู่ระบบใหม่");
        }
      } else {
        throw Fluttertoast.showToast(msg: "กรุณาทำการเข้าสู่ระบบใหม่");
      }
    }

    return ElevatedButton.icon(
      icon: Image.asset(
        "assets/icons/google_logo.png",
        width: 40,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size.width * 1, size.height * 0.07),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        final UserLogin login = await googleSignIn();
        if (login.status == true) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("token", login.data.id);
          Get.to(() => CheckLogin());
        }
      },
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'ลงชื่อเข้าใช้ด้วย GOOGLE',
          style: GoogleFonts.sarabun(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget loginWithFacebook(BuildContext context, Size size) {
    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/icons/facebook_logo.png',
        width: 40,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size.width * 1, size.height * 0.07),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ScreensPage(),
        //   ),
        // );
        // Fluttertoast.showToast(msg: "เข้าสู่ระบบด้วย Facebook");
      },
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'เข้าสู่ระบบด้วย FACEBOOK',
          style: GoogleFonts.sarabun(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget loginWithPhone(BuildContext context, Size size) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.phone,
        size: 40,
        color: Colors.green,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size.width * 1, size.height * 0.07),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StepOneWithPhoneNumber(),
          ),
        );
      },
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'เข้าสู่ระบบด้วยหมายเลขโทรศัพท์',
          style: GoogleFonts.sarabun(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/imgs/MainLoginBG-min.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.2,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Rac Road',
                            style: GoogleFonts.sarabun(
                              fontSize: 50,
                              color: mainGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: size.width * 0.2,
                            bottom: size.height * 0.1,
                          ),
                          child: Text(
                            'Community for all',
                            style: GoogleFonts.sarabun(
                              fontSize: 25,
                              height: -0.01,
                              color: mainGreen,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  loginWithMail(context, size),
                  SizedBox(height: size.height * 0.02),
                  loginWithGoogle(context, size),
                  SizedBox(height: size.height * 0.02),
                  loginWithFacebook(context, size),
                  SizedBox(height: size.height * 0.02),
                  loginWithPhone(context, size),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: size.height * 0.02,
                    ),
                    child: Text(
                      'มีปัญหาในการเข้าระบบใช่ไหม ?',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xC8FFFFFF),
                      ),
                    ),
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
