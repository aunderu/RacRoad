import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rac_road/utils/colors.dart';

import 'package:rac_road/loading/timeline.dart';
import 'package:rac_road/models/sos/sos_details_models.dart';
import 'package:rac_road/pages/sos/timeline/step/user_reject_two.dart';
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
                  imgIncident: result.data.imgIncident,
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
                  imgIncident: result.data.imgIncident,
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
                  imgIncident: result.data.imgIncident,
                  stepTwoTimeStamp: result.data.sos.tuStep2!,
                  stepThreeTimeStamp: result.data.sos.tuStep3!,
                  repairPrice: result.data.sos.repairPrice.toString(),
                  repairDetails: result.data.sos.repairDetail!,
                );
              case "step4":
                return StepFour(
                  getToken: widget.getToken,
                  sosId: result.data.sos.sosId,
                  stepOnetimeStamp: result.data.sos.tuStep1,
                  userName: result.data.sos.userName,
                  userTel: result.data.sos.userTel.toString(),
                  problem: result.data.sos.problem,
                  problemDetails: result.data.sos.problemDetail,
                  location: result.data.sos.location,
                  userProfile: result.data.sos.avatar,
                  imgIncident: result.data.imgIncident,
                  stepTwoTimeStamp: result.data.sos.tuStep2!,
                  stepThreeTimeStamp: result.data.sos.tuStep3!,
                  stepFourTimeStamp: result.data.sos.tuStep4!,
                  repairPrice: result.data.sos.repairPrice.toString(),
                  repairDetails: result.data.sos.repairDetail!,
                  tncName: result.data.sos.tncName,
                  tncStatus: result.data.sos.tncStatus!,
                  tncProfile: result.data.sos.tncAvatar,
                  imgBfwork: result.data.sos.tncStatus == "ช่างถึงหน้างานเเล้ว"
                      ? result.data.imgBfwork
                      : null,
                  priceTwoStatus: result.data.sos.price2Status,
                  repairPriceTwo: result.data.sos.repairPrice2,
                  repairDetailsTwo: result.data.sos.repairDetail2,
                  tuPriceTwoTimeStamp: result.data.sos.tuPrice2,
                  userDealTwo: result.data.sos.userDeal2,
                  tuUserDealTwoTimeStamp: result.data.sos.tuUserDeal2,
                );
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
                  imgIncident: result.data.imgIncident,
                  stepTwoTimeStamp: result.data.sos.tuStep2!,
                  stepThreeTimeStamp: result.data.sos.tuStep3!,
                  stepFourTimeStamp: result.data.sos.tuStep4!,
                  stepFiveTimeStamp: result.data.sos.tuStep5!,
                  repairPrice: result.data.sos.repairPrice.toString(),
                  repairDetails: result.data.sos.repairDetail!,
                  tncName: result.data.sos.tncName!,
                  tncStatus: result.data.sos.tncStatus!,
                  tncProfile: result.data.sos.tncAvatar,
                  imgBfwork: result.data.imgBfwork!,
                  imgAfwork: result.data.imgAfwork!,
                  repairPriceTwo: result.data.sos.repairPrice2,
                  repairDetailsTwo: result.data.sos.repairDetail2,
                  tuPriceTwoTimeStamp: result.data.sos.tuPrice2,
                  userDealTwo: result.data.sos.userDeal2,
                  tuUserDealTwoTimeStamp: result.data.sos.tuUserDeal2,
                  priceTwoStatus: result.data.sos.price2Status!,
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
                  imgIncident: result.data.imgIncident,
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
                  imgBfwork: result.data.imgBfwork!,
                  imgAfwork: result.data.imgAfwork!,
                  qrCode: result.data.sos.qrId!,
                  qrName: result.data.sos.qrName!,
                  qrNumber: result.data.sos.qrNumber!,
                  qrType: result.data.sos.qrType!,
                  repairPriceTwo: result.data.sos.repairPrice2,
                  repairDetailsTwo: result.data.sos.repairDetail2,
                  tuPriceTwoTimeStamp: result.data.sos.tuPrice2,
                  userDealTwo: result.data.sos.userDeal2,
                  tuUserDealTwoTimeStamp: result.data.sos.tuUserDeal2,
                  priceTwoStatus: result.data.sos.price2Status!,
                );
              case "step7":
                return StepSeven(
                  getToken: widget.getToken,
                  sosId: result.data.sos.sosId,
                  stepOnetimeStamp: result.data.sos.tuStep1,
                  userName: result.data.sos.userName,
                  userTel: result.data.sos.userTel.toString(),
                  problem: result.data.sos.problem,
                  problemDetails: result.data.sos.problemDetail,
                  location: result.data.sos.location,
                  userProfile: result.data.sos.avatar,
                  imgIncident: result.data.imgIncident,
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
                  imgBfwork: result.data.imgBfwork!,
                  imgAfwork: result.data.imgAfwork!,
                  qrCode: result.data.sos.qrId!,
                  qrName: result.data.sos.qrName!,
                  qrNumber: result.data.sos.qrNumber!,
                  qrType: result.data.sos.qrType!,
                  repairPriceTwo: result.data.sos.repairPrice2,
                  repairDetailsTwo: result.data.sos.repairDetail2,
                  tuPriceTwoTimeStamp: result.data.sos.tuPrice2,
                  userDealTwo: result.data.sos.userDeal2,
                  tuUserDealTwoTimeStamp: result.data.sos.tuUserDeal2,
                  rate: result.data.sos.rate!,
                  review: result.data.sos.review!,
                  userSlip: result.data.userSlip![0].image,
                  priceTwoStatus: result.data.sos.price2Status!,
                );
              case "step8":
                return StepEight(
                  getToken: widget.getToken,
                  sosId: result.data.sos.sosId,
                  stepOnetimeStamp: result.data.sos.tuStep1,
                  userName: result.data.sos.userName,
                  userTel: result.data.sos.userTel.toString(),
                  problem: result.data.sos.problem,
                  problemDetails: result.data.sos.problemDetail,
                  location: result.data.sos.location,
                  userProfile: result.data.sos.avatar,
                  imgIncident: result.data.imgIncident,
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
                  imgBfwork: result.data.imgBfwork!,
                  imgAfwork: result.data.imgAfwork!,
                  qrCode: result.data.sos.qrId!,
                  qrName: result.data.sos.qrName!,
                  qrNumber: result.data.sos.qrNumber!,
                  qrType: result.data.sos.qrType!,
                  repairPriceTwo: result.data.sos.repairPrice2,
                  repairDetailsTwo: result.data.sos.repairDetail2,
                  tuPriceTwoTimeStamp: result.data.sos.tuPrice2,
                  userDealTwo: result.data.sos.userDeal2,
                  tuUserDealTwoTimeStamp: result.data.sos.tuUserDeal2,
                  rate: result.data.sos.rate!,
                  review: result.data.sos.review!,
                  userSlip: result.data.userSlip![0].image,
                  priceTwoStatus: result.data.sos.price2Status!,
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
                  imgIncident: result.data.imgIncident,
                  stepTwoTimeStamp: result.data.sos.tuStep2!,
                  stepThreeTimeStamp: result.data.sos.tuStep3!,
                  repairPrice: result.data.sos.repairPrice.toString(),
                  repairDetails: result.data.sos.repairDetail!,
                );
              case "user_reject_deal2":
                return UserRejectTwo(
                  stepOnetimeStamp: result.data.sos.tuStep1,
                  userName: result.data.sos.userName,
                  problem: result.data.sos.problem,
                  problemDetails: result.data.sos.problemDetail,
                  location: result.data.sos.location,
                  userProfile: result.data.sos.avatar,
                  imgIncident: result.data.imgIncident,
                  stepTwoTimeStamp: result.data.sos.tuStep2!,
                  stepThreeTimeStamp: result.data.sos.tuStep3!,
                  stepFourTimeStamp: result.data.sos.tuStep4!,
                  repairPrice: result.data.sos.repairPrice.toString(),
                  repairDetails: result.data.sos.repairDetail!,
                  tncName: result.data.sos.tncName!,
                  tncProfile: result.data.sos.tncAvatar,
                  repairDetailsTwo: result.data.sos.repairDetail2,
                  repairPriceTwo: result.data.sos.repairPrice2,
                  tuPriceTwoTimeStamp: result.data.sos.tuPrice2,
                  tuUserDealTwoTimeStamp: result.data.sos.tuUserDeal2,
                  imgBfwork: result.data.imgBfwork!,
                );
              case "success":
                return StepEight(
                  getToken: widget.getToken,
                  sosId: result.data.sos.sosId,
                  stepOnetimeStamp: result.data.sos.tuStep1,
                  userName: result.data.sos.userName,
                  userTel: result.data.sos.userTel.toString(),
                  problem: result.data.sos.problem,
                  problemDetails: result.data.sos.problemDetail,
                  location: result.data.sos.location,
                  userProfile: result.data.sos.avatar,
                  imgIncident: result.data.imgIncident,
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
                  imgBfwork: result.data.imgBfwork!,
                  imgAfwork: result.data.imgAfwork!,
                  qrCode: result.data.sos.qrId!,
                  qrName: result.data.sos.qrName!,
                  qrNumber: result.data.sos.qrNumber!,
                  qrType: result.data.sos.qrType!,
                  repairPriceTwo: result.data.sos.repairPrice2,
                  repairDetailsTwo: result.data.sos.repairDetail2,
                  tuPriceTwoTimeStamp: result.data.sos.tuPrice2,
                  userDealTwo: result.data.sos.userDeal2,
                  tuUserDealTwoTimeStamp: result.data.sos.tuUserDeal2,
                  rate: result.data.sos.rate!,
                  review: result.data.sos.review!,
                  userSlip: result.data.userSlip![0].image,
                  priceTwoStatus: result.data.sos.price2Status!,
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
