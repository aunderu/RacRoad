import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rac_road/colors.dart';

import 'package:rac_road/loading/timeline.dart';
import 'package:rac_road/models/sos_details_models.dart';
import 'package:rac_road/services/remote_service.dart';

import 'step/step_1.dart';
import 'step/step_2.dart';
import 'step/step_3.dart';
import 'step/step_4.dart';
import 'step/step_5.dart';
import 'step/step_6.dart';
import 'step/step_7.dart';
import 'step/step_8.dart';
import 'step/user_reject.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({
    super.key,
    required this.getToken,
    required this.sosId,
  });

  final String getToken;
  final String sosId;

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  var _dataFuture;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _dataFuture = RemoteService().getSosDetails(widget.sosId);
    setUpTimedFetch();
  }

  setUpTimedFetch() {
    Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (mounted) {
        setState(() {
          _dataFuture = RemoteService().getSosDetails(widget.sosId);
        });
      }
    });
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _dataFuture = RemoteService().getSosDetails(widget.sosId);
    });

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) { 
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: const WaterDropHeader(
        waterDropColor: mainGreen,
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      reverse: true,
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
    );
  }
}