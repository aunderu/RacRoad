import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'pages/club.dart';
import 'pages/home_page.dart';
import 'pages/notifications.dart';
import 'pages/profile.dart';
import 'pages/sos.dart';

class ScreensPage extends StatefulWidget {
  const ScreensPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreensPage> createState() => _ScreensPageState();
}

class _ScreensPageState extends State<ScreensPage> {
  TextEditingController? searchController;
  int index = 0;
  final bool _isNoti = true;

  final screens = [
    const HomePage(),
    const ClubPage(),
    const SOSPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.greenAccent.shade100,
          labelTextStyle: MaterialStateProperty.all(
            GoogleFonts.sarabun(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: [
            const NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                size: 40,
              ),
              selectedIcon: Icon(
                Icons.home,
                size: 40,
              ),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(
                Icons.groups_outlined,
                size: 40,
              ),
              selectedIcon: Icon(
                Icons.groups,
                size: 40,
              ),
              label: 'Club',
            ),
            const NavigationDestination(
              icon: Icon(
                Icons.sos_outlined,
                color: Colors.red,
                size: 40,
              ),
              label: 'SOS',
            ),
            NavigationDestination(
              icon: Stack(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    size: 40,
                  ),
                  _isNoti
                      ? Positioned(
                          top: -1.0,
                          right: -1.0,
                          child: Stack(
                            children: const [
                              Icon(
                                Icons.brightness_1,
                                color: Colors.red,
                                size: 15,
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              selectedIcon: Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    size: 40,
                  ),
                  _isNoti
                      ? Positioned(
                          top: -1.0,
                          right: -1.0,
                          child: Stack(
                            children: const [
                              Icon(
                                Icons.brightness_1,
                                color: Colors.red,
                                size: 15,
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              label: 'Notification',
            ),
            NavigationDestination(
              icon: Stack(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 40,
                  ),
                  _isNoti
                      ? Positioned(
                          top: -1.0,
                          right: -1.0,
                          child: Stack(
                            children: const [
                              Icon(
                                Icons.brightness_1,
                                color: Colors.red,
                                size: 15,
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              selectedIcon: Stack(
                children: [
                  const Icon(
                    Icons.person,
                    size: 40,
                  ),
                  _isNoti
                      ? Positioned(
                          top: -1.0,
                          right: -1.0,
                          child: Stack(
                            children: const [
                              Icon(
                                Icons.brightness_1,
                                color: Colors.red,
                                size: 15,
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: screens[index],
    );
  }
}
