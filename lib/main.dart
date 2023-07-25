import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';
import 'login/login_main_page.dart';
import 'login/page/with_phone/stepone_with_phone.dart';
import 'models/user/user_profile_model.dart';
import 'screens.dart';
import 'services/remote_service.dart';
import 'utils/user_preferences.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserPreferences.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  // GoogleSignInAccount? _currentUser;

  // @override
  // void initState() {
  //   super.initState();
  //   _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
  //     setState(() {
  //       _currentUser = account;
  //     });
  //   });
  //   // googleSigninSilently();
  // }

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

  @override
  Widget build(BuildContext context) {
    // final GoogleSignInAccount? user = _currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RacRoad',
      initialRoute: "/",
      getPages: [
        GetPage(name: '/', page: () => const MyApp()),
        GetPage(
          name: "/home",
          page: () => ScreensPage(
            pageIndex: 0,
            current: 0,
          ),
        ),
        GetPage(
          name: "/club",
          page: () => ScreensPage(
            pageIndex: 1,
            current: 0,
          ),
        ),
        GetPage(
          name: "/sos",
          page: () => ScreensPage(
            pageIndex: 2,
            current: 0,
          ),
        ),
        // GetPage(
        //   name: "/notification",
        //   page: () => ScreensPage(
        //     pageIndex: 3,
        //     current: 0,
        //   ),
        // ),
        GetPage(
          name: "/profile",
          page: () => ScreensPage(
            pageIndex: 3,
            current: 0,
          ),
        ),
        GetPage(
          name: "/profile-myclub",
          page: () => ScreensPage(
            pageIndex: 3,
            current: 1,
          ),
        ),
        GetPage(
          name: "/profile-myjob",
          page: () => ScreensPage(
            pageIndex: 3,
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
      if (myProfile!.data.myProfile.tel != null) {
        Timer(
          const Duration(seconds: 2),
          () => Get.to(
            () => ScreensPage(
              pageIndex: 0,
              current: 0,
            ),
          ),
        );
      } else {
        Get.to(() => StepOneWithPhoneNumber(getToken: token));
      }
    } else {
      Timer(
        const Duration(seconds: 2),
        () => Get.to(
          () => LoginMainPage(bgImage: bgImage),
        ),
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
