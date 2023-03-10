import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

import 'package:rac_road/services/remote_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../colors.dart';
import '../../models/club/my_club_post.dart' as myClubPostsModel;
import '../../models/club/club_details.dart' as clubDetailsModel;
import 'view_calentar.dart';

class ClubDetailsPage extends StatefulWidget {
  const ClubDetailsPage({
    super.key,
    required this.getToken,
    required this.clubId,
    required this.userName,
  });

  final String clubId;
  final String getToken;
  final String userName;

  @override
  State<ClubDetailsPage> createState() => _ClubDetailsPageState();
}

class _ClubDetailsPageState extends State<ClubDetailsPage> {
  bool isFabVisible = true;
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
      floatingActionButton: isFabVisible
          ? SpeedDial(
              icon: Icons.add,
              backgroundColor: Colors.black,
              activeIcon: Icons.close,
              spaceBetweenChildren: 1,
              spacing: 10,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.camera_alt_outlined),
                  label: "Camera",
                ),
                SpeedDialChild(
                  child: const Icon(Icons.add_photo_alternate_outlined),
                  label: "Photo/Video",
                ),
                SpeedDialChild(
                  child: const Icon(Icons.border_color_outlined),
                  label: "Post",
                ),
              ],
            )
          : null,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!isFabVisible) setState(() => isFabVisible = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            if (isFabVisible) setState(() => isFabVisible = false);
          }
          return true;
        },
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
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
                    onPressed: () {},
                  ),
                ),
              ],
              centerTitle: false,
              elevation: 0,
            )
          ],
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  clubDetails(
                    context,
                    size,
                    widget.clubId,
                    widget.getToken,
                    widget.userName,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                    child: Text(
                      'News Feed',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                    child: FutureBuilder<myClubPostsModel.ClubPostModel?>(
                      future: RemoteService().getClubPostModel(widget.clubId),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return newsFeedLoading(context, size);
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              myClubPostsModel.Data dataMyClubPosts =
                                  result!.data;
                              if (dataMyClubPosts.myClubPost.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    child: Center(
                                      child: Text(
                                        "ดูเหมือนยังไม่มีใครโพสต์อะไรนะ?\nคุณสามารถเริ่มต้นการสนทนาได้โดยการเพิ่มโพสต์ที่มุมขวาล่าง",
                                        style: GoogleFonts.sarabun(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: dataMyClubPosts.myClubPost.length,
                                itemBuilder: (context, index) {
                                  return newsFeed(
                                    context,
                                    size,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .ownerAvatar,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .owner,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .description,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .imagePost,
                                  );
                                },
                              );
                            } else {
                              return newsFeedLoading(context, size);
                            }
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              myClubPostsModel.Data dataMyClubPosts =
                                  result!.data;
                              if (dataMyClubPosts.myClubPost.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    child: Center(
                                      child: Text(
                                        "ดูเหมือนยังไม่มีใครโพสต์อะไรนะ?\nคุณสามารถเริ่มต้นการสนทนาได้โดยการเพิ่มโพสต์ที่มุมขวาล่าง",
                                        style: GoogleFonts.sarabun(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: dataMyClubPosts.myClubPost.length,
                                itemBuilder: (context, index) {
                                  return newsFeed(
                                    context,
                                    size,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .ownerAvatar,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .owner,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .description,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .imagePost,
                                  );
                                },
                              );
                            }
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                            } else {
                              if (snapshot.hasData) {
                                var result = snapshot.data;
                                myClubPostsModel.Data dataMyClubPosts =
                                    result!.data;
                                if (dataMyClubPosts.myClubPost.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      child: Center(
                                        child: Text(
                                          "ดูเหมือนยังไม่มีใครโพสต์อะไรนะ?\nคุณสามารถเริ่มต้นการสนทนาได้โดยการเพิ่มโพสต์ที่มุมขวาล่าง",
                                          style: GoogleFonts.sarabun(
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: dataMyClubPosts.myClubPost.length,
                                  itemBuilder: (context, index) {
                                    return newsFeed(
                                      context,
                                      size,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .ownerAvatar,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .owner,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .description,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .imagePost,
                                    );
                                  },
                                );
                              }
                            }
                        }
                        return newsFeedLoading(context, size);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget clubDetails(
  BuildContext context,
  Size size,
  String clubId,
  String userId,
  String userName,
) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(
      size.width * 0.03,
      0,
      size.width * 0.03,
      size.height * 0.01,
    ),
    child: FutureBuilder<clubDetailsModel.ClubDetailsModel?>(
      future: RemoteService().getClubDetailsModel(clubId, userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return ClubDetailsLoading(size: size);
          case ConnectionState.waiting:
            if (snapshot.hasData) {
              var result = snapshot.data;
              clubDetailsModel.Data dataMyClub = result!.data;
              return ClubDetailsWidgets(
                dataMyClub: dataMyClub,
                size: size,
                userName: userName,
              );
            }
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
              var result = snapshot.data;
              clubDetailsModel.Data dataMyClub = result!.data;
              return ClubDetailsWidgets(
                dataMyClub: dataMyClub,
                size: size,
                userName: userName,
              );
            }
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
            } else {
              if (snapshot.hasData) {
                var result = snapshot.data;
                clubDetailsModel.Data dataMyClub = result!.data;
                return ClubDetailsWidgets(
                  dataMyClub: dataMyClub,
                  size: size,
                  userName: userName,
                );
              }
            }
        }
        return ClubDetailsLoading(size: size);
        // var result = snapshot.data;
        // Data dataClubDetails = result.data;
      },
    ),
  );
}

class ClubDetailsLoading extends StatelessWidget {
  const ClubDetailsLoading({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: lightGrey,
                        child: Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: lightGrey,
                        child: Container(
                          color: Colors.white,
                          height: 10,
                          width: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: lightGrey,
                      child: Container(
                        width: size.width * 0.25,
                        height: size.height * 0.04,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: const AlignmentDirectional(0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  0,
                  size.height * 0.01,
                  size.width * 0.03,
                  size.height * 0.01,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: lightGrey,
                      child: Container(
                        color: Colors.white,
                        height: 160,
                        width: 230,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: lightGrey,
                            child: Container(
                              color: Colors.white,
                              width: 30,
                              height: 10,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: lightGrey,
                            child: Container(
                              color: Colors.white,
                              width: 70,
                              height: 7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: lightGrey,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClubDetailsWidgets extends StatelessWidget {
  const ClubDetailsWidgets({
    super.key,
    required this.dataMyClub,
    required this.size,
    required this.userName,
  });

  final clubDetailsModel.Data dataMyClub;
  final Size size;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Container(
                              width: 100,
                              height: 100,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    dataMyClub.clubApproveDetail.clubProfile,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.photo_library,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 0),
                        child: Text(
                          dataMyClub.clubApproveDetail.clubName,
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // SizedBox(height: size.height * 0.01),
                      // Container(
                      //   width: size.width * 0.25,
                      //   height: size.height * 0.04,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   alignment: const AlignmentDirectional(0, 0),
                      //   child: Text(
                      //     'Q&A',
                      //     style: GoogleFonts.sarabun(
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: size.height * 0.01),
                      userName == dataMyClub.clubApproveDetail.admin
                          ? const SizedBox.shrink()
                          : Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: const AlignmentDirectional(0, 0),
                              child: Text(
                                'Join',
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  0,
                  size.height * 0.01,
                  size.width * 0.03,
                  size.height * 0.01,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Material(
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewCalentarPage(),
                            ),
                          );
                        },
                        child: Ink(
                          width: size.width * 0.6,
                          height: size.height * 0.2,
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
                          child: Stack(
                            alignment: const AlignmentDirectional(1, -1),
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(0, -1),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.all(5),
                                  child: Text(
                                    'Calendar',
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  top: size.height * 0.02,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        start: size.width * 0.02,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Day',
                                            style: GoogleFonts.sarabun(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Date',
                                            style: GoogleFonts.sarabun(
                                              fontSize: 50,
                                              height: 0.8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Event Today',
                                            style: GoogleFonts.sarabun(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          size.width * 0.01,
                                          size.height * 0.03,
                                          0,
                                          size.height * 0.03,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '10 event',
                                              style: GoogleFonts.sarabun(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '10 event',
                                              style: GoogleFonts.sarabun(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '10 event',
                                              style: GoogleFonts.sarabun(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '10 event',
                                              style: GoogleFonts.sarabun(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '10 event',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            dataMyClub.clubMember.toString(),
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Members',
                            style: GoogleFonts.sarabun(
                              color: Colors.grey,
                              height: 0.8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: ExpandableNotifier(
                  initialExpanded: false,
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'คำอธิบายเกี่ยวกับคลับ',
                        style: GoogleFonts.sarabun(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    collapsed: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    expanded: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            "${dataMyClub.clubApproveDetail.description}\ntags: ${dataMyClub.tags.map((tag) => tag.tags).toList().join(', ')}",
                            style: GoogleFonts.sarabun(
                              color: const Color(0x8A000000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    theme: const ExpandableThemeData(
                      tapHeaderToExpand: true,
                      tapBodyToExpand: true,
                      tapBodyToCollapse: true,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      hasIcon: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget newsFeed(
  BuildContext context,
  Size size,
  String userProfile,
  String userName,
  String description,
  List<myClubPostsModel.ImagePost> imgPost,
) {
  final controller = PageController();

  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(
      size.width * 0.03,
      0,
      size.width * 0.03,
      size.height * 0.02,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              size.width * 0.02,
              size.height * 0.01,
              size.width * 0.02,
              size.height * 0.01,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.all(1),
                  child: Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: userProfile,
                      fit: BoxFit.cover,
                    ),
                    // child: Image.asset(
                    //   'assets/imgs/profile.png',
                    //   fit: BoxFit.fitWidth,
                    // ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          userName,
                          style: GoogleFonts.sarabun(),
                        ),
                      ),
                      // IconButton(
                      //   hoverColor: Colors.transparent,
                      //   icon: const Icon(
                      //     Icons.bookmark_border,
                      //     color: Colors.grey,
                      //     size: 20,
                      //   ),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: GoogleFonts.sarabun(),
                  ),
                ),
              ],
            ),
          ),
          imgPost.isEmpty
              ? const SizedBox(height: 20)
              : const SizedBox(height: 5),
          imgPost.isNotEmpty
              ? Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: size.height * 0.01,
                    bottom: size.height * 0.01,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ExpandablePageView.builder(
                          controller: controller,
                          itemCount: imgPost.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: imgPost[index].image,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: imgPost.length,
                              effect: const WormEffect(
                                spacing: 20,
                                dotHeight: 10,
                                dotWidth: 10,
                                activeDotColor: mainGreen,
                                dotColor: Colors.black26,
                              ),
                              onDotClicked: (index) => controller.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),

          // Padding(
          //   padding: EdgeInsetsDirectional.fromSTEB(
          //     size.width * 0.02,
          //     size.height * 0.01,
          //     size.width * 0.02,
          //     size.height * 0.01,
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         mainAxisSize: MainAxisSize.max,
          //         children: [
          //           const Padding(
          //             padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
          //             child: LikeButton(
          //               size: 24,
          //               likeCount: 2493,
          //             ),
          //           ),
          //           Padding(
          //             padding:
          //                 const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
          //             child: Row(
          //               mainAxisSize: MainAxisSize.max,
          //               children: [
          //                 const Icon(
          //                   Icons.mode_comment_outlined,
          //                   color: Colors.grey,
          //                   size: 24,
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsetsDirectional.fromSTEB(
          //                       4, 0, 0, 0),
          //                   child: Text(
          //                     '4',
          //                     style: GoogleFonts.sarabun(
          //                       color: Colors.grey,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Row(
          //             mainAxisSize: MainAxisSize.max,
          //             children: const [
          //               Icon(
          //                 Icons.monetization_on_outlined,
          //                 color: Colors.grey,
          //                 size: 24,
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //       Row(
          //         mainAxisSize: MainAxisSize.max,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
          //             child: Text(
          //               '4k Share',
          //               style: GoogleFonts.sarabun(
          //                 color: Colors.grey,
          //               ),
          //             ),
          //           ),
          //           const Icon(
          //             Icons.share_sharp,
          //             color: Colors.grey,
          //             size: 24,
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ),
  );
}

Widget newsFeedLoading(
  BuildContext context,
  Size size,
) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(
      size.width * 0.03,
      0,
      size.width * 0.03,
      size.height * 0.02,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              size.width * 0.02,
              size.height * 0.01,
              size.width * 0.02,
              size.height * 0.01,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.all(1),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: lightGrey,
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: lightGrey,
                        child: Container(
                          color: Colors.white,
                          height: 10,
                          width: 80,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: lightGrey,
                        child: Container(
                          color: Colors.white,
                          height: 10,
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: lightGrey,
            child: Container(
              color: Colors.white,
              height: 250,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              size.width * 0.02,
              size.height * 0.01,
              size.width * 0.02,
              size.height * 0.01,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: LikeButton(
                        size: 24,
                        likeCount: 21,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            Icons.mode_comment_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4, 0, 0, 0),
                            child: Text(
                              '4',
                              style: GoogleFonts.sarabun(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: const [
                    //     Icon(
                    //       Icons.monetization_on_outlined,
                    //       color: Colors.grey,
                    //       size: 24,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                      child: Text(
                        '4k Share',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.share_sharp,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
