import 'package:flutter/material.dart';
import 'package:rac_road/home/pages/profile/my_job/step/step_1.dart';
import 'package:rac_road/home/pages/profile/my_job/step/step_2.dart';
import 'package:rac_road/home/pages/profile/my_job/step/step_3.dart';

import 'package:rac_road/loading/timeline.dart';
import 'package:rac_road/models/sos_details_models.dart';
import 'package:rac_road/services/remote_service.dart';

class StepPage extends StatefulWidget {
  final String getToken;
  final String sosId;
  const StepPage({
    super.key,
    required this.getToken,
    required this.sosId,
  });

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
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
      body: SingleChildScrollView(
        child: FutureBuilder<SosDetails?>(
          future: RemoteService().getSosDetails(widget.sosId),
          builder: (context, snapshot) {
            var result = snapshot.data;
            if (result != null) {
              switch (result.data.sos.sosStatus) {
                case "step4":
                  return TncStepOne(
                    stepOneTimeStamp: result.data.sos.tuStep4!,
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    userName: result.data.sos.userName,
                    userProfile: result.data.sos.avatar,
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    userTel: result.data.sos.userTel,
                    location: result.data.sos.location,
                    imgIncident: result.data.imgIncident![0].image,
                    tncName: result.data.sos.tncName!,
                    tncAvatar: result.data.sos.tncAvatar!,
                    tncStatus: result.data.sos.tncStatus!,
                    latitude: result.data.sos.latitude,
                    longitude: result.data.sos.longitude,
                    imgBfwork:
                        result.data.sos.tncStatus == "ช่างถึงหน้างานเเล้ว"
                            ? result.data.imgBfwork![0].image
                            : null,
                  );
                case "step5":
                  return TncStepTwo(
                    stepOneTimeStamp: result.data.sos.tuStep4!,
                    stepTwoTimeStamp: result.data.sos.tuStep5!,
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    userName: result.data.sos.userName,
                    userProfile: result.data.sos.avatar,
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    userTel: result.data.sos.userTel,
                    location: result.data.sos.location,
                    imgIncident: result.data.imgIncident![0].image,
                    tncName: result.data.sos.tncName!,
                    tncAvatar: result.data.sos.tncAvatar!,
                    tncStatus: result.data.sos.tncStatus!,
                    latitude: result.data.sos.latitude,
                    longitude: result.data.sos.longitude,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                  );
                case "step6":
                  return TncStepTwo(
                    stepOneTimeStamp: result.data.sos.tuStep4!,
                    stepTwoTimeStamp: result.data.sos.tuStep5!,
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    userName: result.data.sos.userName,
                    userProfile: result.data.sos.avatar,
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    userTel: result.data.sos.userTel,
                    location: result.data.sos.location,
                    imgIncident: result.data.imgIncident![0].image,
                    tncName: result.data.sos.tncName!,
                    tncAvatar: result.data.sos.tncAvatar!,
                    tncStatus: result.data.sos.tncStatus!,
                    latitude: result.data.sos.latitude,
                    longitude: result.data.sos.longitude,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                  );
                case "step7":
                  return TncStepTwo(
                    stepOneTimeStamp: result.data.sos.tuStep4!,
                    stepTwoTimeStamp: result.data.sos.tuStep5!,
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    userName: result.data.sos.userName,
                    userProfile: result.data.sos.avatar,
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    userTel: result.data.sos.userTel,
                    location: result.data.sos.location,
                    imgIncident: result.data.imgIncident![0].image,
                    tncName: result.data.sos.tncName!,
                    tncAvatar: result.data.sos.tncAvatar!,
                    tncStatus: result.data.sos.tncStatus!,
                    latitude: result.data.sos.latitude,
                    longitude: result.data.sos.longitude,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                  );
                case "step8":
                  return TncStepTwo(
                    stepOneTimeStamp: result.data.sos.tuStep4!,
                    stepTwoTimeStamp: result.data.sos.tuStep5!,
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    userName: result.data.sos.userName,
                    userProfile: result.data.sos.avatar,
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    userTel: result.data.sos.userTel,
                    location: result.data.sos.location,
                    imgIncident: result.data.imgIncident![0].image,
                    tncName: result.data.sos.tncName!,
                    tncAvatar: result.data.sos.tncAvatar!,
                    tncStatus: result.data.sos.tncStatus!,
                    latitude: result.data.sos.latitude,
                    longitude: result.data.sos.longitude,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                  );
                case "success":
                  return TncStepThree(
                    stepOneTimeStamp: result.data.sos.tuStep4!,
                    stepTwoTimeStamp: result.data.sos.tuStep5!,
                    stepThreeTimeStamp: result.data.sos.tuSc!,
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    userName: result.data.sos.userName,
                    userProfile: result.data.sos.avatar,
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    userTel: result.data.sos.userTel,
                    location: result.data.sos.location,
                    imgIncident: result.data.imgIncident![0].image,
                    tncName: result.data.sos.tncName!,
                    tncAvatar: result.data.sos.tncAvatar!,
                    tncStatus: result.data.sos.tncStatus!,
                    latitude: result.data.sos.latitude,
                    longitude: result.data.sos.longitude,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                    userReview: result.data.sos.review!,
                    userRate: result.data.sos.rate!,
                    racroadSlip: result.data.racroadSlip![0].image,
                  );
                default:
                  const LoadingTimeLine();
              }
            }
            return const LoadingTimeLine();
          },
        ),
      ),
    );
  }
}
