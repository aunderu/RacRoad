import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? searchController;
  late SharedPreferences sharedPreferences;

  bool circular = true;

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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                child: Text(
                  'Club Suggestion',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 180,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    clubSuggestion(context, size),
                    clubSuggestion(context, size),
                    clubSuggestion(context, size),
                    clubSuggestion(context, size),
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    newsFeed(context, size),
                    newsFeed(context, size),
                    newsFeed(context, size),
                    newsFeed(context, size),
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

Widget clubSuggestion(BuildContext context, Size size) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 12, 12),
    child: InkWell(
      onTap: () {},
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB),
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // child: Image.network(
                //   '',
                //   width: double.infinity,
                //   height: 100,
                //   fit: BoxFit.cover,
                // ),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      size.width * 0.2,
                      size.height * 0.035,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Join',
                    style: GoogleFonts.sarabun(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget newsFeed(BuildContext context, Size size) {
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
              0,
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
                    child: Image.asset(
                      'assets/imgs/profile.png',
                      fit: BoxFit.fitWidth,
                    ),
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
                          'Club name',
                          style: GoogleFonts.sarabun(),
                        ),
                      ),
                      IconButton(
                        hoverColor: Colors.transparent,
                        icon: const Icon(
                          Icons.bookmark_border,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: size.height * 0.01),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.96,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Color(0x3A000000),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              //  child: Image.network(
              //   '',
              //   width: 100,
              //   height: 300,
              //   fit: BoxFit.cover,
              // ),
              child: Container(
                height: 300,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              size.width * 0.02,
              size.height * 0.01,
              size.width * 0.02,
              0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    'description',
                    style: GoogleFonts.sarabun(),
                  ),
                ),
              ],
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
                        likeCount: 2493,
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
