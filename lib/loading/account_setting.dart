import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../colors.dart';

class AccountSettingLoading extends StatelessWidget {
  const AccountSettingLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Shimmer.fromColors(
                baseColor: primaryBGColor,
                highlightColor: Colors.white,
                child: Container(
                  width: 70,
                  height: 70,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: primaryBGColor,
                highlightColor: Colors.white,
                child: Container(
                  width: 150,
                  height: 20,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: primaryBGColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                child: Shimmer.fromColors(
                  baseColor: primaryBGColor,
                  highlightColor: Colors.white,
                  child: Container(
                    width: 200,
                    height: 15,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: primaryBGColor,
                    ),
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
