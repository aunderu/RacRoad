import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/home/pages/profile/create_club/on_boarding.dart';

import '../../../colors.dart';

class MyClubWidget extends StatefulWidget {
  final String getToken;
  const MyClubWidget({super.key, required this.getToken});

  @override
  State<MyClubWidget> createState() => _MyClubWidgetState();
}

class _MyClubWidgetState extends State<MyClubWidget> {
  final bool _haveClub = false;
  @override
  Widget build(BuildContext context) {
    if (!_haveClub) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(
              "assets/imgs/myclub.png",
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'สังคมที่คุณได้พูดคุยเกี่ยวกับรถที่คุณชอบ',
              style: GoogleFonts.sarabun(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnBoardingPage(),
                  ),
                );
              },
              child: Text(
                'เพิ่มคลับ',
                style: GoogleFonts.sarabun(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainGreen,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Book Mark',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: GridView(
              physics: const ScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional(1, -1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                          child: Icon(
                            Icons.keyboard_control,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 1),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Text(
                            'Club Name',
                            style: GoogleFonts.sarabun(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, -0.05),
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: Image.network(
                          //   '',
                          // ),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: GridView(
              physics: const ScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional(1, -1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                          child: Icon(
                            Icons.keyboard_control,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 1),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Text(
                            'Club Name',
                            style: GoogleFonts.sarabun(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, -0.05),
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: Image.network(
                          //   '',
                          // ),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional(1, -1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
                          child: Icon(
                            Icons.keyboard_control,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 1),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Text(
                            'Club Name',
                            style: GoogleFonts.sarabun(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, -0.05),
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: Image.network(
                          //   '',
                          // ),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Ink(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
