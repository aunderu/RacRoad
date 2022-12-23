import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StepFive extends StatefulWidget {
  final String getToken;
  final DateTime timeStamp;
  final String userName;
  final String userTel;
  final String problem;
  final String problemDetails;
  final String location;
  final String userProfile;
  final String imgIncident;
  final DateTime stepTwoTimeStamp;
  final DateTime stepThreeTimeStamp;
  final DateTime stepFourTimeStamp;
  final DateTime stepFiveTimeStamp;
  final String repairPrice;
  final String repairDetails;
  final String tncName;
  final String tncStatus;
  final String? tncProfile;
  final String? imgBfwork;
  final String? imgAfwork;
  const StepFive({
    super.key,
    required this.getToken,
    required this.timeStamp,
    required this.userName,
    required this.userTel,
    required this.problem,
    required this.problemDetails,
    required this.location,
    required this.userProfile,
    required this.imgIncident,
    required this.stepTwoTimeStamp,
    required this.stepThreeTimeStamp,
    required this.stepFourTimeStamp,
    required this.stepFiveTimeStamp,
    required this.repairPrice,
    required this.repairDetails,
    required this.tncName,
    required this.tncStatus,
    this.tncProfile,
    this.imgBfwork,
    this.imgAfwork,
  });

  @override
  State<StepFive> createState() => _StepFiveState();
}

class _StepFiveState extends State<StepFive> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 100),
        // ช่างเสร็จงาน
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 239, 185),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(85, 255, 239, 185),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(-3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.stepFiveTimeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'ช่างรับงานและออกปฏิบัติงาน',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'สถานะ : ${widget.tncStatus}',
                              style: GoogleFonts.sarabun(),
                            ),
                          ),
                          widget.imgBfwork == null
                              ? const SizedBox.shrink()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 20, 0),
                                      child: Text(
                                        'รูปก่อนเริ่มงาน : ',
                                        style: GoogleFonts.sarabun(),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 5, 0, 5),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.imgBfwork.toString(),
                                          height: 200,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          widget.imgAfwork == null
                              ? const SizedBox.shrink()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 20, 0),
                                      child: Text(
                                        'รูปหลังเสร็จงาน : ',
                                        style: GoogleFonts.sarabun(),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 5, 0, 5),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.imgAfwork.toString(),
                                          height: 200,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Image.network(
                                  widget.tncProfile ??
                                      'https://racroad.com/img/admin.71db083f.jpg',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                widget.tncName,
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // ช่างที่เลือก
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 195, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x352F44CA),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(-3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.stepFourTimeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'ช่างที่เลือก',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.tncName,
                                style: GoogleFonts.sarabun(),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 30,
                                height: 30,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Image.network(
                                    widget.tncProfile ??
                                        'https://racroad.com/img/admin.71db083f.jpg',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Image.asset(
                                  'assets/imgs/oparator.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                'เจ้าหน้าที่ Racroad',
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // เรียบร้อย เรากำลังหาช่างให้คุณ
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 195, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x352F44CA),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(-3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.stepThreeTimeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'เรียบร้อย! เรากำลังหาช่างในพื้นที่ใกล้เคียงให้คุณ',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Image.asset(
                                  'assets/imgs/oparator.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                'เจ้าหน้าที่ Racroad',
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //ผู้ยืนยันค่าบริการดังกล่าว
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
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
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.stepThreeTimeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'ฉันยืนยันค่าบริการดังกล่าว',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Image.network(
                                widget.userProfile,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                widget.userName,
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
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
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 185, 195, 255),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x352F44CA),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(-3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.stepTwoTimeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'เสนอค่าบริการซ่อม',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            'ราคาการซ่อม : ${widget.repairPrice}\nรายละเอียดเพิ่มเติม : ${widget.repairDetails}',
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Image.asset(
                                  'assets/imgs/oparator.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                'เจ้าหน้าที่ Racroad',
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
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
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
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
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('d MMMM y เวลา KK:mm น.')
                                .format(widget.timeStamp),
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0x392E2E2E),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: Text(
                              'เเจ้งเหตุการณ์',
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'ชื่อผู้ใช้ : ${widget.userName}\nเบอร์โทร : ${widget.userTel}\n\nปัญหา : ${widget.problem}\nรายละเอียดปัญหา : ${widget.problemDetails}\n\nที่เกิดเหตุ : ${widget.location}',
                            style: GoogleFonts.sarabun(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                          child: CachedNetworkImage(
                            imageUrl: widget.imgIncident,
                            height: 200,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Image.network(
                                widget.userProfile,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                widget.userName,
                                style: GoogleFonts.sarabun(),
                              ),
                            ),
                          ],
                        ),
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
