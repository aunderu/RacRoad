import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_b/colors.dart';
import 'package:project_b/login/page/with_phone.dart';

class LoginMainPage extends StatelessWidget {
  const LoginMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/MainLoginBG.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.2,
            left: size.width * 0.05,
            right: size.width * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Rac Road',
                        style: GoogleFonts.sarabun(
                          fontSize: 50,
                          color: mainGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: size.width * 0.2,
                        bottom: size.height * 0.1,
                      ),
                      child: Text(
                        'Community for all',
                        style: GoogleFonts.sarabun(
                          fontSize: 25,
                          height: -0.01,
                          color: mainGreen,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loginWithGoogle(context),
              SizedBox(height: size.height * 0.02),
              loginWithFacebook(context),
              SizedBox(height: size.height * 0.02),
              loginWithPhone(context),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: size.height * 0.02,
                ),
                child: Text(
                  'มีปัญหาในการเข้าระบบใช่ไหม ?',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    color: Color(0xC8FFFFFF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget loginWithGoogle(BuildContext context) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    color: const Color(0xFFF5F5F5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
          child: Image.asset(
            'assets/icons/google_logo.png',
            width: 40,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
          child: Text(
            'เข้าสู่ระบบด้วย GOOGLE',
            style: GoogleFonts.sarabun(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget loginWithFacebook(BuildContext context) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    color: Color(0xFFF5F5F5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
          child: Image.asset(
            'assets/icons/facebook_logo.png',
            width: 40,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
          child: Text(
            'เข้าสู่ระบบด้วย FACEBOOK',
            style: GoogleFonts.sarabun(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget loginWithPhone(BuildContext context) {
  return InkWell(
    onTap: () async {
      await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WithPhoneNumber(),
      ),
    );
    },
    child: Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
            child: Icon(
              Icons.phone,
              color: Colors.green,
              size: 37,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
            child: Text(
              'เข้าสู่ระบบด้วยหมายเลขโทรศัพท์',
              style: GoogleFonts.sarabun(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
