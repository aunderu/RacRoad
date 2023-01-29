import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:rac_road/loading/timeline.dart';
import 'package:rac_road/models/sos_details_models.dart';
import 'package:rac_road/services/remote_service.dart';

import '../sos/timeline/step/step_1.dart';
import '../sos/timeline/step/step_2.dart';
import '../sos/timeline/step/step_3.dart';
import '../sos/timeline/step/step_4.dart';
import '../sos/timeline/step/step_5.dart';
import '../sos/timeline/step/step_6.dart';
import '../sos/timeline/step/step_7.dart';
import '../sos/timeline/step/step_8.dart';
import '../sos/timeline/step/user_reject.dart';

class MyHistorySosDetails extends StatefulWidget {
  const MyHistorySosDetails({
    super.key,
    required this.getToken,
    required this.sosId,
  });

  final String getToken;
  final String sosId;

  @override
  State<MyHistorySosDetails> createState() => _MyHistorySosDetailsState();
}

class _MyHistorySosDetailsState extends State<MyHistorySosDetails> {
  var _dataFuture;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _dataFuture = RemoteService().getSosDetails(widget.sosId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: false,
        controller: _refreshController,
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: FutureBuilder<SosDetails?>(
            future: _dataFuture,
            builder: (context, snapshot) {
              var result = snapshot.data;
              if (result != null) {
                switch (result.data.sos.sosStatus) {
                  case "step1":
                    return StepOne(
                      getToken: widget.getToken,
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                        stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
                      stepOnetimeStamp: result.data.sos.tuStep1,
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
      ),
    );
  }
}
