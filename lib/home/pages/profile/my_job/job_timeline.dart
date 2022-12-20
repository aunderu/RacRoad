import 'package:flutter/material.dart';

import 'package:rac_road/home/pages/sos/timeline/step/step_1.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_2.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_3.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_4.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_5.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_6.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_7.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_8.dart';
import 'package:rac_road/models/sos_details_models.dart';
import 'package:rac_road/services/remote_service.dart';

class JobTimeLine extends StatefulWidget {
  final String getToken;
  const JobTimeLine({
    super.key,
    required this.getToken,
  });

  @override
  State<JobTimeLine> createState() => _JobTimeLineState();
}

class _JobTimeLineState extends State<JobTimeLine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(),
    );
  }
}
