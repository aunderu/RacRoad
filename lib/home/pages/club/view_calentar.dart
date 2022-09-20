import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewCalentarPage extends StatefulWidget {
  const ViewCalentarPage({super.key});

  @override
  State<ViewCalentarPage> createState() => _ViewCalentarPageState();
}

class _ViewCalentarPageState extends State<ViewCalentarPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/imgs/profile.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'User Name',
                  style: GoogleFonts.sarabun(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: IconButton(
                  hoverColor: Colors.transparent,
                  iconSize: 60,
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            centerTitle: false,
            elevation: 0,
          ),
        ],
        body: Center(
          child: Text(
            "Calentar",
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
