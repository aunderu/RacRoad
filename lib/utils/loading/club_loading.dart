import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../colors.dart';


class ClubDetailsLoading extends StatelessWidget {
  const ClubDetailsLoading({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: lightGrey,
                        child: Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: lightGrey,
                        child: Container(
                          color: Colors.white,
                          height: 10,
                          width: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: lightGrey,
                      child: Container(
                        width: size.width * 0.25,
                        height: size.height * 0.04,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: const AlignmentDirectional(0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  0,
                  size.height * 0.01,
                  size.width * 0.03,
                  size.height * 0.01,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: lightGrey,
                      child: Container(
                        color: Colors.white,
                        height: 160,
                        width: size.width * 0.55,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: lightGrey,
                            child: Container(
                              color: Colors.white,
                              width: 30,
                              height: 10,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: lightGrey,
                            child: Container(
                              color: Colors.white,
                              width: 70,
                              height: 7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: lightGrey,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}