import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rac_road/login/api/google_sign_in_api.dart';
import 'package:rac_road/login/login_main_page.dart';

class LoggedInPage extends StatelessWidget {
  final GoogleSignInAccount user;

  const LoggedInPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบเรียบร้อย'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            child: Text(
              'Logout',
              style: GoogleFonts.sarabun(color: Colors.white),
            ),
            onPressed: () async {
              await GoogleSignInApi.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginMainPage(),
              ));
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: GoogleFonts.sarabun(fontSize: 24),
            ),
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoUrl!),
            ),
            const SizedBox(height: 8),
            Text(
              'ชื่อ : ${user.displayName!}',
              style: GoogleFonts.sarabun(fontSize: 24),
            ),
            Text(
              'อีเมล : ${user.email}',
              style: GoogleFonts.sarabun(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
