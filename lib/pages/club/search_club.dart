import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';
import '../../models/club/all_club_model.dart';
import '../../services/remote_service.dart';
import 'club_details.dart';

class SearchClubsPage extends StatefulWidget {
  const SearchClubsPage({
    super.key,
    required this.userName,
    required this.getToken,
  });

  final String userName;
  final String getToken;

  @override
  State<SearchClubsPage> createState() => _SearchClubsPageState();
}

class _SearchClubsPageState extends State<SearchClubsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (_) => EasyDebounce.debounce(
                          'textController',
                          const Duration(milliseconds: 2000),
                          () => setState(() {}),
                        ),
                        autofocus: true,
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
                  top: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  start: MediaQuery.of(context).size.width * 0.04,
                  end: MediaQuery.of(context).size.width * 0.04,
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
                    FutureBuilder<AllClubModel?>(
                      future: RemoteService().getAllClubModel(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            // return const ClubLoadingWidget();
                            return const Center(
                                child: CircularProgressIndicator());
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.clubApprove.isNotEmpty) {
                                var result = snapshot.data;
                                List<ClubApprove> dataAllClub =
                                    result!.data.clubApprove;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return allClubWidget(
                                      dataAllClub[index].id,
                                      widget.getToken,
                                      widget.userName,
                                      dataAllClub[index].clubProfile,
                                      dataAllClub[index].clubName,
                                      dataAllClub[index].admin,
                                      dataAllClub[index].clubZone,
                                    );
                                  },
                                );
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            break;
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.clubApprove.isNotEmpty) {
                                var result = snapshot.data;
                                List<ClubApprove> dataAllClub =
                                    result!.data.clubApprove;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return allClubWidget(
                                      dataAllClub[index].id,
                                      widget.getToken,
                                      widget.userName,
                                      dataAllClub[index].clubProfile,
                                      dataAllClub[index].clubName,
                                      dataAllClub[index].admin,
                                      dataAllClub[index].clubZone,
                                    );
                                  },
                                );
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.data.clubApprove.isNotEmpty) {
                                var result = snapshot.data;
                                List<ClubApprove> dataAllClub =
                                    result!.data.clubApprove;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataAllClub.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return allClubWidget(
                                      dataAllClub[index].id,
                                      widget.getToken,
                                      widget.userName,
                                      dataAllClub[index].clubProfile,
                                      dataAllClub[index].clubName,
                                      dataAllClub[index].admin,
                                      dataAllClub[index].clubZone,
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
                        return const Center(child: CircularProgressIndicator());
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

Widget allClubWidget(
  String clubId,
  String getToken,
  String userName,
  String? clubProfile,
  String clubName,
  String clubAdmin,
  String clubZone,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: () {
        Get.to(
          () => ClubDetailsPage(
            clubId: clubId,
            getToken: getToken,
            userName: userName,
          ),
        );
      },
      child: Ink(
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
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: clubProfile != null
                    ? CachedNetworkImage(
                        imageUrl: clubProfile,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) => Container(
                          width: 100,
                          height: 100,
                          color: const Color(0xFFEBEBEB),
                        ),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: const Color(0xFFEBEBEB),
                        child: const Icon(
                          Icons.group,
                          size: 50,
                          color: darkGray,
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
                      Text(
                        clubName,
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        clubAdmin,
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        clubZone,
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
