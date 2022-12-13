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

class TimeLinePage extends StatefulWidget {
  final String getToken;
  final String sos_id;
  const TimeLinePage({
    super.key,
    required this.getToken,
    required this.sos_id,
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
          future: RemoteService().getSosDetails(widget.sos_id),
          builder: (context, snapshot) {
            var result = snapshot.data;
            if (result != null) {
              switch ("step6") {
                case "step1":
                  return StepOne(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    // userTel: result.data.sos.userTel,
                    userTel: "เบอร์",
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
                    // userTel: result.data.sos.userTel,
                    userTel: "เบอร์",
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2.toString(),
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                  );
                case "step3":
                  return StepThree(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    // userTel: result.data.sos.userTel,
                    userTel: "เบอร์",
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2.toString(),
                    stepThreeTimeStamp: result.data.sos.tuStep3.toString(),
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                  );
                case "step4":
                  return StepFour(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    // userTel: result.data.sos.userTel,
                    userTel: "result.data.sos.userTel",
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2.toString(),
                    stepThreeTimeStamp: result.data.sos.tuStep3.toString(),
                    stepFourTimeStamp: result.data.sos.tuStep4.toString(),
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork == null
                        ? null
                        : result.data.imgBfwork![0].image,
                  );
                case "step5":
                  return StepFive(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    // userTel: result.data.sos.userTel,
                    userTel: "result.data.sos.userTel",
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2.toString(),
                    stepThreeTimeStamp: result.data.sos.tuStep3.toString(),
                    stepFourTimeStamp: result.data.sos.tuStep4.toString(),
                    stepFiveTimeStamp: result.data.sos.tuStep5.toString(),
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork == null
                        ? null
                        : result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork == null
                        ? null
                        : result.data.imgAfwork![0].image,
                  );
                case "step6":
                  return StepSix(
                    getToken: widget.getToken,
                    sosId: result.data.sos.sosId,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    // userTel: result.data.sos.userTel,
                    userTel: "result.data.sos.userTel",
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2.toString(),
                    stepThreeTimeStamp: result.data.sos.tuStep3.toString(),
                    stepFourTimeStamp: result.data.sos.tuStep4.toString(),
                    stepFiveTimeStamp: result.data.sos.tuStep5.toString(),
                    stepSixTimeStamp: result.data.sos.tuStep6.toString(),
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork == null
                        ? null
                        : result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork == null
                        ? null
                        : result.data.imgAfwork![0].image,
                    qrCode: result.data.qrCode == null
                        ? null
                        : result.data.qrCode![0].image,
                  );
                case "step7":
                  return StepSeven(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    // userTel: result.data.sos.userTel,
                    userTel: "result.data.sos.userTel",
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2.toString(),
                    stepThreeTimeStamp: result.data.sos.tuStep3.toString(),
                    stepFourTimeStamp: result.data.sos.tuStep4.toString(),
                    stepFiveTimeStamp: result.data.sos.tuStep5.toString(),
                    stepSixTimeStamp: result.data.sos.tuStep6.toString(),
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork == null
                        ? null
                        : result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork == null
                        ? null
                        : result.data.imgAfwork![0].image,
                    qrCode: result.data.qrCode == null
                        ? null
                        : result.data.qrCode![0].image,
                  );
                case "step8":
                  return StepEight(
                    getToken: widget.getToken,
                    timeStamp: result.data.sos.createdAt,
                    userName: result.data.sos.userName,
                    // userTel: result.data.sos.userTel,
                    userTel: "result.data.sos.userTel",
                    problem: result.data.sos.problem,
                    problemDetails: result.data.sos.problemDetail,
                    location: result.data.sos.location,
                    userProfile: result.data.sos.avatar,
                    imgIncident: result.data.imgIncident![0].image,
                    stepTwoTimeStamp: result.data.sos.tuStep2.toString(),
                    stepThreeTimeStamp: result.data.sos.tuStep3.toString(),
                    stepFourTimeStamp: result.data.sos.tuStep4.toString(),
                    stepFiveTimeStamp: result.data.sos.tuStep5.toString(),
                    stepSixTimeStamp: result.data.sos.tuStep6.toString(),
                    repairPrice: result.data.sos.repairPrice.toString(),
                    repairDetails: result.data.sos.repairDetail!,
                    tncName: result.data.sos.tncName!,
                    tncStatus: result.data.sos.tncStatus!,
                    tncProfile: result.data.sos.tncAvatar,
                    imgBfwork: result.data.imgBfwork == null
                        ? null
                        : result.data.imgBfwork![0].image,
                    imgAfwork: result.data.imgAfwork == null
                        ? null
                        : result.data.imgAfwork![0].image,
                    qrCode: result.data.qrCode == null
                        ? null
                        : result.data.qrCode![0].image,
                  );
                default:
                  const Text('test');
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
