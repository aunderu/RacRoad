import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../colors.dart';
import '../models/club/my_posts.dart' as myPostModel;
import '../models/club/user_club_not_joined.dart';
import '../services/remote_service.dart';
import 'club/my_club_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.token,
    required this.userName,
  }) : super(key: key);

  final String token;
  final String userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool circular = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? searchController;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    // fetchUser();
  }

  // Future<UserProfile?> fetchUser() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   int? id = sharedPreferences.getInt("id");
  //   Response response = await post(
  //     Uri.parse('https://api-racroad.chabafarm.com/api/my/profile/$id'),
  //   );
  //   if (response.statusCode == 200) {
  //     return userProfileFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
              //   child: Text(
              //     'Club Suggestion',
              //     style: GoogleFonts.sarabun(
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              // Container(
              //   width: double.infinity,
              //   height: 180,
              //   decoration: const BoxDecoration(
              //     color: Colors.white,
              //   ),
              //   child: ListView(
              //     padding: EdgeInsets.zero,
              //     primary: false,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       clubSuggestion(context, size),
              //       clubSuggestion(context, size),
              //       clubSuggestion(context, size),
              //       clubSuggestion(context, size),
              //     ],
              //   ),
              // ),
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
                        'Club Suggestion',
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                            return const MyClubLoadingWidget();
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              List<ClubNotJoin> dataAllClub =
                                  result!.data.clubNotJoin;
                              dataAllClub.shuffle();
                              if (dataAllClub.isNotEmpty) {
                                return SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: dataAllClub.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return FittedBox(
                                        child: MyClubWidget(
                                          clubProfile:
                                              dataAllClub[index].clubProfile,
                                          clubName: dataAllClub[index].clubName,
                                          clubDescription:
                                              dataAllClub[index].description,
                                          clubId: dataAllClub[index].id,
                                          clubStatus: dataAllClub[index].status,
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
                              List<ClubNotJoin> dataAllClub =
                                  result!.data.clubNotJoin;
                              dataAllClub.shuffle();
                              if (dataAllClub.isNotEmpty) {
                                return SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: dataAllClub.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return FittedBox(
                                        child: MyClubWidget(
                                          clubProfile:
                                              dataAllClub[index].clubProfile,
                                          clubName: dataAllClub[index].clubName,
                                          clubDescription:
                                              dataAllClub[index].description,
                                          clubId: dataAllClub[index].id,
                                          clubStatus: dataAllClub[index].status,
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
                                List<ClubNotJoin> dataAllClub =
                                    result!.data.clubNotJoin;
                                dataAllClub.shuffle();
                                if (dataAllClub.isNotEmpty) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.22,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: dataAllClub.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return FittedBox(
                                          child: MyClubWidget(
                                            clubProfile:
                                                dataAllClub[index].clubProfile,
                                            clubName:
                                                dataAllClub[index].clubName,
                                            clubDescription:
                                                dataAllClub[index].description,
                                            clubId: dataAllClub[index].id,
                                            clubStatus:
                                                dataAllClub[index].status,
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
                child: FutureBuilder<myPostModel.MyPosts?>(
                  future: RemoteService().getMyPosts(widget.token),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return newsFeedLoading(context, size);
                      case ConnectionState.waiting:
                        if (snapshot.hasData) {
                          var result = snapshot.data;
                          myPostModel.Data dataMyPosts = result!.data;
                          if (dataMyPosts.myPost.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 5,
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
                            itemCount: dataMyPosts.myPost.length,
                            itemBuilder: (context, index) {
                              return newsFeed(
                                context,
                                size,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
                                    .avatar,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
                                    .ownerAvatar,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
                                    .description,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
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
                          myPostModel.Data dataMyPosts = result!.data;
                          if (dataMyPosts.myPost.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 5,
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
                            itemCount: dataMyPosts.myPost.length,
                            itemBuilder: (context, index) {
                              return newsFeed(
                                context,
                                size,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
                                    .avatar,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
                                    .ownerAvatar,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
                                    .description,
                                dataMyPosts
                                    .myPost[
                                        (dataMyPosts.myPost.length - 1) - index]
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
                            myPostModel.Data dataMyPosts = result!.data;
                            if (dataMyPosts.myPost.isEmpty) {
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
                              itemCount: dataMyPosts.myPost.length,
                              itemBuilder: (context, index) {
                                return newsFeed(
                                  context,
                                  size,
                                  dataMyPosts
                                      .myPost[(dataMyPosts.myPost.length - 1) -
                                          index]
                                      .avatar,
                                  dataMyPosts
                                      .myPost[(dataMyPosts.myPost.length - 1) -
                                          index]
                                      .ownerAvatar,
                                  dataMyPosts
                                      .myPost[(dataMyPosts.myPost.length - 1) -
                                          index]
                                      .description,
                                  dataMyPosts
                                      .myPost[(dataMyPosts.myPost.length - 1) -
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

Widget newsFeed(
  BuildContext context,
  Size size,
  String userProfile,
  String userName,
  String description,
  List<myPostModel.ImagePost> imgPost,
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
