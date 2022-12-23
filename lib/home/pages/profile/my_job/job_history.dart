import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/pages/profile/my_job/history_widget.dart';
import 'package:rac_road/models/all_my_tnc_sos_models.dart';
import 'package:rac_road/services/remote_service.dart';

class MyJobHistory extends StatefulWidget {
  final String getToken;
  final String tncId;
  const MyJobHistory({
    super.key,
    required this.getToken,
    required this.tncId,
  });

  @override
  State<MyJobHistory> createState() => _MyJobHistoryState();
}

class _MyJobHistoryState extends State<MyJobHistory> {
  late Future<AllMyTncSos?> dataFuture;

  @override
  void initState() {
    super.initState();

    dataFuture = RemoteService().getAllMyTncSos(widget.tncId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryBGColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ประวัติ',
              style: GoogleFonts.sarabun(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              'การทำงานของคุณที่ผ่านมา',
              style: GoogleFonts.sarabun(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: const BoxDecoration(
                color: lightGrey,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(1000.0),
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.close_rounded,
                    size: 25.0,
                    color: darkGray,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: LinearPercentIndicator(
              percent: 1,
              width: MediaQuery.of(context).size.width,
              lineHeight: 12,
              animation: true,
              progressColor: mainGreen,
              backgroundColor: mainGreen,
              barRadius: Radius.circular(0),
              padding: EdgeInsets.zero,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
            child: FutureBuilder<AllMyTncSos?>(
              future: dataFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data!.count,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return HistoryWidget(
                                getToken: widget.getToken,
                                sosId: snapshot.data!.data.sos![index].sosId,
                                userAvatar:
                                    snapshot.data!.data.sos![index].avatar,
                                userName:
                                    snapshot.data!.data.sos![index].userName,
                                sosStatus:
                                    snapshot.data!.data.sos![index].sosStatus,
                                timeStamp:
                                    snapshot.data!.data.sos![index].createdAt,
                              );
                            },
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(mainGreen),
                                strokeWidth: 8,
                              ),
                            ),
                          );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      return const Text("ดูเหมือนมีอะไรผิดปกติ :(");
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.count,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return HistoryWidget(
                            getToken: widget.getToken,
                            sosId: snapshot.data!.data.sos![index].sosId,
                            userAvatar: snapshot.data!.data.sos![index].avatar,
                            userName: snapshot.data!.data.sos![index].userName,
                            sosStatus:
                                snapshot.data!.data.sos![index].sosStatus,
                            timeStamp:
                                snapshot.data!.data.sos![index].createdAt,
                          );
                        },
                      );
                    } else {
                      return const Text('ดูเหมือนคุณยังไม่มีข้อมูลนะ');
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
