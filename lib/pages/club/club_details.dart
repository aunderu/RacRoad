import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import 'package:rac_road/services/remote_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../colors.dart';
import '../../models/club/club_request_model.dart';
import '../../models/club/my_club_post.dart' as my_club_posts_model;
import '../../models/club/club_details.dart' as club_details_model;
import '../../models/data/menu_items.dart';
import '../../models/menu_item.dart';

class ClubDetailsPage extends StatefulWidget {
  const ClubDetailsPage({
    super.key,
    required this.getToken,
    required this.clubId,
    required this.userName,
    this.memcId,
  });

  final String clubId;
  final String getToken;
  final String userName;
  final String? memcId;

  @override
  State<ClubDetailsPage> createState() => _ClubDetailsPageState();
}

Future<bool> userLeaveClub(String? memcId) async {
  if (memcId == null) {
    return false;
  }
  final response = await http.get(
    Uri.parse("https://api.racroad.com/api/leave/club/$memcId"),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

void onSelected(
  BuildContext context,
  CustomMenuItem item,
  String memcId,
) {
  switch (item) {
    case ClubDetailMenuItem.itemLeave:
      Get.defaultDialog(
        title: 'ออกจากคลับ',
        titleStyle: GoogleFonts.sarabun(
          fontWeight: FontWeight.bold,
        ),
        titlePadding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
        ),
        middleText: '',
        confirm: ElevatedButton(
          onPressed: () {
            userLeaveClub(memcId).then((value) {
              if (value == false) {
                Fluttertoast.showToast(
                  msg: "มีบางอย่างผิดพลาด กรุณาลองอีกครั้งในภายหลัง",
                  backgroundColor: Colors.red[300],
                  textColor: Colors.black,
                );
              } else {
                Get.offAllNamed('/club');
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(100, 40),
          ),
          child: Text(
            "ออกจากคลับ",
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        cancel: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: whiteGrey,
            foregroundColor: darkGray,
            minimumSize: const Size(100, 40),
          ),
          child: Text(
            "ยกเลิก",
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      break;
  }
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

class _ClubDetailsPageState extends State<ClubDetailsPage> {
  bool isFabVisible = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: PopupMenuButton<CustomMenuItem>(
                    onSelected: (item) =>
                        onSelected(context, item, widget.memcId!),
                    itemBuilder: (context) => [
                      ...ClubDetailMenuItem.itemsFirst.map(buildItem).toList(),
                    ],
                    child: const Icon(
                      Icons.keyboard_control,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                )
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
                    widget.memcId,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 0, 0),
                    child: Text(
                      'News Feed',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 44),
                    child: FutureBuilder<my_club_posts_model.ClubPostModel?>(
                      future: RemoteService().getClubPostModel(widget.clubId),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return newsFeedLoading(context, size);
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              my_club_posts_model.Data dataMyClubPosts =
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
                                        .postDate,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .imagePost,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .coComment,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .coLike,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .comment,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .like,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .id,
                                    widget.getToken,
                                  );
                                },
                              );
                            } else {
                              return newsFeedLoading(context, size);
                            }
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              my_club_posts_model.Data dataMyClubPosts =
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
                                        .postDate,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .imagePost,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .coComment,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .coLike,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .comment,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .like,
                                    dataMyClubPosts
                                        .myClubPost[
                                            (dataMyClubPosts.myClubPost.length -
                                                    1) -
                                                index]
                                        .id,
                                    widget.getToken,
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
                                my_club_posts_model.Data dataMyClubPosts =
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
                                          "ดูเหมือนยังไม่มีใครโพสต์อะไรนะ?\nคุณสามารถเริ่มต้นการสนทนาได้โดยการโพสต์",
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
                                          .postDate,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .imagePost,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .coComment,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .coLike,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .comment,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .like,
                                      dataMyClubPosts
                                          .myClubPost[(dataMyClubPosts
                                                      .myClubPost.length -
                                                  1) -
                                              index]
                                          .id,
                                      widget.getToken,
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
  String? memcId,
) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(
      size.width * 0.03,
      0,
      size.width * 0.03,
      size.height * 0.01,
    ),
    child: FutureBuilder<club_details_model.ClubDetailsModel?>(
      future: RemoteService().getClubDetailsModel(clubId, userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return ClubDetailsLoading(size: size);
          case ConnectionState.waiting:
            if (snapshot.hasData) {
              var result = snapshot.data;
              club_details_model.Data dataMyClub = result!.data;
              return ClubDetailsWidgets(
                dataMyClub: dataMyClub,
                size: size,
                userName: userName,
                clubId: clubId,
                getToken: userId,
              );
            }
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
              var result = snapshot.data;
              club_details_model.Data dataMyClub = result!.data;
              return ClubDetailsWidgets(
                dataMyClub: dataMyClub,
                size: size,
                userName: userName,
                clubId: clubId,
                getToken: userId,
              );
            }
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
            } else {
              if (snapshot.hasData) {
                var result = snapshot.data;
                club_details_model.Data dataMyClub = result!.data;
                return ClubDetailsWidgets(
                  dataMyClub: dataMyClub,
                  size: size,
                  userName: userName,
                  clubId: clubId,
                  getToken: userId,
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
                        width: size.width * 0.55,
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

Future<void> userSendDeal(String memcId, String status) async {
  final response = await http.post(
    Uri.parse("https://api.racroad.com/api/respond/join/club/$memcId"),
    body: {
      'status': status,
    },
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body));
  }
}

class ClubRequestWidget extends StatelessWidget {
  const ClubRequestWidget({super.key, this.dataRequest});

  final ClubRequestModel? dataRequest;

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Text(
              'มีคนสนใจเข้าคลับ ${dataRequest!.count} คน',
              style: GoogleFonts.sarabun(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55,
              child: ListView.builder(
                itemCount: dataRequest!.data.requestMyClub.length,
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:
                            dataRequest!.data.requestMyClub[index].ownerAvatar,
                        height: 50,
                        width: 50,
                      ),
                      title: Text(
                        dataRequest!.data.requestMyClub[index].name,
                        style: GoogleFonts.sarabun(
                          fontSize: 17,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'ปฏิเสธรับเข้ากลุ่ม',
                                titleStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                ),
                                middleText:
                                    'คุณกำลังปฏิเสธการรับเข้ากลุ่มของผู้ใช้นี้\nคุณแน่ใจแล้วใช่ไหม?',
                                confirm: ElevatedButton(
                                  onPressed: () {
                                    userSendDeal(
                                      dataRequest!
                                          .data.requestMyClub[index].memcId,
                                      "no",
                                    );

                                    Get.offAllNamed('/club');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: Text(
                                    "ปฎิเสธ",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                cancel: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: whiteGrey,
                                    foregroundColor: darkGray,
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: Text(
                                    "ยกเลิก",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.indeterminate_check_box,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'ยืนยันรับเข้ากลุ่ม',
                                titleStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.bold,
                                ),
                                middleText: 'คุณกำลังยืนยันรับเข้ากลุ่ม',
                                confirm: ElevatedButton(
                                  onPressed: () {
                                    userSendDeal(
                                      dataRequest!
                                          .data.requestMyClub[index].memcId,
                                      "yes",
                                    );
                                    Get.offAllNamed('/club');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainGreen,
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: Text(
                                    "รับเข้ากลุ่ม",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                cancel: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: whiteGrey,
                                    foregroundColor: darkGray,
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: Text(
                                    "ยกเลิก",
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.check_box,
                              color: mainGreen,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      dense: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubDetailsWidgets extends StatefulWidget {
  const ClubDetailsWidgets({
    super.key,
    required this.dataMyClub,
    required this.size,
    required this.userName,
    required this.clubId,
    required this.getToken,
  });

  final club_details_model.Data dataMyClub;
  final Size size;
  final String userName;

  final String clubId;
  final String getToken;

  @override
  State<ClubDetailsWidgets> createState() => _ClubDetailsWidgetsState();
}

class _ClubDetailsWidgetsState extends State<ClubDetailsWidgets> {
  ClubRequestModel? dataClubRequest;
  bool isHavingData = false;

  TextEditingController? userPostController;
  bool canPost = false;

  final ImagePicker _picker = ImagePicker();
  List<File> imageFile = <File>[];
  List<XFile> photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  XFile? camera;

  @override
  void initState() {
    super.initState();
    userPostController = TextEditingController();
    getClubRequest();
  }

  @override
  void dispose() {
    userPostController!.dispose();
    super.dispose();
  }

  void showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('กรุณาเลือกรูป', textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.sarabun(
            color: Colors.black,
            fontSize: 20,
          ),
          alignment: Alignment.center,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  pickCamera();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'กล้อง',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  pickPhotoFromGallery();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'รูปภาพ',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage(imageQuality: 50);
    if (photo.isNotEmpty) {
      setState(() {
        itemImagesList += photo;
        photo.clear();
      });
    } else {
      Get.snackbar(
        'คำเตือน',
        'คุณยังไม่ได้เลือกรูป',
        backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 191, 0),
          Color.fromARGB(255, 255, 234, 172),
        ]),
        barBlur: 15,
        animationDuration: const Duration(milliseconds: 500),
        icon: const Icon(
          Icons.warning,
          size: 30,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    Get.back();
  }

  pickCamera() async {
    camera = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (camera != null) {
      setState(() {
        itemImagesList.add(camera!);
      });
    } else {
      Get.snackbar(
        'คำเตือน',
        'คุณยังไม่ได้เลือกรูป',
        backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 191, 0),
          Color.fromARGB(255, 255, 234, 172),
        ]),
        barBlur: 15,
        animationDuration: const Duration(milliseconds: 500),
        icon: const Icon(
          Icons.warning,
          size: 30,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    Get.back();
  }

  Future<bool> userPost(
    List<File> imgFile,
    String? userPost,
    String userId,
    String clubId,
  ) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.racroad.com/api/post/store'))
      ..fields.addAll({
        "description": userPost!,
        "owner": userId,
        "club_id": clubId,
      })
      ..headers.addAll(headers);
    for (var i = 0; i < imgFile.length; i++) {
      request.files.add(
        http.MultipartFile(
            'image[$i]',
            File(imgFile[i].path).readAsBytes().asStream(),
            File(imgFile[i].path).lengthSync(),
            filename: imgFile[i].path.split("/").last),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  getClubRequest() async {
    dataClubRequest = await RemoteService().getClubRequestModel(widget.clubId);

    if (dataClubRequest != null) {
      setState(() {
        isHavingData = true;
      });
    }
  }

  Future<bool> userJoinClub(String userId, String clubId) async {
    final response = await http.post(
      Uri.parse("https://api.racroad.com/api/request/join/club"),
      body: {
        'user_id': userId,
        'club_id': clubId,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  void showFormBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => ClubRequestWidget(
        dataRequest: dataClubRequest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Stack(
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
                                      imageUrl: widget.dataMyClub
                                          .clubApproveDetail.clubProfile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Align(
                                //   alignment: Alignment.bottomRight,
                                //   child: Container(
                                //     width: 35,
                                //     height: 35,
                                //     decoration: const BoxDecoration(
                                //       color: Colors.white,
                                //       shape: BoxShape.circle,
                                //     ),
                                //     child: const Icon(
                                //       Icons.photo_library,
                                //       color: Colors.black,
                                //       size: 24,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 5, 5, 0),
                            child: Text(
                              widget.dataMyClub.clubApproveDetail.clubName,
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: widget.size.height * 0.01),
                          widget.dataMyClub.statusMember == 'admin_club'
                              ? Column(
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   child: Material(
                                    //     child: InkWell(
                                    //       onTap: () {},
                                    //       child: Ink(
                                    //         width: widget.size.width * 0.25,
                                    //         height: widget.size.height * 0.04,
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.white,
                                    //           borderRadius:
                                    //               BorderRadius.circular(10),
                                    //         ),
                                    //         child: Row(
                                    //           mainAxisSize: MainAxisSize.min,
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.spaceEvenly,
                                    //           children: [
                                    //             Flexible(
                                    //               child: Text(
                                    //                 'เพิ่มคน',
                                    //                 style: GoogleFonts.sarabun(
                                    //                   fontWeight:
                                    //                       FontWeight.bold,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             const Icon(
                                    //               Icons
                                    //                   .person_add_alt_1_outlined,
                                    //               size: 17,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 5),
                                    isHavingData == false
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Material(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Ink(
                                                  width:
                                                      widget.size.width * 0.25,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'คำขอเข้าคลับ (0)',
                                                      style:
                                                          GoogleFonts.sarabun(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Material(
                                              child: InkWell(
                                                onTap: () {
                                                  showFormBottomSheet(context);
                                                },
                                                child: Ink(
                                                  width:
                                                      widget.size.width * 0.25,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'คำขอเข้าคลับ (${dataClubRequest!.count})',
                                                      style:
                                                          GoogleFonts.sarabun(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                )
                              : const SizedBox.shrink(),
                          widget.dataMyClub.statusMember == 'admin_club'
                              ? const SizedBox.shrink()
                              : widget.dataMyClub.statusMember == 'notjoin'
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            Get.defaultDialog(
                                              title: 'ติดตามคลับ',
                                              titleStyle: GoogleFonts.sarabun(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              titlePadding:
                                                  const EdgeInsets.only(
                                                      top: 20),
                                              middleText:
                                                  'เมื่อคุณขอเข้าร่วมคลับ คุณอาจต้องรอการตอบรับคำขอเข้าร่วมของคุณ',
                                              confirm: ElevatedButton(
                                                onPressed: () {
                                                  userJoinClub(widget.getToken,
                                                      widget.clubId);
                                                  Get.offAllNamed('/club');
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "คุณกดขอเข้าคลับแล้ว กรุณารอการตอบรับเข้าคลับ",
                                                    backgroundColor: lightGreen,
                                                    textColor: Colors.black,
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: mainGreen,
                                                  minimumSize:
                                                      const Size(100, 40),
                                                ),
                                                child: Text(
                                                  "เข้าคลับ",
                                                  style: GoogleFonts.sarabun(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              cancel: ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: whiteGrey,
                                                  foregroundColor: darkGray,
                                                  minimumSize:
                                                      const Size(100, 40),
                                                ),
                                                child: Text(
                                                  "ยกเลิก",
                                                  style: GoogleFonts.sarabun(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Ink(
                                            width: widget.size.width * 0.25,
                                            height: widget.size.height * 0.04,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Join',
                                                style: GoogleFonts.sarabun(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                          // ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: Material(
                          //       child: InkWell(
                          //         onTap: () {
                          //           Get.defaultDialog(
                          //             title:
                          //                 'ออกจากคลับ\n${widget.dataMyClub.clubApproveDetail.clubName}',
                          //             titleStyle: GoogleFonts.sarabun(
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //             titlePadding:
                          //                 const EdgeInsets.only(
                          //               top: 20,
                          //               left: 10,
                          //               right: 10,
                          //             ),
                          //             middleText: '',
                          //             confirm: ElevatedButton(
                          //               onPressed: () {
                          //                 userLeaveClub(widget.memcId)
                          //                     .then((value) {
                          //                   if (value == false) {
                          //                     Fluttertoast.showToast(
                          //                       msg:
                          //                           "มีบางอย่างผิดพลาด กรุณาลองอีกครั้งในภายหลัง",
                          //                       backgroundColor:
                          //                           Colors.red[300],
                          //                       textColor: Colors.black,
                          //                     );
                          //                   } else {
                          //                     Get.offAllNamed('/club');
                          //                   }
                          //                 });
                          //               },
                          //               style: ElevatedButton.styleFrom(
                          //                 backgroundColor: Colors.red,
                          //                 minimumSize:
                          //                     const Size(100, 40),
                          //               ),
                          //               child: Text(
                          //                 "ออกจากคลับ",
                          //                 style: GoogleFonts.sarabun(
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ),
                          //             cancel: ElevatedButton(
                          //               onPressed: () {
                          //                 Get.back();
                          //               },
                          //               style: ElevatedButton.styleFrom(
                          //                 backgroundColor: whiteGrey,
                          //                 foregroundColor: darkGray,
                          //                 minimumSize:
                          //                     const Size(100, 40),
                          //               ),
                          //               child: Text(
                          //                 "ยกเลิก",
                          //                 style: GoogleFonts.sarabun(
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //         child: Ink(
                          //           width: widget.size.width * 0.25,
                          //           height: widget.size.height * 0.04,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius:
                          //                 BorderRadius.circular(10),
                          //           ),
                          //           child: Row(
                          //             mainAxisSize: MainAxisSize.min,
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceEvenly,
                          //             children: [
                          //               Text(
                          //                 'ออกคลับ',
                          //                 style: GoogleFonts.sarabun(
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               const Icon(
                          //                 Icons.exit_to_app,
                          //                 size: 17,
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      0,
                      widget.size.height * 0.01,
                      widget.size.width * 0.03,
                      widget.size.height * 0.01,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFEBEBEB),
                            ),
                          ),
                          // calendar
                          child: SizedBox(
                            height: 200,
                            child: SfCalendar(
                              view: CalendarView.schedule,
                              todayHighlightColor: mainGreen,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ListView.builder(
                                  itemCount:
                                      widget.dataMyClub.userInMyClub.length,
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.dataMyClub
                                              .userInMyClub[index].avatar,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    widget.dataMyClub.clubMember.toString(),
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
                              color: darkGray,
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
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 5),
                              child: Text(
                                "${widget.dataMyClub.clubApproveDetail.description}\ntags: ${widget.dataMyClub.tags.map((tag) => tag.tags).toList().join(', ')}",
                                style: GoogleFonts.sarabun(
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
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          hasIcon: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        widget.dataMyClub.statusMember == "notjoin"
            ? const SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFEBEBEB),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userPostController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'โพสต์อะไรสักหน่อย',
                          hintStyle: GoogleFonts.sarabun(),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: lightGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: mainGreen,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 32, 20, 12),
                        ),
                        style: GoogleFonts.sarabun(),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              canPost = true;
                            });
                          } else {
                            setState(() {
                              canPost = false;
                            });
                          }
                        },
                        textAlign: TextAlign.start,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                      itemImagesList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 100,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 120,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 10,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemImagesList.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        SizedBox(
                                          height: double.maxFinite,
                                          width: double.maxFinite,
                                          child: Image.file(
                                            File(itemImagesList[index].path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: -1.0,
                                          right: -1.0,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                itemImagesList.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: const Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Material(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  PermissionStatus cameraStatus =
                                      await Permission.camera.request();
                                  if (cameraStatus ==
                                      PermissionStatus.granted) {
                                    showImageDialog();
                                  }
                                  if (cameraStatus == PermissionStatus.denied) {
                                    Fluttertoast.showToast(
                                        msg: "This permission is recommended");
                                  }
                                  if (cameraStatus ==
                                      PermissionStatus.permanentlyDenied) {
                                    openAppSettings();
                                  }
                                },
                                child: Ink(
                                  height: 36,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: lightGreen,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.photo_library_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: canPost == false &&
                                        itemImagesList.isEmpty
                                    ? null
                                    : () {
                                        if (itemImagesList.isNotEmpty) {
                                          for (var i = 0;
                                              i < itemImagesList.length;
                                              i++) {
                                            // print('index $i , value ${itemImagesList[i].path}');

                                            imageFile.add(
                                                File(itemImagesList[i].path));
                                          }
                                        }

                                        userPost(
                                          imageFile,
                                          userPostController!.text,
                                          widget.getToken,
                                          widget.clubId,
                                        ).then((value) {
                                          if (value == false) {
                                            Fluttertoast.showToast(
                                              msg:
                                                  "มีบางอย่างผิดพลาด กรุณาลองอีกครั้งในภายหลัง",
                                              backgroundColor: Colors.red[300],
                                              textColor: Colors.black,
                                            );
                                          } else {
                                            Get.offAllNamed('/home');
                                          }
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainGreen,
                                ),
                                child: Text(
                                  'โพสต์',
                                  style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.bold,
                                  ),
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
      ],
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
  List<my_club_posts_model.ImagePost> imgPost,
  int countComment,
  int countLike,
  List<my_club_posts_model.Comment> comments,
  List<my_club_posts_model.Comment> likes,
  String postId,
  String userId,
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
                  child: Expanded(
                    child: SizedBox(
                      width: size.width * 0.75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ],
                    ),
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

  final List<my_club_posts_model.Comment> comments;
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
                            Get.back();

                            setState(() {});
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
