import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:rac_road/pages/club/search_club.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import '../utils/loading/my_club_loading.dart';
import '../utils/loading/new_feed_loading.dart';
import '../models/data/menu_item.dart';
import '../models/data/menu_items.dart';
import '../utils/api_url.dart';
import '../utils/colors.dart';
import '../models/club/newfeed.dart';
import '../models/club/user_club_not_joined.dart';
import '../services/remote_service.dart';
import '../utils/custom_time_ago.dart';
import 'club/club_details.dart';
import 'club/comment.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController? searchController;
  TextEditingController editPostController = TextEditingController();
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    editPostController = TextEditingController();
  }

  @override
  void dispose() {
    editPostController.dispose();
    super.dispose();
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
                                    .clubId,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .clubName,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .ownerId,
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
                                    .clubId,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .clubName,
                                dataNewFeed[(dataNewFeed.length - 1) - index]
                                    .ownerId,
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
                                      .clubId,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .clubName,
                                  dataNewFeed[(dataNewFeed.length - 1) - index]
                                      .ownerId,
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

  void showFormDialog(
    String? description,
    String postId,
    String clubId,
    String ownerId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(
                'แก้ไขโพสต์',
                textAlign: TextAlign.center,
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: editPostController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          validator: MultiValidator([
                            RequiredValidator(
                              errorText: "กรุณาใส่ข้อความด้วย",
                            ),
                          ]),
                          decoration: const InputDecoration(
                            label: Text('พูดคุยว่าอะไรดีนะ?'),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Color(0xffffffff),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainGreen,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: whiteGreen, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffEF4444), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainGreen, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightGrey,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width / 3.5,
                                  40,
                                ),
                              ),
                              child: Text(
                                'ยกเลิก',
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // next

                                  editPost(
                                    postId,
                                    clubId,
                                    ownerId,
                                    editPostController.text,
                                  );

                                  Get.back();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width / 3.5,
                                  40,
                                ),
                              ),
                              child: Text(
                                'แก้ไข',
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }

  PopupMenuItem<CustomMenuItem> buildItem(CustomMenuItem item) =>
      PopupMenuItem<CustomMenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              item.text,
              style: GoogleFonts.sarabun(),
            ),
          ],
        ),
      );

  void onSelected(
    BuildContext context,
    CustomMenuItem item,
    String userId,
    String ownerId,
    String postId,
    String clubId,
    String? description,
  ) {
    if (userId == ownerId) {
      switch (item) {
        case PostMenuItems.itemEdit:
          showFormDialog(description, postId, clubId, ownerId);
          break;
        case PostMenuItems.itemDelete:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ต้องการลบโพสต์นี้หรือไม่?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (userId == ownerId) {
                      deletePost(postId);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('ลบโพสต์'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก'),
                ),
              ],
              elevation: 24,
            ),
          );
          break;
      }
    }
  }

  void deletePost(String postId) async {
    var url = Uri.parse('$currentApi/post/destroy/$postId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {});

      Fluttertoast.showToast(
        msg: "คุณได้ลบโพสต์นี้แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void editPost(
    String postId,
    String clubId,
    String ownerId,
    String description,
  ) async {
    var url = Uri.parse('$currentApi/post/update/$postId');

    final response = await http.post(
      url,
      body: {
        'club_id': clubId,
        'owner': ownerId,
        'description': description,
      },
    );

    if (response.statusCode == 200) {
      setState(() {});

      Fluttertoast.showToast(
        msg: "คุณได้แก้ไขโพสต์แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
    String clubId,
    String clubName,
    String ownerId,
  ) {
    final controller = PageController();
    timeago.setLocaleMessages('th-custom', CustomTimeAgo());
    var isUserLike = false;
    var isTap = false;
    var maxLine = 1;

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
              // padding: EdgeInsetsDirectional.fromSTEB(
              //   size.width * 0.02,
              //   size.height * 0.01,
              //   size.width * 0.02,
              //   size.height * 0.01,
              // ),
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: StatefulBuilder(
                              builder: (context, setState) => GestureDetector(
                                onTap: () {
                                  if (isTap == false) {
                                    setState(() {
                                      maxLine = 5;
                                      isTap = true;
                                    });
                                  } else {
                                    setState(() {
                                      maxLine = 1;
                                      isTap = false;
                                    });
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        // text: 'tatasffffffffffffffaweqweasdasdd',
                                        text: userName,
                                        style: GoogleFonts.sarabun(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' in ',
                                        style: GoogleFonts.sarabun(
                                          fontSize: 13.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        // text:
                                        //     'tttttttttttttttttttttttttttttttttttttttttttttttttttt',
                                        text: clubName,
                                        style: GoogleFonts.sarabun(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Get.to(
                                                () => ClubDetailsPage(
                                                  clubId: clubId,
                                                  userName: userName,
                                                  userId: userId,
                                                ),
                                                transition: Transition
                                                    .rightToLeftWithFade,
                                              ),
                                      ),
                                    ],
                                  ),
                                  maxLines: maxLine,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
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
                  Expanded(
                    child: PopupMenuButton<CustomMenuItem>(
                      onSelected: (item) => onSelected(
                        context,
                        item,
                        userId,
                        ownerId,
                        postId,
                        clubId,
                        description,
                      ),
                      enabled: userId == ownerId,
                      itemBuilder: (context) => [
                        ...PostMenuItems.itemsFirst.map(buildItem).toList(),
                        const PopupMenuDivider(),
                        ...PostMenuItems.itemsSecond.map(buildItem).toList(),
                      ],
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.black,
                        size: 24,
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
                                onDotClicked: (index) =>
                                    controller.animateToPage(
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
                              if (like.userId == userId) {
                                isUserLike = true;
                                break;
                              } else {
                                isUserLike = false;
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

                  // comment widget
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
                              child: CommentsWidget(
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4, 0, 4, 0),
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

                  // share widget
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
}

Future<bool> userLike(bool isLiked, String postId, String userId) async {
  final response = await http.post(
    Uri.parse("$currentApi/click/like"),
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
