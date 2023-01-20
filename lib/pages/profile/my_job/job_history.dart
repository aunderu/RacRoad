import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/models/all_my_tnc_sos_models.dart';
import 'package:rac_road/services/remote_service.dart';

import 'tnc_sos_history_widget.dart';

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
        shadowColor: mainGreen,
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
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
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
                        itemBuilder: (context, index) {
                          return TncSosHistoryWidget(
                            getToken: widget.getToken,
                            sosId: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .sosId,
                            userAvatar: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .avatar,
                            userProblem: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .problem,
                            sosStatus: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .sosStatus,
                            timeStamp: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .createdAt,
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
                } else if (snapshot.data!.count != 0) {
                  return ListView.builder(
                    itemCount: snapshot.data!.count,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return TncSosHistoryWidget(
                        getToken: widget.getToken,
                        sosId: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .sosId,
                        userAvatar: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .avatar,
                        userProblem: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .problem,
                        sosStatus: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .sosStatus,
                        timeStamp: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .createdAt,
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'ดูเหมือนคุณยังไม่มีข้อมูลอะไรนะ',
                      style: GoogleFonts.sarabun(),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
