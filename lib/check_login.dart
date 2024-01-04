import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/colors.dart';
import 'login/login_main_page.dart';
import 'login/page/with_phone/stepone_with_phone.dart';
import 'models/user/user_profile_model.dart';
import 'services/remote_service.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  final bgImage = const AssetImage('assets/imgs/MainLoginBG-min.jpg');

  @override
  void didChangeDependencies() {
    precacheImage(bgImage, context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    if (token != null) {
      MyProfile? myProfile = await RemoteService().getUserProfile(token);
      // print(myProfile?.data.myProfile.id);
      if (myProfile?.data.myProfile.tel != null) {
        Timer(
          const Duration(seconds: 2),
          () => Get.offUntil(
              MaterialPageRoute(
                  builder: (context) => ScreensPage(pageIndex: 0, current: 0)),
              ((route) => false)),
        );
      } else {
        Get.offUntil(
            MaterialPageRoute(
                builder: (context) => StepOneWithPhoneNumber(getToken: token)),
            ((route) => false));
      }
    } else {
      Timer(
        const Duration(seconds: 2),
        () => Get.offUntil(
            MaterialPageRoute(
                builder: (context) => LoginMainPage(bgImage: bgImage)),
            ((route) => false)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
              strokeWidth: 8,
            ),
          ],
        ),
      ),
    );
  }
}
