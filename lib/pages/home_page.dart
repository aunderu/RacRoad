import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:rac_road/pages/club/search_club.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import '../utils/colors.dart';
import '../models/club/newfeed.dart';
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
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Club Suggestion',
                    style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: size.width * 0.04),
                child: FutureBuilder<UserClubNotJoined?>(
                  future: RemoteService().getUserClubNotJoined(widget.token),
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
                              height: MediaQuery.of(context).size.height * 0.22,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: dataAllClub.length,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
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
                              height: MediaQuery.of(context).size.height * 0.22,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: dataAllClub.length,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: dataAllClub.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  clipBehavior: Clip.none,
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
                        }
                    }
                    return const MyClubLoadingWidget();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: size.height * 0.02,
                  start: size.width * 0.04,
                  end: size.width * 0.04,
                ),
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
                child: FutureBuilder<NewFeedModel?>(
                  future: RemoteService().getNewFeedModel(widget.token),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return newsFeedLoading(context, size);
                      case ConnectionState.waiting:
                        if (snapshot.hasData) {
                          var result = snapshot.data;
                          List<PostInMyClubJoin> dataNewFeed =
                              result!.data.postInMyClubJoin;
                          if (dataNewFeed.isEmpty) {
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
                            itemCount: dataNewFeed.length,
                            itemBuilder: (context, index) {
                              return newsFeed(
                                context,
                                size,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .ownerAvatar,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .owner,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .description,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .postDate,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .imagePost,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .coComment,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .coLike,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .comment,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .like,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .id,
                                widget.token,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .clubName,
                              );
                            },
                          );
                        } else {
                          return newsFeedLoading(context, size);
                        }
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          var result = snapshot.data;
                          List<PostInMyClubJoin> dataNewFeed =
                              result!.data.postInMyClubJoin;
                          if (dataNewFeed.isEmpty) {
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
                            itemCount: dataNewFeed.length,
                            itemBuilder: (context, index) {
                              return newsFeed(
                                context,
                                size,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .ownerAvatar,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .owner,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .description,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .postDate,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .imagePost,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .coComment,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .coLike,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .comment,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .like,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .id,
                                widget.token,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .clubName,
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
                            List<PostInMyClubJoin> dataNewFeed =
                                result!.data.postInMyClubJoin;
                            if (dataNewFeed.isEmpty) {
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
                              itemCount: dataNewFeed.length,
                              itemBuilder: (context, index) {
                                return newsFeed(
                                  context,
                                  size,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .ownerAvatar,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .owner,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .description,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .postDate,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .imagePost,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .coComment,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .coLike,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .comment,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .like,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .id,
                                  widget.token,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .clubName,
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

class MyCustomTimeAgo implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'ที่แล้ว';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'ตอนนี้';
  @override
  String aboutAMinute(int minutes) => '$minutes นาที';
  @override
  String minutes(int minutes) => '$minutes นาที';
  @override
  String aboutAnHour(int minutes) => '$minutes นาที';
  @override
  String hours(int hours) => '$hours ชั่วโมง';
  @override
  String aDay(int hours) => '1 วัน';
  @override
  String days(int days) => '$days วัน';
  @override
  String aboutAMonth(int days) => '$days วัน';
  @override
  String months(int months) => '$months เดือน';
  @override
  String aboutAYear(int year) => '$year ปี';
  @override
  String years(int years) => '$years ปี';
  @override
  String wordSeparator() => '';
}

Future<bool> userLike(bool isLiked, String postId, String userId) async {
  final response = await http.post(
    Uri.parse("https://api.racroad.com/api/click/like"),
    body: {
      'post_id': postId,
      'user_id': userId,
    },
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Widget newsFeed(
  BuildContext context,
  Size size,
  String userProfile,
  String userName,
  String? description,
  DateTime timestamp,
  List<ImagePost> imgPost,
  int countComment,
  int countLike,
  List<Comment> comments,
  List<Comment> likes,
  String postId,
  String userId,
  String clubName,
) {
  final controller = PageController();
  timeago.setLocaleMessages('th-custom', MyCustomTimeAgo());
  var isUserLike = false;

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  child: SizedBox(
                    width: size.width * 0.75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$userName in $clubName",
                          style: GoogleFonts.sarabun(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 1.5),
                        Text(
                          timeago.format(timestamp, locale: 'th-custom'),
                          style: GoogleFonts.sarabun(
                            fontSize: 11.5,
                            color: darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          description == null
              ? const SizedBox.shrink()
              : Padding(
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
                              placeholder: (context, url) => Container(
                                color: const Color(0xFFEBEBEB),
                              ),
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
          const Divider(color: Colors.black38),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: LikeButton(
                        likeCount: countLike,
                        likeBuilder: (isLiked) {
                          final color = isLiked ? Colors.red : Colors.grey;

                          return Icon(Icons.favorite, color: color, size: 24);
                        },
                        countBuilder: (likeCount, isLiked, text) {
                          final color = isLiked ? Colors.red : Colors.grey;

                          return Text(
                            text,
                            style: GoogleFonts.sarabun(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                        isLiked: (() {
                          for (var like in likes) {
                            if (like.userId == userId &&
                                like.status == "like") {
                              isUserLike = true;
                              return isUserLike;
                            } else {
                              isUserLike = false;
                              return isUserLike;
                            }
                          }
                          return isUserLike;
                        }()),
                        onTap: (isLiked) =>
                            userLike(isLiked, postId, userId).then((isLike) {
                          if (isLike == true) {
                            isUserLike = !isUserLike;
                          }
                          return isUserLike;
                        }),
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        enableDrag: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Comments(
                              comments: comments,
                              userId: userId,
                              postId: postId,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                          child: Text(
                            countComment.toString(),
                            style: GoogleFonts.sarabun(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.mode_comment_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                //       child: Text(
                //         '0 Share',
                //         style: GoogleFonts.sarabun(
                //           color: Colors.grey,
                //         ),
                //       ),
                //     ),
                //     const Icon(
                //       Icons.share_sharp,
                //       color: Colors.grey,
                //       size: 24,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class Comments extends StatefulWidget {
  const Comments({
    super.key,
    required this.comments,
    required this.userId,
    required this.postId,
  });

  final List<Comment> comments;
  final String userId;
  final String postId;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController? userCommentController;
  final GlobalKey<FormState> _userCommentKey = GlobalKey<FormState>();

  final ScrollController _controller = ScrollController();

  Future<bool> userComment(
      String postId, String userId, String userComment) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/comment/store"),
      body: {
        'post_id': postId,
        'user_id': userId,
        'comment': userComment,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    userCommentController = TextEditingController();
  }

  @override
  void dispose() {
    userCommentController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.60,
                child: ListView.builder(
                  itemCount: widget.comments.length,
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: CachedNetworkImage(
                            imageUrl: widget
                                .comments[(widget.comments.length - 1) - index]
                                .ownerAvatar,
                          ),
                          title: Text(
                            widget
                                .comments[(widget.comments.length - 1) - index]
                                .owner,
                            style: GoogleFonts.sarabun(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget
                                .comments[(widget.comments.length - 1) - index]
                                .comment!,
                            style: GoogleFonts.sarabun(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Form(
                      key: _userCommentKey,
                      child: TextFormField(
                        controller: userCommentController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'แสดงความคิดเห็น',
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
                            Icons.keyboard,
                            color: Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: "ไม่สามารถค่าว่างได้",
                          ),
                        ]),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_userCommentKey.currentState?.validate() ?? false) {
                        userComment(
                          widget.postId,
                          widget.userId,
                          userCommentController!.text,
                        ).then((value) {
                          if (value == false) {
                            Fluttertoast.showToast(
                              msg:
                                  "ดูเหมือนมีอะไรผิดพลาด กรุณาลองอีกครั้งในภายหลัง",
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.black,
                            );
                          } else {
                            Get.offAllNamed('/home');
                          }
                        });
                        // print(userCommentController);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
