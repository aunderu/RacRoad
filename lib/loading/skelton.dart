import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../colors.dart';

class Skelton extends StatelessWidget {
  final double? height, width;
  const Skelton({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: primaryBGColor,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: primaryBGColor,
        ),
      ),
    );
  }
}
