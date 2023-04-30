
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:rac_road/loading/timeline.dart';
import 'package:rac_road/models/sos/sos_details_models.dart';
import 'package:rac_road/services/remote_service.dart';

import '../../../../../colors.dart';
import 'step_1.dart';
import 'step_2.dart';
import 'step_3.dart';

class StepPage extends StatefulWidget {
  const StepPage({
    super.key,
    required this.getToken,
    required this.sosId,
  });

  final String getToken;
  final String sosId;

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
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
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(
          waterDropColor: mainGreen,
        ),
        controller: _refreshController,
        reverse: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: FutureBuilder<SosDetails?>(
              future: _dataFuture,
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
                        imgIncident: result.data.imgIncident,
                        tncName: result.data.sos.tncName!,
                        tncAvatar: result.data.sos.tncAvatar!,
                        tncStatus: result.data.sos.tncStatus!,
                        latitude: result.data.sos.latitude,
                        longitude: result.data.sos.longitude,
                        imgBfwork:
                            result.data.sos.tncStatus == "ช่างถึงหน้างานเเล้ว"
                                ? result.data.imgBfwork!
                                : null,
                        tncNote: result.data.sos.tncDescription,
                        userDeal: result.data.sos.userDeal2,
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
                        imgIncident: result.data.imgIncident,
                        tncName: result.data.sos.tncName!,
                        tncAvatar: result.data.sos.tncAvatar!,
                        tncStatus: result.data.sos.tncStatus!,
                        latitude: result.data.sos.latitude,
                        longitude: result.data.sos.longitude,
                        imgBfwork: result.data.imgBfwork!,
                        imgAfwork: result.data.imgAfwork!,
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
                        imgIncident: result.data.imgIncident,
                        tncName: result.data.sos.tncName!,
                        tncAvatar: result.data.sos.tncAvatar!,
                        tncStatus: result.data.sos.tncStatus!,
                        latitude: result.data.sos.latitude,
                        longitude: result.data.sos.longitude,
                        imgBfwork: result.data.imgBfwork!,
                        imgAfwork: result.data.imgAfwork!,
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
                        imgIncident: result.data.imgIncident,
                        tncName: result.data.sos.tncName!,
                        tncAvatar: result.data.sos.tncAvatar!,
                        tncStatus: result.data.sos.tncStatus!,
                        latitude: result.data.sos.latitude,
                        longitude: result.data.sos.longitude,
                        imgBfwork: result.data.imgBfwork!,
                        imgAfwork: result.data.imgAfwork!,
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
                        imgIncident: result.data.imgIncident,
                        tncName: result.data.sos.tncName!,
                        tncAvatar: result.data.sos.tncAvatar!,
                        tncStatus: result.data.sos.tncStatus!,
                        latitude: result.data.sos.latitude,
                        longitude: result.data.sos.longitude,
                        imgBfwork: result.data.imgBfwork!,
                        imgAfwork: result.data.imgAfwork!,
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
                        imgIncident: result.data.imgIncident,
                        tncName: result.data.sos.tncName!,
                        tncAvatar: result.data.sos.tncAvatar!,
                        tncStatus: result.data.sos.tncStatus!,
                        latitude: result.data.sos.latitude,
                        longitude: result.data.sos.longitude,
                        imgBfwork: result.data.imgBfwork!,
                        imgAfwork: result.data.imgAfwork!,
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
        ),
      ),
    );
  }
}
