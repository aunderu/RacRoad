import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/models/club/all_club_approve.dart';
import 'package:rac_road/models/user/my_club_models.dart';
import 'package:rac_road/services/remote_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../colors.dart';
import 'club/club_widget.dart';
import 'profile/create_club/on_boarding.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key, required this.token});

  final String token;

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? searchController;

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
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (_) => EasyDebounce.debounce(
                          'textController',
                          const Duration(milliseconds: 2000),
                          () => setState(() {}),
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
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
                        var result = snapshot.data;
                        if (result != null) {
                          if (result.data.myClub!.isNotEmpty) {
                            List<MyClubElement> dataMyClub =
                                result.data.myClub!;
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: dataMyClub.length,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return ClubWidget(
                                  getToken: widget.token,
                                  clubId: dataMyClub[index].id,
                                  clubName: dataMyClub[index].clubName,
                                  clubProfile: dataMyClub[index].clubProfile,
                                  clubStatus: dataMyClub[index].status,
                                  clubAdmin: dataMyClub[index].admin,
                                  clubZone: dataMyClub[index].clubZone,
                                );
                              },
                            );
                          }
                          return SizedBox.fromSize();
                        }
                        return const ClubLoadingWidget();
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
                        'คลับทั้งหมด',
                        style: GoogleFonts.sarabun(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<AllClubApprove?>(
                      future: RemoteService().getAllClubApprove(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const ClubLoadingWidget();
                          case ConnectionState.waiting:
                            return const ClubLoadingWidget();
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              List<ClubApprove> dataAllClub =
                                  result!.data.clubApprove!;
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: dataAllClub.length,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return ClubWidget(
                                    getToken: widget.token,
                                    clubId: dataAllClub[index].id,
                                    clubName: dataAllClub[index].clubName,
                                    clubProfile: dataAllClub[index].clubProfile,
                                    clubStatus: dataAllClub[index].status,
                                    clubAdmin: dataAllClub[index].admin,
                                    clubZone: dataAllClub[index].clubZone,
                                  );
                                },
                              );
                            }
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.clubApprove!.isNotEmpty) {
                                var result = snapshot.data;
                                List<ClubApprove> dataAllClub =
                                    result!.data.clubApprove!;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return ClubWidget(
                                      getToken: widget.token,
                                      clubId: dataAllClub[index].id,
                                      clubName: dataAllClub[index].clubName,
                                      clubProfile:
                                          dataAllClub[index].clubProfile,
                                      clubStatus: dataAllClub[index].status,
                                      clubAdmin: dataAllClub[index].admin,
                                      clubZone: dataAllClub[index].clubZone,
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
