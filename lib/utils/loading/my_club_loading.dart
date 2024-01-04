import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../colors.dart';


class MyClubLoadingWidget extends StatelessWidget {
  const MyClubLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.22,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Shimmer.fromColors(
              baseColor: lightGrey,
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                color: lightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}