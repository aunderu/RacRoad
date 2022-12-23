import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingTimeLine extends StatefulWidget {
  const LoadingTimeLine({super.key});

  @override
  State<LoadingTimeLine> createState() => _LoadingTimeLineState();
}

class _LoadingTimeLineState extends State<LoadingTimeLine> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 100),
        //ผู้ยืนยันค่าบริการ
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 182, 235, 255),
                highlightColor: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 182, 235, 255),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3571DAFF),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //รายละเอียดค่าบริการ
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 185, 195, 255),
                highlightColor: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 185, 195, 255),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3571DAFF),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        //ผู้ใช้แจ้งเหตุการณ์
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 182, 235, 255),
                highlightColor: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 182, 235, 255),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3571DAFF),
                        spreadRadius: 3,
                        blurRadius: 2,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
