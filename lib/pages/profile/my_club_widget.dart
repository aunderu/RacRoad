import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rac_road/models/user/my_club_models.dart';
import '../../../colors.dart';
import '../../../services/remote_service.dart';
import 'all_my_club.dart';
import 'create_club/on_boarding.dart';

class MyClubWidget extends StatefulWidget {
  const MyClubWidget({
    super.key,
    required this.getToken,
  });

  final String getToken;

  @override
  State<MyClubWidget> createState() => _MyClubWidgetState();
}

class _MyClubWidgetState extends State<MyClubWidget> {
  List<ClubAll>? clubApproved;
  List<ClubAll>? clubRejected;
  List<ClubAll>? clubWaiting;
  bool haveClub = false;
  bool isLoaded = false;
  MyClub? myClub;

  final bool _haveBookMark = true;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getMyClubData(widget.getToken);
  }

  getMyClubData(String token) async {
    setState(() {
      isLoaded = true;
    });
    myClub = await RemoteService().getMyClub(token);
    if (myClub != null) {
      final bool? haveData = myClub?.data.clubAll.isNotEmpty;
      if (haveData == true) {
        clubWaiting = myClub!.data.clubAll
            .where((element) => element.status == "รอการอนุมัติ")
            .toList();
        clubApproved = myClub!.data.clubAll
            .where((element) => element.status == "อนุมัติ")
            .toList();
        clubRejected = myClub!.data.clubAll
            .where((element) => element.status == "ไม่อนุมัติ")
            .toList();
        if (mounted) {
          setState(() {
            haveClub = true;
            isLoaded = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            haveClub = false;
            isLoaded = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded == true) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.5,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
            strokeWidth: 8,
          ),
        ),
      );
    } else {
      if (haveClub == true) {
        return Column(
          children: [
            clubApproved!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            'คลับของคุณ',
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        GridView.builder(
                          itemCount: clubApproved!.length,
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
                            return AllMyClub(
                              token: widget.getToken,
                              clubId: clubApproved![index].id,
                              clubName: clubApproved![index].clubName,
                              clubStatus: clubApproved![index].status,
                            );
                          },
                        ),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            clubWaiting!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            'คลับที่รอการอนุมัติ',
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        GridView.builder(
                          itemCount: clubWaiting!.length,
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
                            return AllMyClub(
                              token: widget.getToken,
                              clubId: clubWaiting![index].id,
                              clubName: clubWaiting![index].clubName,
                              clubStatus: clubWaiting![index].status,
                            );
                          },
                        ),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            clubRejected!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            'คลับที่ไม่ได้อนุมัติ',
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        GridView.builder(
                          itemCount: clubRejected!.length,
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
                            return AllMyClub(
                              token: widget.getToken,
                              clubId: clubRejected![index].id,
                              clubName: clubRejected![index].clubName,
                              clubStatus: clubRejected![index].status,
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
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
      } else {
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
      }
    }
  }
}
