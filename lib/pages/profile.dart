import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/loading/skelton.dart';
import '../../services/remote_service.dart';
import 'profile/my_car_widget.dart';
import 'profile/my_club_widget.dart';
import 'profile/my_job_widget.dart';

class ProfilePage extends StatefulWidget {
  // final GoogleSignInAccount user;
  final String getToken;
  int current;
  ProfilePage({
    Key? key,
    required this.getToken,
    required this.current,
    // required this.user,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> items = [
    "My Car",
    "My Club",
    "My Job",
  ];

  late final List pages = [
    MyCarWidget(getToken: widget.getToken),
    MyClubWidget(
      getToken: widget.getToken,
    ),
    MyJobWidget(
      getToken: widget.getToken,
    ),
  ];

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
                FutureBuilder(
                  future: RemoteService().getUserProfile(widget.getToken),
                  builder: (context, snapshot) {
                    var result = snapshot.data;
                    if (result != null) {
                      return Column(
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
                                imageUrl: result.data.myProfile.avatar,
                                placeholder: (context, url) =>
                                    Image.asset('assets/imgs/profile.png'),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              // child: Container(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            result.data.myProfile.name,
                            style: GoogleFonts.sarabun(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            result.data.myProfile.email,
                            style: GoogleFonts.sarabun(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Stack(
                          alignment: const AlignmentDirectional(0.2, 1),
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
                                // child: Image.network(
                                //   widget.user.photoUrl!,
                                // ),
                                child: const Skelton(),
                              ),
                            ),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 2),
                                  )
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.photo_library,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Skelton(
                          height: 18,
                          width: 120,
                        ),
                        SizedBox(height: size.height * 0.005),
                        const Skelton(
                          height: 18,
                          width: 250,
                        ),
                      ],
                    );
                  },
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
                                  width: 110,
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
