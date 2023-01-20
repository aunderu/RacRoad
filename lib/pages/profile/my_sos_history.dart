import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/models/all_my_sos_models.dart';
import 'package:rac_road/services/remote_service.dart';

import 'my_sos_history_widget.dart';

class MySosHistory extends StatefulWidget {
  final String getToken;
  const MySosHistory({
    super.key,
    required this.getToken,
  });

  @override
  State<MySosHistory> createState() => _MySosHistoryState();
}

class _MySosHistoryState extends State<MySosHistory> {
  late Future<AllMySos?> dataFuture;

  @override
  void initState() {
    super.initState();

    dataFuture = RemoteService().getAllMySos(widget.getToken);
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
              'การแจ้งเหตุฉุกเฉินของคุณที่ผ่านมา',
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
        child: FutureBuilder<AllMySos?>(
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
                          return MySosHistoryWidget(
                            getToken: widget.getToken,
                            sosId: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .sosId,
                            imgAccident: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .imageIncident[0]
                                .image,
                            userName: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .userName,
                            sosStatus: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .sosStatus,
                            userProblem: snapshot
                                .data!
                                .data
                                .sos![
                                    snapshot.data!.data.sos!.length - 1 - index]
                                .problem,
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
                  return const Center(child: Text("ดูเหมือนมีอะไรผิดปกติ :("));
                } else if (snapshot.data!.count != 0) {
                  return ListView.builder(
                    itemCount: snapshot.data!.count,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return MySosHistoryWidget(
                        getToken: widget.getToken,
                        sosId: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .sosId,
                        imgAccident: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .imageIncident[0]
                            .image,
                        userName: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .userName,
                        sosStatus: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .sosStatus,
                        userProblem: snapshot
                            .data!
                            .data
                            .sos![snapshot.data!.data.sos!.length - 1 - index]
                            .problem,
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
                      'ดูเหมือนคุณยังไม่ได้แจ้งอะไรนะ',
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
