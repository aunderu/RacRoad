import 'package:flutter/material.dart';

import 'package:rac_road/home/pages/sos/timeline/step/step_1.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_2.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_3.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_4.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_5.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_6.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_7.dart';
import 'package:rac_road/home/pages/sos/timeline/step/step_8.dart';
import 'package:rac_road/home/pages/sos/timeline/step/user_reject.dart';
import 'package:rac_road/loading/timeline.dart';
import 'package:rac_road/models/sos_details_models.dart';
import 'package:rac_road/services/remote_service.dart';

class TimeLinePage extends StatefulWidget {
  final String getToken;
  final String sosId;
  const TimeLinePage({
    super.key,
    required this.getToken,
    required this.sosId,
  });

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
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
                case "step1":
                  return StepOne(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                  );
                case "step2":
                  return StepTwo(
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                  );
                case "step3":
                  return StepThree(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    stepThreeTimeStamp: result.data.sos.tuStep3!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                  );
                case "step4":
                  return StepFour(
                      getToken: widget.getToken,
                      timeStamp: result.data.sos.createdAt,
                      userName: result.data.sos.userName,
                      userTel: result.data.sos.userTel.toString(),
                      problem: result.data.sos.problem,
                      problemDetails: result.data.sos.problemDetail,
                      location: result.data.sos.location,
                      userProfile: result.data.sos.avatar,
                      imgIncident: result.data.imgIncident![0].image,
                      stepTwoTimeStamp: result.data.sos.tuStep2!,
                      stepThreeTimeStamp: result.data.sos.tuStep3!,
                      stepFourTimeStamp: result.data.sos.tuStep4!,
                      repairPrice: result.data.sos.repairPrice.toString(),
                      repairDetails: result.data.sos.repairDetail!,
                      tncName: result.data.sos.tncName!,
                      tncStatus: result.data.sos.tncStatus!,
                      tncProfile: result.data.sos.tncAvatar,
                      imgBfwork:
                          result.data.sos.tncStatus == "ช่างถึงหน้างานเเล้ว"
                              ? result.data.imgBfwork![0].image
                              : null);
                case "step5":
                  return StepFive(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    stepThreeTimeStamp: result.data.sos.tuStep3!,
                    stepFourTimeStamp: result.data.sos.tuStep4!,
                    stepFiveTimeStamp: result.data.sos.tuStep5!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                  );
                case "step6":
                  return StepSix(
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    stepThreeTimeStamp: result.data.sos.tuStep3!,
                    stepFourTimeStamp: result.data.sos.tuStep4!,
                    stepFiveTimeStamp: result.data.sos.tuStep5!,
                    stepSixTimeStamp: result.data.sos.tuStep6!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                    qrCode: result.data.qrCode![0].image,
                  );
                case "step7":
                  return StepSeven(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    stepThreeTimeStamp: result.data.sos.tuStep3!,
                    stepFourTimeStamp: result.data.sos.tuStep4!,
                    stepFiveTimeStamp: result.data.sos.tuStep5!,
                    stepSixTimeStamp: result.data.sos.tuStep6!,
                    stepSevenTimeStamp: result.data.sos.tuStep7!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                    qrCode: result.data.qrCode![0].image,
                    rate: result.data.sos.rate!,
                    review: result.data.sos.review!,
                    userSlip: result.data.userSlip![0].image,
                  );
                case "step8":
                  return StepEight(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    stepThreeTimeStamp: result.data.sos.tuStep3!,
                    stepFourTimeStamp: result.data.sos.tuStep4!,
                    stepFiveTimeStamp: result.data.sos.tuStep5!,
                    stepSixTimeStamp: result.data.sos.tuStep6!,
                    stepSevenTimeStamp: result.data.sos.tuStep7!,
                    stepEightTimeStamp: result.data.sos.tuStep8!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                    qrCode: result.data.qrCode![0].image,
                    rate: result.data.sos.rate!,
                    review: result.data.sos.review!,
                    userSlip: result.data.userSlip![0].image,
                  );
                case "user_reject_deal":
                  return UserReject(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    stepThreeTimeStamp: result.data.sos.tuStep3!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                  );
                case "success":
                  return StepEight(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    userTel: result.data.sos.userTel.toString(),
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2!,
                    stepThreeTimeStamp: result.data.sos.tuStep3!,
                    stepFourTimeStamp: result.data.sos.tuStep4!,
                    stepFiveTimeStamp: result.data.sos.tuStep5!,
                    stepSixTimeStamp: result.data.sos.tuStep6!,
                    stepSevenTimeStamp: result.data.sos.tuStep7!,
                    stepEightTimeStamp: result.data.sos.tuSc!,
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork![0].image,
                    qrCode: result.data.qrCode![0].image,
                    rate: result.data.sos.rate!,
                    review: result.data.sos.review!,
                    userSlip: result.data.userSlip![0].image,
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
