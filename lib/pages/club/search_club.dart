import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  bool isLoaded = false;
  AllClubModel? allClub;
  bool haveClub = false;

  List<ClubApprove>? foundClub;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    getClubData();
  }

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  getClubData() async {
    setState(() {
      isLoaded = true;
    });
    allClub = await RemoteService().getAllClubModel();
    if (allClub != null) {
      final bool haveData = allClub!.data.clubApprove.isNotEmpty;
      if (haveData == true) {
        if (mounted) {
          setState(() {
            haveClub = true;
            foundClub = allClub!.data.clubApprove.toList();
            isLoaded = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            haveClub = false;
            isLoaded = false;
          });
        }
      }
    }
  }

  void _runFilter(String enterdKeyword) {
    List<ClubApprove> result;
    if (enterdKeyword.isEmpty) {
      result = allClub!.data.clubApprove;
    } else {
      result = allClub!.data.clubApprove
          .where((club) =>
              club.clubName
                  .toLowerCase()
                  .contains(enterdKeyword.toLowerCase()) ||
              club.clubZone.toLowerCase().contains(enterdKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundClub = result;
    });
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
                        onChanged: (value) => _runFilter(value),
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
                child: isLoaded
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainGreen),
                            strokeWidth: 8,
                          ),
                        ),
                      )
                    : haveClub
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: foundClub!.length,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return allClubWidget(
                                foundClub![(foundClub!.length - 1) - index].id,
                                widget.getToken,
                                widget.userName,
                                foundClub![(foundClub!.length - 1) - index]
                                    .clubProfile,
                                foundClub![(foundClub!.length - 1) - index]
                                    .clubName,
                                foundClub![(foundClub!.length - 1) - index]
                                    .admin,
                                foundClub![(foundClub!.length - 1) - index]
                                    .clubZone,
                              );
                            },
                          )
                        : const Center(
                            child: Text('ดูเหมือนยังไม่มีข้อมูลรถในขณะนี้'),
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
