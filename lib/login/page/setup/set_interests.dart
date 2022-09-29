import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/screens.dart';
import 'package:rac_road/models/category.dart';

import 'items.dart';
import 'picked_interests.dart';

class SetInterestsPage extends StatefulWidget {
  const SetInterestsPage({super.key});

  @override
  State<SetInterestsPage> createState() => _SetInterestsPageState();
}

class _SetInterestsPageState extends State<SetInterestsPage> {
  List<Category> pickInterest = [];
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
              0,
              size.height * 0.2,
              0,
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Interests',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...List.generate(
                            categoryList.length,
                            (index) => Items(
                              size: size,
                              category: categoryList[index],
                              onSelected: (bool value) {
                                if (value) {
                                  pickInterest.add(categoryList[index]);
                                } else {
                                  pickInterest.remove(categoryList[index]);
                                }
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      height: 100,
                      width: double.infinity,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ...List.generate(
                            pickInterest.length,
                            (index) => PickInterests(
                              title: pickInterest[index].title,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.width * 0.12,
                        right: size.width * 0.12,
                      ),
                      child: ElevatedButton(
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
                        child: const Text('ยืนยัน'),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}


