import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rac_road/firebase_options.dart';

import 'check_login.dart';
import 'utils/colors.dart';
import 'screens.dart';
import 'utils/user_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";

  initializeDateFormatting();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserPreferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        GetPage(
          name: "/notification",
          page: () => ScreensPage(
            pageIndex: 3,
            current: 0,
          ),
        ),
        GetPage(
          name: "/profile",
          page: () => ScreensPage(
            pageIndex: 4,
            current: 0,
          ),
        ),
        GetPage(
          name: "/profile-myclub",
          page: () => ScreensPage(
            pageIndex: 4,
            current: 1,
          ),
        ),
        GetPage(
          name: "/profile-myjob",
          page: () => ScreensPage(
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


