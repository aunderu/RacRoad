import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/models/club/user_club_not_joined.dart';
import 'package:rac_road/models/club/my_club_models.dart';
import 'package:rac_road/services/remote_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../colors.dart';
import '../models/club/user_club_joined.dart';
import 'club/all_club_widget.dart';
import 'club/my_club_widget.dart';
import 'club/search_club.dart';
import 'profile/create_club/on_boarding.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({
    super.key,
    required this.token,
    required this.userName,
  });

  final String token;
  final String userName;

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(
                          () => SearchClubsPage(
                            getToken: widget.token,
                            userName: widget.userName,
                          ),
                          transition: Transition.noTransition,
                        ),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Search',
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF757575),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.search,
                                  color: Color(0xFF757575),
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: size.height * 0.02,
                  bottom: size.height * 0.02,
                  start: size.width * 0.04,
                  end: size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'คลับของฉัน',
                        style: GoogleFonts.sarabun(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<MyClub?>(
                      future: RemoteService().getMyClub(widget.token),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const MyClubLoadingWidget();
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              List<MyClubElement> dataMyClub =
                                  result!.data.myClub!;
                              if (dataMyClub.isNotEmpty) {
                                return SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: dataMyClub.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return FittedBox(
                                        child: MyClubWidget(
                                          clubProfile:
                                              dataMyClub[index].clubProfile,
                                          clubName: dataMyClub[index].clubName,
                                          clubDescription:
                                              dataMyClub[index].description,
                                          clubId: dataMyClub[index].id,
                                          clubStatus: dataMyClub[index].status,
                                          getToken: widget.token,
                                          userName: widget.userName,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox.fromSize();
                              }
                            }
                            break;
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              List<MyClubElement> dataMyClub =
                                  result!.data.myClub!;
                              if (dataMyClub.isNotEmpty) {
                                return SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: dataMyClub.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return FittedBox(
                                        child: MyClubWidget(
                                          clubProfile:
                                              dataMyClub[index].clubProfile,
                                          clubName: dataMyClub[index].clubName,
                                          clubDescription:
                                              dataMyClub[index].description,
                                          clubId: dataMyClub[index].id,
                                          clubStatus: dataMyClub[index].status,
                                          getToken: widget.token,
                                          userName: widget.userName,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox.fromSize();
                              }
                            }
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                            } else {
                              if (snapshot.hasData) {
                                var result = snapshot.data;
                                List<MyClubElement> dataMyClub =
                                    result!.data.myClub!;
                                if (dataMyClub.isNotEmpty) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.22,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: dataMyClub.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return FittedBox(
                                          child: MyClubWidget(
                                            clubProfile:
                                                dataMyClub[index].clubProfile,
                                            clubName:
                                                dataMyClub[index].clubName,
                                            clubDescription:
                                                dataMyClub[index].description,
                                            clubId: dataMyClub[index].id,
                                            clubStatus:
                                                dataMyClub[index].status,
                                            getToken: widget.token,
                                            userName: widget.userName,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return SizedBox.fromSize();
                                }
                              }
                            }
                        }
                        return const MyClubLoadingWidget();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: size.height * 0.01,
                ),
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OnBoardingPage(getToken: widget.token),
                      ),
                    );
                  },
                  child: Ink(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        'สร้างคลับ',
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: size.height * 0.02,
                  bottom: size.height * 0.02,
                  start: size.width * 0.04,
                  end: size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'คลับที่ฉันติดตาม',
                        style: GoogleFonts.sarabun(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<UserClubJoined?>(
                      future: RemoteService().getUserClubJoined(widget.token),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const ClubLoadingWidget();
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.myClubJoin.isNotEmpty) {
                                var result = snapshot.data;
                                List<MyClubJoin> dataAllClub =
                                    result!.data.myClubJoin;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return AllClubWidget(
                                      getToken: widget.token,
                                      clubId: dataAllClub[index].id,
                                      clubName: dataAllClub[index].clubName,
                                      clubProfile:
                                          dataAllClub[index].clubProfile,
                                      clubStatus: dataAllClub[index].status,
                                      clubAdmin: dataAllClub[index].admin,
                                      clubZone: dataAllClub[index].clubZone,
                                      adminName: dataAllClub[index].admin,
                                      userName: widget.userName,
                                      memcId: dataAllClub[index].memcId,
                                    );
                                  },
                                );
                              } else {
                                const SizedBox.shrink();
                              }
                            } else {
                              return const ClubLoadingWidget();
                            }
                            break;
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.myClubJoin.isNotEmpty) {
                                var result = snapshot.data;
                                List<MyClubJoin> dataAllClub =
                                    result!.data.myClubJoin;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return AllClubWidget(
                                      getToken: widget.token,
                                      clubId: dataAllClub[index].id,
                                      clubName: dataAllClub[index].clubName,
                                      clubProfile:
                                          dataAllClub[index].clubProfile,
                                      clubStatus: dataAllClub[index].status,
                                      clubAdmin: dataAllClub[index].admin,
                                      clubZone: dataAllClub[index].clubZone,
                                      adminName: dataAllClub[index].admin,
                                      userName: widget.userName,
                                      memcId: dataAllClub[index].memcId,
                                    );
                                  },
                                );
                              } else {
                                const SizedBox.shrink();
                              }
                            } else {
                              return const ClubLoadingWidget();
                            }
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.myClubJoin.isNotEmpty) {
                                var result = snapshot.data;
                                List<MyClubJoin> dataAllClub =
                                    result!.data.myClubJoin;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return AllClubWidget(
                                      getToken: widget.token,
                                      clubId: dataAllClub[index].id,
                                      clubName: dataAllClub[index].clubName,
                                      clubProfile:
                                          dataAllClub[index].clubProfile,
                                      clubStatus: dataAllClub[index].status,
                                      clubAdmin: dataAllClub[index].admin,
                                      clubZone: dataAllClub[index].clubZone,
                                      adminName: dataAllClub[index].admin,
                                      userName: widget.userName,
                                      memcId: dataAllClub[index].memcId,
                                    );
                                  },
                                );
                              } else {
                                const SizedBox.shrink();
                              }
                            } else {
                              return SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'ดูเหมือนยังไม่มีคลับอะไรในตอนนี้',
                                    style: GoogleFonts.sarabun(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: size.height * 0.02,
                  bottom: size.height * 0.02,
                  start: size.width * 0.04,
                  end: size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'คลับทั้งหมด',
                        style: GoogleFonts.sarabun(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<UserClubNotJoined?>(
                      future:
                          RemoteService().getUserClubNotJoined(widget.token),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const ClubLoadingWidget();
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.clubNotJoin.isNotEmpty) {
                                var result = snapshot.data;
                                List<ClubNotJoin> dataAllClub =
                                    result!.data.clubNotJoin;
                                dataAllClub.shuffle();
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return AllClubWidget(
                                      getToken: widget.token,
                                      clubId: dataAllClub[index].id,
                                      clubName: dataAllClub[index].clubName,
                                      clubProfile:
                                          dataAllClub[index].clubProfile,
                                      clubStatus: dataAllClub[index].status,
                                      clubAdmin: dataAllClub[index].admin,
                                      clubZone: dataAllClub[index].clubZone,
                                      adminName: dataAllClub[index].admin,
                                      userName: widget.userName,
                                    );
                                  },
                                );
                              }
                            } else {
                              return const ClubLoadingWidget();
                            }
                            break;
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.clubNotJoin.isNotEmpty) {
                                var result = snapshot.data;
                                List<ClubNotJoin> dataAllClub =
                                    result!.data.clubNotJoin;
                                dataAllClub.shuffle();
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return AllClubWidget(
                                      getToken: widget.token,
                                      clubId: dataAllClub[index].id,
                                      clubName: dataAllClub[index].clubName,
                                      clubProfile:
                                          dataAllClub[index].clubProfile,
                                      clubStatus: dataAllClub[index].status,
                                      clubAdmin: dataAllClub[index].admin,
                                      clubZone: dataAllClub[index].clubZone,
                                      adminName: dataAllClub[index].admin,
                                      userName: widget.userName,
                                    );
                                  },
                                );
                              }
                            } else {
                              return const ClubLoadingWidget();
                            }
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.clubNotJoin.isNotEmpty) {
                                var result = snapshot.data;
                                List<ClubNotJoin> dataAllClub =
                                    result!.data.clubNotJoin;
                                dataAllClub.shuffle();
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return AllClubWidget(
                                      getToken: widget.token,
                                      clubId: dataAllClub[index].id,
                                      clubName: dataAllClub[index].clubName,
                                      clubProfile:
                                          dataAllClub[index].clubProfile,
                                      clubStatus: dataAllClub[index].status,
                                      clubAdmin: dataAllClub[index].admin,
                                      clubZone: dataAllClub[index].clubZone,
                                      adminName: dataAllClub[index].admin,
                                      userName: widget.userName,
                                    );
                                  },
                                );
                              }
                            } else {
                              return SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'ดูเหมือนยังไม่มีคลับอะไรในตอนนี้',
                                    style: GoogleFonts.sarabun(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                        }
                        return const ClubLoadingWidget();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClubLoadingWidget extends StatelessWidget {
  const ClubLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFEBEBEB),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Shimmer.fromColors(
                baseColor: lightGrey,
                highlightColor: Colors.white,
                child: Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFEBEBEB),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: lightGrey,
                      highlightColor: Colors.white,
                      child: Container(
                        width: 70,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEBEBEB),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: lightGrey,
                      highlightColor: Colors.white,
                      child: Container(
                        width: 100,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEBEBEB),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: lightGrey,
                      highlightColor: Colors.white,
                      child: Container(
                        width: 60,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEBEBEB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: lightGrey,
              highlightColor: Colors.white,
              child: Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClubLoadingWidget extends StatelessWidget {
  const MyClubLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.22,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x34090F13),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Shimmer.fromColors(
              baseColor: lightGrey,
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                color: lightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
