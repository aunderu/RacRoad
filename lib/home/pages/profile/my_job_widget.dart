import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/profile/apply_for_technician/tech_app_form.dart';
import 'package:rac_road/models/my_job_models.dart';

import '../../../services/remote_service.dart';
import 'my_job/job_widget.dart';

class MyJobWidget extends StatefulWidget {
  final String getToken;
  const MyJobWidget({
    super.key,
    required this.getToken,
  });

  @override
  State<MyJobWidget> createState() => _MyJobWidgetState();
}

class _MyJobWidgetState extends State<MyJobWidget> {
  MyJob? myJob;

  bool haveJob = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getMyJobData(widget.getToken);
  }

  getMyJobData(String token) async {
    myJob = await RemoteService().getMyJob(token);
    if (myJob != null) {
      final bool? haveData = myJob?.data.myTechnician.isNotEmpty;
      if (haveData == true) {
        if (mounted) {
          setState(() {
            haveJob = true;
            isLoaded = true;
          });
        }
      } else {
        haveJob = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (haveJob == false) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(
              "assets/imgs/mechanic.png",
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'สนใจเป็นครอบครัวช่างเหมือนกันเหรอ',
              style: GoogleFonts.sarabun(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 200),
                    reverseDuration: const Duration(milliseconds: 100),
                    child: TAFpage(getToken: widget.getToken),
                  ),
                );
              },
              child: Text(
                'สมัครเป็นช่าง',
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
          FutureBuilder(
            future: RemoteService().getMyJob(widget.getToken),
            builder: (context, snapshot) {
              var result = snapshot.data;
              if (result != null) {
                List<MyTechnician> dataMyJob = result.data.myTechnician;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: dataMyJob.length,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return JobWidget(
                      getToken: widget.getToken,
                      clubProfile: "assets/imgs/mechanic.png",
                      tncName: dataMyJob[index].tncName,
                      jobZone: dataMyJob[index].serviceZone,
                      status: dataMyJob[index].status,
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 200),
                        reverseDuration: const Duration(milliseconds: 100),
                        child: TAFpage(getToken: widget.getToken),
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
  }
}
