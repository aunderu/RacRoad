import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/models/user/user_login.dart';
import 'package:rac_road/utils/user_preferences.dart';

import '../check_login.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';

class LoginMainPage extends StatefulWidget {
  const LoginMainPage({
    super.key,
    this.bgImage,
  });

  final AssetImage? bgImage;

  @override
  State<LoginMainPage> createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {
  // GoogleSignInAccount? _currentUser;

  // @override
  // void initState() {
  //   super.initState();
  //   _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
  //     setState(() {
  //       _currentUser = account;
  //     });
  //   });
  //   _googleSignIn.signInSilently();
  // }

  // Widget loginWithMail(BuildContext context, Size size) {
  //   return ElevatedButton.icon(
  //     icon: const Icon(
  //       Icons.email,
  //       size: 40,
  //       color: Colors.grey,
  //     ),
  //     style: ElevatedButton.styleFrom(
  //       minimumSize: Size(size.width * 1, size.height * 0.07),
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30.0),
  //       ),
  //     ),
  //     onPressed: () async {
  //       await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const StepOneWithEmail(),
  //         ),
  //       );
  //     },
  //     label: Align(
  //       alignment: Alignment.centerLeft,
  //       child: Text(
  //         'เข้าสู่ระบบด้วยอีเมล',
  //         style: GoogleFonts.sarabun(
  //           color: Colors.grey,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 17,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget loginWithGoogle(BuildContext context, Size size) {
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
        if (context.mounted) {
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
        }
        final auth = FirebaseAuth.instance;
        final UserLogin? login = await AuthService(auth).signInWithGoogle();

        if (login != null) {
          if (login.status == true) {
            await UserPreferences.setToken(login.data.id);
            await UserPreferences.setName(login.data.name);
            await UserPreferences.setEmail(login.data.email);
            await UserPreferences.setAvatar(login.data.avatar);

            if (mounted) Navigator.pop(context);

            Get.to(() => const CheckLogin());
          } else {
            if (mounted) Navigator.pop(context);
            Fluttertoast.showToast(msg: "กรุณาทำการเข้าสู่ระบบใหม่");
          }
        } else {
          if (mounted) Navigator.pop(context);
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

  // Widget loginWithFacebook(BuildContext context, Size size) {
  //   return ElevatedButton.icon(
  //     icon: Image.asset(
  //       'assets/icons/facebook_logo.png',
  //       width: 40,
  //     ),
  //     style: ElevatedButton.styleFrom(
  //       minimumSize: Size(size.width * 1, size.height * 0.07),
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30.0),
  //       ),
  //     ),
  //     onPressed: () async {
  //       // await Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => ScreensPage(),
  //       //   ),
  //       // );
  //       // Fluttertoast.showToast(msg: "เข้าสู่ระบบด้วย Facebook");
  //     },
  //     label: Align(
  //       alignment: Alignment.centerLeft,
  //       child: Text(
  //         'เข้าสู่ระบบด้วย FACEBOOK',
  //         style: GoogleFonts.sarabun(
  //           color: Colors.grey,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 17,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget loginWithPhone(BuildContext context, Size size) {
  //   return ElevatedButton.icon(
  //     icon: const Icon(
  //       Icons.phone,
  //       size: 40,
  //       color: Colors.green,
  //     ),
  //     style: ElevatedButton.styleFrom(
  //       minimumSize: Size(size.width * 1, size.height * 0.07),
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30.0),
  //       ),
  //     ),
  //     onPressed: () async {
  //       // await Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => StepOneWithPhoneNumber(),
  //       //   ),
  //       // );
  //     },
  //     label: Align(
  //       alignment: Alignment.centerLeft,
  //       child: Text(
  //         'เข้าสู่ระบบด้วยหมายเลขโทรศัพท์',
  //         style: GoogleFonts.sarabun(
  //           color: Colors.grey,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 17,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: widget.bgImage!,
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
                  // loginWithMail(context, size),
                  // SizedBox(height: size.height * 0.02),
                  loginWithGoogle(context, size),
                  // SizedBox(height: size.height * 0.02),
                  // loginWithFacebook(context, size),
                  // SizedBox(height: size.height * 0.02),
                  // loginWithPhone(context, size),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: size.height * 0.02,
                    ),
                    child: Text(
                      'มีปัญหาในการเข้าระบบใช่ไหม ?\nติดต่อได้ที่อีเมล support@racroad.com',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xC8FFFFFF),
                      ),
                      textAlign: TextAlign.center,
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
