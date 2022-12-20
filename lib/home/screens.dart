import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/loading/skelton.dart';
import 'package:rac_road/services/remote_service.dart';

import 'pages/account_setting.dart';
import 'pages/club.dart';
import 'pages/home_page.dart';
import 'pages/notifications.dart';
import 'pages/profile.dart';
import 'pages/sos.dart';

class ScreensPage extends StatefulWidget {
  final String getToken;
  int pageIndex;
  // final GoogleSignInAccount user;
  ScreensPage({
    Key? key,
    required this.getToken,
    required this.pageIndex,
    // required this.user,
  }) : super(key: key);

  @override
  State<ScreensPage> createState() => _ScreensPageState();
}

class _ScreensPageState extends State<ScreensPage> {
  TextEditingController? searchController;
  // int index = 0;
  final bool _isNoti = true;

  late final _screens = <Widget>[
    HomePage(token: widget.getToken),
    ClubPage(token: widget.getToken),
    SOSPage(token: widget.getToken),
    NotificationsPage(token: widget.getToken),
    ProfilePage(getToken: widget.getToken),
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
      body: widget.pageIndex != 4
          ? NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                FutureBuilder(
                  // future: getUserProfile(widget.getToken),
                  future: RemoteService().getUserProfile(widget.getToken),
                  builder: (context, snapshot) {
                    var result = snapshot.data;
                    if (result != null) {
                      return SliverAppBar(
                        floating: true,
                        snap: true,
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        leading: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Container(
                            width: 50,
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: result.data.myProfile.avatar,
                              placeholder: (context, url) =>
                                  Image.asset('assets/imgs/profile.png'),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Text(
                          result.data.myProfile.name,
                          style: GoogleFonts.sarabun(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: IconButton(
                              hoverColor: Colors.transparent,
                              iconSize: 60,
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccountSetting(
                                      getToken: widget.getToken,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        centerTitle: false,
                        elevation: 0,
                      );
                    }
                    return SliverAppBar(
                      floating: true,
                      snap: true,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      leading: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Container(
                          width: 50,
                          height: 50,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: Image.network(
                          //   'photoUrl',
                          //   fit: BoxFit.contain,
                          // ),
                          child: const Skelton(),
                        ),
                      ),
                      title: const Skelton(
                        width: 200,
                        height: 20,
                      ),
                      actions: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                          child: IconButton(
                            hoverColor: Colors.transparent,
                            iconSize: 60,
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountSetting(
                                    getToken: widget.getToken,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      centerTitle: false,
                      elevation: 0,
                    );
                  },
                ),
              ],
              body: _screens[widget.pageIndex],
            )
          : _screens[widget.pageIndex],
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
          selectedIndex: widget.pageIndex,
          onDestinationSelected: (index) =>
              setState(() => widget.pageIndex = index),
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
                  false
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
                  false
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
                  false
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
                  false
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
    );
  }
}
