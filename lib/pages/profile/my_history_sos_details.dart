import 'package:flutter/material.dart';

import 'package:rac_road/utils/loading/timeline.dart';
import 'package:rac_road/models/sos/sos_details_models.dart';
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
import '../sos/timeline/step/user_reject_two.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      imgBfwork:
                          result.data.sos.tncStatus == "ช่างถึงหน้างานเเล้ว"
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
                      problemDetails:
                          result.data.sos.problemDetail ?? 'ไม่มีรายละเอียด',
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
        ),
      ),
    );
  }
}
