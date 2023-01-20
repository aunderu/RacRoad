import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../colors.dart';
import 'club_details.dart';

class ClubWidget extends StatelessWidget {
  final String getToken;
  final String clubId;
  final String clubName;
  final String clubAdmin;
  final String clubZone;
  const ClubWidget({
    super.key,
    required this.clubName,
    required this.clubZone,
    required this.clubAdmin,
    required this.getToken, required this.clubId,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        size.width * 0.02,
        0,
        size.width * 0.02,
        size.height * 0.01,
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetailsPage(
                clubId: clubId,
                getToken: getToken,
              ),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFEBEBEB),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // child: Image.network(
                  //   '',
                  //   width: 100,
                  //   height: 100,
                  //   fit: BoxFit.cover,
                  // ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: const Color(0xFFEBEBEB),
                    child: const Icon(
                      Icons.group,
                      size: 50,
                      color: darkGray,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clubName,
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          clubAdmin,
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          clubZone,
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Text(
                      'Unfollow',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
