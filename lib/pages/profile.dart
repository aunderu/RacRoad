import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/utils/user_preferences.dart';
import 'profile/my_car_widget.dart';
import 'profile/my_club_widget.dart';
import 'profile/my_job_widget.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key? key,
    required this.getToken,
    required this.current,
    // required this.user,
  }) : super(key: key);

  final String getToken;
  int current;
  // final GoogleSignInAccount user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? avatar;
  String? email;
  List<String> items = [
    "My Car",
    "My Club",
    "My Job",
  ];

  String? name;
  late final List pages = [
    MyCarWidget(getToken: widget.getToken),
    MyClubWidget(
      getToken: widget.getToken,
      userName: name!,
    ),
    MyJobWidget(
      getToken: widget.getToken,
    ),
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    name = UserPreferences.getName() ?? '';
    email = UserPreferences.getEmail() ?? '';
    avatar = UserPreferences.getAvatar() ?? 'assets/imgs/profile.png';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: size.height * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
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
                          imageUrl: avatar!,
                          placeholder: (context, url) =>
                              Image.asset('assets/imgs/profile.png'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/imgs/profile.png'),
                          
                        ),
                        // child: Container(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      name!,
                      style: GoogleFonts.sarabun(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      email!,
                      style: GoogleFonts.sarabun(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.current = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.all(5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.27,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: widget.current == index
                                        ? mainGreen
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Text(
                                    items[index],
                                    style: GoogleFonts.sarabun(
                                      color: widget.current == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                pages[widget.current],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
