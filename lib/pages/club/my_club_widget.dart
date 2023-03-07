import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';

class MyClubWidget extends StatelessWidget {
  const MyClubWidget({
    super.key,
    this.clubProfile,
    required this.clubName,
    required this.clubDescription,
  });

  final String? clubProfile;
  final String clubName;
  final String clubDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: () {},
        child: Ink(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x34090F13),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: clubProfile != null
                    ? CachedNetworkImage(
                        imageUrl: clubProfile!,
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          color: const Color(0xFFEBEBEB),
                        ),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: double.infinity,
                        color: Colors.white,
                        child: const Icon(
                          Icons.group,
                          size: 50,
                          color: darkGray,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clubName,
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      clubDescription,
                      style: GoogleFonts.sarabun(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
