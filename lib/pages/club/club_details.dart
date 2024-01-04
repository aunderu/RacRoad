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
import 'package:readmore/readmore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/loading/new_feed_loading.dart';
import '../../utils/custom_time_ago.dart';
import '../../utils/loading/club_loading.dart';
import '../../models/club/post_in_club.dart' as post_in_club_model;
import '../../services/remote_service.dart';
import '../../utils/api_url.dart';
import '../../utils/colors.dart';
import '../../models/club/club_request_model.dart';
import '../../models/club/club_details.dart' as club_details_model;
import '../../models/data/menu_items.dart';
import '../../models/data/menu_item.dart';

class ClubDetailsPage extends StatefulWidget {
  const ClubDetailsPage({
    super.key,
    required this.clubId,
    required this.userName,
    this.memcId,
    required this.userId,
  });

  final String clubId;
  final String? memcId;
  final String userName;
  final String userId;

  @override
  State<ClubDetailsPage> createState() => _ClubDetailsPageState();
}

Future<bool> userLeaveClub(String? memcId) async {
  if (memcId == null) {
    return false;
  }
  final response = await http.get(
    Uri.parse("$currentApi/leave/club/$memcId"),
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
                    widget.userId,
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
                    child: FutureBuilder<post_in_club_model.PostInClubModel?>(
                      future: RemoteService().getPostInClub(widget.clubId),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return newsFeedLoading(context, size);
                          case ConnectionState.waiting:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              post_in_club_model.Data dataPostInClub =
                                  result!.data;
                              if (dataPostInClub.post.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
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
                                itemCount: dataPostInClub.post.length,
                                itemBuilder: (context, index) {
                                  return newsFeed(
                                    context,
                                    size,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .ownerAvatar,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .owner,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .description,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .postDate,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .imagePost,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .coComment,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .coLike,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .comment,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .like,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .id,
                                    widget.userId,
                                  );
                                },
                              );
                            } else {
                              return newsFeedLoading(context, size);
                            }
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              var result = snapshot.data;
                              post_in_club_model.Data dataPostInClub =
                                  result!.data;
                              if (dataPostInClub.post.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
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
                                itemCount: dataPostInClub.post.length,
                                itemBuilder: (context, index) {
                                  return newsFeed(
                                    context,
                                    size,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .ownerAvatar,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .owner,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .description,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .postDate,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .imagePost,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .coComment,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .coLike,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .comment,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .like,
                                    dataPostInClub
                                        .post[(dataPostInClub.post.length - 1) -
                                            index]
                                        .id,
                                    widget.userId,
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
                                post_in_club_model.Data dataPostInClub =
                                    result!.data;
                                if (dataPostInClub.post.isEmpty) {
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
                                  itemCount: dataPostInClub.post.length,
                                  itemBuilder: (context, index) {
                                    return newsFeed(
                                      context,
                                      size,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .ownerAvatar,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .owner,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .description,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .postDate,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .imagePost,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .coComment,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .coLike,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .comment,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .like,
                                      dataPostInClub
                                          .post[
                                              (dataPostInClub.post.length - 1) -
                                                  index]
                                          .id,
                                      widget.userId,
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

Future<void> userSendDeal(String memcId, String status) async {
  final response = await http.post(
    Uri.parse("$currentApi/respond/join/club/$memcId"),
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

  final String clubId;
  final club_details_model.Data dataMyClub;
  final String getToken;
  final Size size;
  final String userName;

  @override
  State<ClubDetailsWidgets> createState() => _ClubDetailsWidgetsState();
}

class _ClubDetailsWidgetsState extends State<ClubDetailsWidgets> {
  XFile? camera;
  bool canPost = false;
  ClubRequestModel? dataClubRequest;
  List<File> imageFile = <File>[];
  bool isHavingData = false;
  List<XFile> itemImagesList = <XFile>[];
  List<XFile> photo = <XFile>[];
  TextEditingController? userPostController;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    userPostController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userPostController = TextEditingController();
    getClubRequest();
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

    var request =
        http.MultipartRequest('POST', Uri.parse('$currentApi/post/store'))
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
      Uri.parse("$currentApi/request/join/club"),
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
                                                      // TODO: คำขอเข้าคลับยังไม่ได้ใส่เลข
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

Widget newsFeed(
  BuildContext context,
  Size size,
  String userProfile,
  String userName,
  String? description,
  DateTime timestamp,
  List<post_in_club_model.ImagePost> imgPost,
  int countComment,
  int countLike,
  List<post_in_club_model.Comment> comments,
  List<post_in_club_model.Comment> likes,
  String postId,
  String userId,
) {
  final controller = PageController();
  timeago.setLocaleMessages('th-custom', CustomTimeAgo());
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
                    // const Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
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
                            child: CommentsInClub(
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

class CommentsInClub extends StatefulWidget {
  const CommentsInClub({
    super.key,
    required this.comments,
    required this.userId,
    required this.postId,
  });

  final List<post_in_club_model.Comment> comments;
  final String postId;
  final String userId;

  @override
  State<CommentsInClub> createState() => _CommentsState();
}

class _CommentsState extends State<CommentsInClub> {
  TextEditingController? userCommentController;

  final ScrollController _controller = ScrollController();
  final GlobalKey<FormState> _userCommentKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userCommentController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userCommentController = TextEditingController();
  }

  Future<bool> userComment(
      String postId, String userId, String userComment) async {
    final response = await http.post(
      Uri.parse("$currentApi/comment/store"),
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
                    return StatefulBuilder(
                      builder: (context, setState) => CommentTile(
                        commentsModel: widget.comments,
                        userId: widget.userId,
                        postId: widget.postId,
                        index: index,
                      ),
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
                            Get.offAllNamed('/home')!
                                .then((value) => setState(() {}));
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

class CommentTile extends StatefulWidget {
  const CommentTile({
    super.key,
    required this.commentsModel,
    required this.userId,
    required this.postId,
    required this.index,
  });

  final List<post_in_club_model.Comment> commentsModel;
  final int index;
  final String postId;
  final String userId;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool isReadMore = false;
  var maxLine = 2;
  TextEditingController editCommentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    editCommentController = TextEditingController();
  }

  @override
  void dispose() {
    editCommentController.dispose();
    super.dispose();
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
    String commentId,
    String postId,
    String? comment,
  ) {
    if (userId == ownerId) {
      switch (item) {
        case CommentMenuItems.itemEdit:
          showFormDialog(comment, postId, commentId, ownerId);
          // print('tapped edit comment!!');
          // print('edit comment : $comment');
          // print('userId is : $userId\ncomment ownerId is : $ownerId');
          break;
        case CommentMenuItems.itemDelete:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ต้องการลบคอมเม้นนี้หรือไม่?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (userId == ownerId) {
                      deleteComment(commentId);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('ลบคอมเม้น'),
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

  void deleteComment(String commentId) async {
    var url = Uri.parse('$currentApi/comment/destroy/$commentId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      Get.offAllNamed('/home')!.then((value) => setState(() {}));

      Fluttertoast.showToast(
        msg: "คุณได้ลบคอมเม้นนี้แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void editComment(
    String commentId,
    String postId,
    String ownerId,
    String comment,
  ) async {
    var url = Uri.parse('$currentApi/comment/update/$commentId');

    final response = await http.post(
      url,
      body: {
        'post_id': postId,
        'user_id': ownerId,
        'comment': comment,
      },
    );

    if (response.statusCode == 200) {
      Get.offAllNamed('/home')!.then((value) => setState(() {}));

      Fluttertoast.showToast(
        msg: "คุณได้แก้ไขโพสต์แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void showFormDialog(
    String? comment,
    String postId,
    String commentId,
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
                'แก้ไขคอมเม้น',
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
                          controller: editCommentController,
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

                                  editComment(
                                    commentId,
                                    postId,
                                    ownerId,
                                    editCommentController.text,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        dense: true,
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
        leading: Container(
          width: 50,
          height: 50,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CachedNetworkImage(
            imageUrl: widget
                .commentsModel[(widget.commentsModel.length - 1) - widget.index]
                .ownerAvatar,
          ),
        ),
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget
                        .commentsModel[
                            (widget.commentsModel.length - 1) - widget.index]
                        .owner,
                    style: GoogleFonts.sarabun(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PopupMenuButton<CustomMenuItem>(
                onSelected: (item) => onSelected(
                  context,
                  item,
                  widget.userId,
                  widget
                      .commentsModel[
                          (widget.commentsModel.length - 1) - widget.index]
                      .userId,
                  widget
                      .commentsModel[
                          (widget.commentsModel.length - 1) - widget.index]
                      .id,
                  widget.postId,
                  widget
                      .commentsModel[
                          (widget.commentsModel.length - 1) - widget.index]
                      .comment!,
                ),
                enabled: widget.userId ==
                    widget
                        .commentsModel[
                            (widget.commentsModel.length - 1) - widget.index]
                        .userId,
                itemBuilder: (context) => [
                  ...CommentMenuItems.itemsFirst.map(buildItem).toList(),
                  const PopupMenuDivider(),
                  ...CommentMenuItems.itemsSecond.map(buildItem).toList(),
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
        subtitle: ReadMoreText(
          widget.commentsModel[(widget.commentsModel.length - 1) - widget.index]
              .comment!,
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' ดูเพิ่มเติม',
          trimExpandedText: ' ย่อลง',
          style: GoogleFonts.sarabun(
            fontSize: 15,
            color: Colors.black,
            // fontWeight: FontWeight.bold,
          ),
          moreStyle:
              GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.bold),
          lessStyle:
              GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
