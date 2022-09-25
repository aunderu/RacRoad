import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/screens.dart';


class SetGPSPage extends StatefulWidget {
  const SetGPSPage({super.key});

  @override
  State<SetGPSPage> createState() => _SetGPSPageState();
}

class _SetGPSPageState extends State<SetGPSPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              size.width * 0.15,
              size.height * 0.2,
              size.width * 0.15,
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'เปิดใช้งาน Location',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Image.asset(
                  'assets/icons/gps_icon.png',
                  height: 150,
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  'คุณจะเปิดใช้งาน Location\nของคุณเพื่อใช้งาน Rac Road',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 1, size.height * 0.05),
                    backgroundColor: mainGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreensPage(),
                      ),
                    );
                  },
                  child: const Text('เปิดใช้งาน Location'),
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  'ข้าม',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
