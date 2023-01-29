import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../colors.dart';
import '../../../../models/category.dart';

class Items extends StatefulWidget {
  const Items({
    Key? key,
    required this.size,
    required this.category,
    required this.onSelected,
    required this.itemTotal,
  }) : super(key: key);

  final Category category;
  final int itemTotal;
  final ValueChanged<bool> onSelected;
  final Size size;

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;

          widget.onSelected(_isSelected);
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: _isSelected
                    ? Border.all(
                        width: 2.0,
                        color: mainGreen,
                      )
                    : null,
              ),
              child: Image.asset(
                widget.category.logo,
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(height: widget.size.height * 0.01),
            Text(
              widget.category.title,
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
