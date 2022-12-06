import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/profile/apply_for_technician/tech_app_form.dart';
import 'package:rac_road/models/my_job_models.dart';

import '../../../services/remote_service.dart';

class MyJobWidget extends StatefulWidget {
  final String getToken;
  const MyJobWidget({super.key, required this.getToken});

  @override
  State<MyJobWidget> createState() => _MyJobWidgetState();
}

class _MyJobWidgetState extends State<MyJobWidget> {
  MyJob? myJob;
  bool _haveJob = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูล
    getData(widget.getToken);
  }

  getData(String token) async {
    myJob = await RemoteService().getMyJob(token);
    if (myJob != null) {
      final bool? haveData = myJob?.data.myTechnician.isNotEmpty;
      if (haveData == true) {
        setState(() {
          _haveJob = true;
          isLoaded = true;
        });
      } else {
        _haveJob = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_haveJob == false) {
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
      return const Center(
        child: Text('คุณได้สมัครเป็นช่างแล้ว!'),
      );
    }
  }
}
