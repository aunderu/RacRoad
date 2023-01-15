import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
  Intl.defaultLocale = "th";
  initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleSignInAccount? _currentUser;
  String token = "";

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });

    getToken();
    // googleSigninSilently();
  }

  // Future googleSigninSilently() async {
  //   try {
  //     final result = await _googleSignIn.signInSilently();
  //     if (result != null) {
  //       final ggAuth = await result.authentication;
  //       SharedPreferences preferences = await SharedPreferences.getInstance();
  //       preferences.setString("token", ggAuth.accessToken.toString());
  //       // print(ggAuth.idToken);
  //       print(ggAuth.accessToken);
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }
  Future<void> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = _currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RacRoad',
      initialRoute: "/",
      getPages: [
        GetPage(name: '/', page: () => const MyApp()),
        GetPage(
          name: "/home",
          page: () => ScreensPage(
            getToken: token,
            pageIndex: 0,
            current: 0,
          ),
        ),
        GetPage(
          name: "/club",
          page: () => ScreensPage(
            getToken: token,
            pageIndex: 1,
            current: 0,
          ),
        ),
        GetPage(
          name: "/sos",
          page: () => ScreensPage(
            getToken: token,
            pageIndex: 2,
            current: 0,
          ),
        ),
        GetPage(
          name: "/notification",
          page: () => ScreensPage(
            getToken: token,
            pageIndex: 3,
            current: 0,
          ),
        ),
        GetPage(
          name: "/profile",
          page: () => ScreensPage(
            getToken: token,
            pageIndex: 4,
            current: 0,
          ),
        ),
        GetPage(
          name: "/profile-myclub",
          page: () => ScreensPage(
            getToken: token,
            pageIndex: 4,
            current: 1,
          ),
        ),
        GetPage(
          name: "/profile-myjob",
          page: () => ScreensPage(
            getToken: token,
            pageIndex: 4,
            current: 2,
          ),
        ),
      ],
      theme: ThemeData(
        primaryColor: mainGreen,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: mainGreen),
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
  String? token = "";

  @override
  void initState() {
    super.initState();

    getToken();
    checkLogin();
  }

  Future<void> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
  }

  void checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    if (token != null) {
      Timer(
        const Duration(seconds: 2),
        () => Get.to(
          () => ScreensPage(
            getToken: token,
            pageIndex: 0,
            current: 0,
          ),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 2),
        () => Get.to(
          () => const LoginMainPage(),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/imgs/MainLoginBG-min.jpg'), context);
    super.didChangeDependencies();
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
