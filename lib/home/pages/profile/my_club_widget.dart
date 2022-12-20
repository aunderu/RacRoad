import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/home/pages/profile/all_my_club.dart';

import 'package:rac_road/home/pages/profile/create_club/on_boarding.dart';
import 'package:rac_road/models/my_club_models.dart';
import '../../../colors.dart';
import '../../../services/remote_service.dart';

class MyClubWidget extends StatefulWidget {
  final String getToken;
  const MyClubWidget({
    super.key,
    required this.getToken,
  });

  @override
  State<MyClubWidget> createState() => _MyClubWidgetState();
}

class _MyClubWidgetState extends State<MyClubWidget> {
  MyClub? myClub;

  bool haveClub = false;
  bool isLoaded = false;
  final bool _haveBookMark = true;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getMyClubData(widget.getToken);
  }

  getMyClubData(String token) async {
    myClub = await RemoteService().getMyClub(token);
    if (myClub != null) {
      final bool? haveData = myClub?.data.clubAll.isNotEmpty;
      if (haveData == true) {
        if (mounted) {
          setState(() {
            haveClub = true;
            isLoaded = true;
          });
        }
      } else {
        haveClub = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (haveClub == false) {
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
                    builder: (context) =>
                        OnBoardingPage(getToken: widget.getToken),
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
      return FutureBuilder(
        future: RemoteService().getMyClub(widget.getToken),
        builder: (context, snapshot) {
          var result = snapshot.data;
          if (result != null) {
            List<ClubAll> dataMyClub = result.data.clubAll;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          'คลับรอการอนุมัติ',
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      GridView.builder(
                        itemCount: dataMyClub.length,
                        physics: const ScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if (dataMyClub[index].status == "รอการอนุมัติ") {
                            return AllMyClub(
                              token: widget.getToken,
                              clubId: dataMyClub[index].id,
                              clubName: dataMyClub[index].clubName,
                              clubStatus: dataMyClub[index].status,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: GridView.builder(
                    itemCount: dataMyClub.length,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (dataMyClub[index].status == "อนุมัติ") {
                        return AllMyClub(
                          token: widget.getToken,
                          clubId: dataMyClub[index].id,
                          clubName: dataMyClub[index].clubName,
                          clubStatus: dataMyClub[index].status,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OnBoardingPage(getToken: widget.getToken),
                            ),
                          );
                        },
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
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2.3,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
                strokeWidth: 8,
              ),
            ),
          );
        },
      );
    }
  }
}
