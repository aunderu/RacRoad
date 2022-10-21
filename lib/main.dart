import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rac_road/home/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';
import 'login/login_main_page.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = _currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RacRoad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CheckLogin(),
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  String token = "";

  @override
  void initState() {
    super.initState();
    // getToken();
    checkLogin();
  }

  Future<void> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
  }

  void checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    if (token != null) {
      Timer(
        const Duration(seconds: 2),
        () => Get.to(
          () => const ScreensPage(),
        ),
      );
    } else {
      Timer(const Duration(seconds: 2),
          () => Get.to(() => const LoginMainPage()));
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
          ],
        ),
      ),
    );
  }
}
