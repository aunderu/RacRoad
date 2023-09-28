import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/services/remote_service.dart';
import 'package:rac_road/utils/user_preferences.dart';

import 'models/user/my_job_models.dart';
import 'models/user/current_tnc_sos_models.dart';
import 'pages/market_page.dart';
import 'pages/profile/account_setting.dart';
import 'pages/club.dart';
import 'pages/home_page.dart';
import 'pages/profile.dart';
import 'pages/sos.dart';

class ScreensPage extends StatefulWidget {
  ScreensPage({
    Key? key,
    required this.pageIndex,
    required this.current,
    // required this.user,
  }) : super(key: key);

  // final GoogleSignInAccount user;

  int current;
  int pageIndex;

  @override
  State<ScreensPage> createState() => _ScreensPageState();
}

class _ScreensPageState extends State<ScreensPage> {
  MyJob? myJob;
  CurrentTncSos? myTncSos;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? searchController;
  String? token;
  String? avatar;
  String? email;
  String? name;

  // int index = 0;

  late final _screens = <Widget>[
    HomePage(
      token: token!,
      userName: name!,
    ),
    ClubPage(
      token: token!,
      userName: name!,
    ),
    SOSPage(
      token: token!,
    ),
    const MarketPage(),
    ProfilePage(
      getToken: token!,
      current: widget.current,
    ),
    //const TestPage(),
  ];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    token = UserPreferences.getToken() ?? '0';
    name = UserPreferences.getName() ?? 'user name';
    email = UserPreferences.getEmail() ?? 'user@email.com';
    avatar = UserPreferences.getAvatar() ?? 'assets/imgs/profile.png';

    getData(token!);
  }

  getData(String token) async {
    myJob = await RemoteService().getMyJob(token);
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
          child: Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: token != '0'
                ? CachedNetworkImage(
                    imageUrl: avatar!,
                    placeholder: (context, url) =>
                        Image.asset('assets/imgs/profile.png'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/imgs/profile.png'),
                  )
                : Image.asset('assets/imgs/profile.png'),
          ),
        ),
        title: Text(
          name!,
          style: GoogleFonts.sarabun(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
            child: IconButton(
              hoverColor: Colors.transparent,
              iconSize: 60,
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Get.to(
                  () => AccountSetting(getToken: token!),
                  transition: Transition.fadeIn,
                );
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AccountSetting(
                //       getToken: token!,
                //     ),
                //   ),
                // );
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: _screens[widget.pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 40,
            ),
            activeIcon: Icon(
              Icons.home,
              size: 40,
            ),
            label: 'Home',
            tooltip: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups_outlined,
              size: 40,
            ),
            activeIcon: Icon(
              Icons.groups,
              size: 40,
            ),
            label: 'Club',
            tooltip: 'คลับ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sos_outlined,
              color: Colors.red,
              size: 40,
            ),
            activeIcon: Icon(
              Icons.sos,
              color: Colors.red,
              size: 40,
            ),
            label: 'SOS',
            tooltip: 'แจ้งเหตุฉุกเฉิน',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 40,
            ),
            activeIcon: Icon(
              Icons.shopping_bag,
              size: 40,
            ),
            label: 'Market',
            tooltip: 'ร้านค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 40,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 40,
            ),
            label: 'Profile',
            tooltip: 'โปรไฟล์',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.app_registration_outlined,
          //     color: Colors.amber,
          //     size: 40,
          //   ),
          //   activeIcon: Icon(
          //     Icons.app_registration,
          //     color: Colors.amber,
          //     size: 40,
          //   ),
          //   label: 'TESTING',
          //   tooltip: 'หน้าเทสโปรแกรม',
          // ),
        ],
        currentIndex: widget.pageIndex,
        selectedItemColor: widget.pageIndex == 2 ? Colors.red : mainGreen,
        unselectedItemColor: darkGray,
        selectedLabelStyle: GoogleFonts.sarabun(
          fontWeight: FontWeight.bold,
        ),
        onTap: _onItemTapped,
      ),
      // bottomNavigationBar: NavigationBarTheme(
      //   data: NavigationBarThemeData(
      //     indicatorColor: Colors.greenAccent.shade100,
      //     labelTextStyle: MaterialStateProperty.all(
      //       GoogleFonts.sarabun(
      //         fontWeight: FontWeight.w500,
      //         fontSize: 14,
      //       ),
      //     ),
      //   ),
      //   child: NavigationBar(
      //     selectedIndex: widget.pageIndex,
      //     onDestinationSelected: (index) => setState(
      //       () => widget.pageIndex = index,
      //     ),
      //     destinations: [
      //       const NavigationDestination(
      //         icon: Icon(
      //           Icons.home_outlined,
      //           size: 40,
      //         ),
      //         selectedIcon: Icon(
      //           Icons.home,
      //           size: 40,
      //         ),
      //         label: 'Home',
      //       ),
      //       const NavigationDestination(
      //         icon: Icon(
      //           Icons.groups_outlined,
      //           size: 40,
      //         ),
      //         selectedIcon: Icon(
      //           Icons.groups,
      //           size: 40,
      //         ),
      //         label: 'Club',
      //       ),
      //       const NavigationDestination(
      //         icon: Icon(
      //           Icons.sos_outlined,
      //           color: Colors.red,
      //           size: 40,
      //         ),
      //         label: 'SOS',
      //       ),
      //       NavigationDestination(
      //         icon: Stack(
      //           children: const [
      //             Icon(
      //               Icons.notifications_outlined,
      //               size: 40,
      //             ),
      //             // false
      //             //     ? Positioned(
      //             //         top: -1.0,
      //             //         right: -1.0,
      //             //         child: Stack(
      //             //           children: const [
      //             //             Icon(
      //             //               Icons.brightness_1,
      //             //               color: Colors.red,
      //             //               size: 15,
      //             //             )
      //             //           ],
      //             //         ),
      //             //       )
      //             //     : const SizedBox.shrink(),
      //           ],
      //         ),
      //         selectedIcon: Stack(
      //           children: const [
      //             Icon(
      //               Icons.notifications,
      //               size: 40,
      //             ),
      //             // false
      //             //     ? Positioned(
      //             //         top: -1.0,
      //             //         right: -1.0,
      //             //         child: Stack(
      //             //           children: const [
      //             //             Icon(
      //             //               Icons.brightness_1,
      //             //               color: Colors.red,
      //             //               size: 15,
      //             //             )
      //             //           ],
      //             //         ),
      //             //       )
      //             //     : const SizedBox.shrink(),
      //           ],
      //         ),
      //         label: 'Notification',
      //       ),
      //       NavigationDestination(
      //         icon: Stack(
      //           children: const [
      //             Icon(
      //               Icons.person_outline,
      //               size: 40,
      //             ),
      //             // _isProfileNoti
      //             //     ? Positioned(
      //             //         top: -1.0,
      //             //         right: -1.0,
      //             //         child: Stack(
      //             //           children: const [
      //             //             Icon(
      //             //               Icons.brightness_1,
      //             //               color: Colors.red,
      //             //               size: 15,
      //             //             )
      //             //           ],
      //             //         ),
      //             //       )
      //             //     : const SizedBox.shrink(),
      //           ],
      //         ),
      //         selectedIcon: Stack(
      //           children: const [
      //             Icon(
      //               Icons.person,
      //               size: 40,
      //             ),
      //             // _isProfileNoti
      //             //     ? Positioned(
      //             //         top: -1.0,
      //             //         right: -1.0,
      //             //         child: Stack(
      //             //           children: const [
      //             //             Icon(
      //             //               Icons.brightness_1,
      //             //               color: Colors.red,
      //             //               size: 15,
      //             //             )
      //             //           ],
      //             //         ),
      //             //       )
      //             //     : const SizedBox.shrink(),
      //           ],
      //         ),
      //         label: 'Profile',
      //       ),
      //       NavigationDestination(
      //         icon: Icon(
      //           Icons.app_registration_sharp,
      //           color: Colors.yellow[700],
      //           size: 40,
      //         ),
      //         label: 'Test',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
