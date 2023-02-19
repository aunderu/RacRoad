import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/models/user/my_job_models.dart';
import 'package:rac_road/models/user/current_tnc_sos_models.dart';

import '../../../services/remote_service.dart';
import 'apply_for_technician/tech_app_form.dart';
import 'my_job/job_widget.dart';
import 'my_job/step/step_page.dart';

class MyJobWidget extends StatefulWidget {
  const MyJobWidget({
    super.key,
    required this.getToken,
  });

  final String getToken;

  @override
  State<MyJobWidget> createState() => _MyJobWidgetState();
}

class _MyJobWidgetState extends State<MyJobWidget> {
  bool haveJob = false;
  bool isLoaded = false;
  MyJob? myJob;
  CurrentTncSos? myTncSos;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getData(widget.getToken);
  }

  getData(String token) async {
    setState(() {
      isLoaded = true;
    });
    myJob = await RemoteService().getMyJob(token);
    myTncSos = await RemoteService()
        .getCurrentTncSos(myJob!.data.myTechnician[0].tncId);
    if (myJob != null && myTncSos != null) {
      final bool? haveMyJobData = myJob?.data.myTechnician.isNotEmpty;
      if (haveMyJobData == true) {
        if (mounted) {
          setState(() {
            haveJob = true;
            isLoaded = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            haveJob = false;
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
      if (haveJob == true) {
        switch (myTncSos?.count) {
          case 1:
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => StepPage(
                              getToken: widget.getToken,
                              sosId: myTncSos!.data.sos![0].sosId,
                            ),
                          );
                        },
                        child: Ink(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: lightGreen,
                            border: Border.all(
                              color: whiteGrey,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 13, 30, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      'ติดตามงานของคุณ',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          const Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 5.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AutoSizeText(
                                      'ดูเหมือนคุณมีงานที่ต้องทำให้เสร็จ',
                                      style: GoogleFonts.sarabun(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          const Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 5.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Align(
                                alignment: AlignmentDirectional(1, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.all(5),
                                  child: Icon(
                                    Icons.feedback_rounded,
                                    color: Colors.white,
                                    size: 50,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 5.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  JobWidget(
                    getToken: widget.getToken,
                    jobId: myJob!.data.myTechnician[0].tncId,
                    clubProfile: "assets/imgs/mechanic.png",
                    tncId: myJob!.data.myTechnician[0].tncId,
                    tncName: myJob!.data.myTechnician[0].tncName,
                    jobZone: myJob!.data.myTechnician[0].serviceZone,
                    status: myJob!.data.myTechnician[0].status,
                  ),
                ],
              ),
            );
          default:
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: JobWidget(
                getToken: widget.getToken,
                jobId: myJob!.data.myTechnician[0].tncId,
                clubProfile: "assets/imgs/mechanic.png",
                tncId: myJob!.data.myTechnician[0].tncId,
                tncName: myJob!.data.myTechnician[0].tncName,
                jobZone: myJob!.data.myTechnician[0].serviceZone,
                status: myJob!.data.myTechnician[0].status,
              ),
            );
        }
      } else {
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
      }
    }
  }
}
