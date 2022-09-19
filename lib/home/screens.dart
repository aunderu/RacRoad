import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/club.dart';
import 'pages/home_page.dart';
import 'pages/notifications.dart';
import 'pages/profile.dart';
import 'pages/sos.dart';

class ScreensPage extends StatefulWidget {
  const ScreensPage({super.key});

  @override
  State<ScreensPage> createState() => _ScreensPageState();
}

class _ScreensPageState extends State<ScreensPage> {
  TextEditingController? searchController;
  int index = 0;
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
          destinations: const [
            NavigationDestination(
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
            NavigationDestination(
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
            NavigationDestination(
              icon: Icon(
                Icons.sos_outlined,
                color: Colors.red,
                size: 40,
              ),
              label: 'SOS',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.notifications_outlined,
                size: 40,
              ),
              selectedIcon: Icon(
                Icons.notifications,
                size: 40,
              ),
              label: 'Notification',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                size: 40,
              ),
              selectedIcon: Icon(
                Icons.person,
                size: 40,
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
