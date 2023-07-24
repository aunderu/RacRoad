import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    super.key,
    this.radius = 8,
    required this.mdFileName,
  }) : assert(mdFileName.contains('.md'),
            'The file must contain the .md extension');

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(children: [
        Expanded(
          child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 150)).then((value) {
              return rootBundle.loadString('assets/$mdFileName');
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Markdown(
                  data: snapshot.data!,
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ปิด'),
        ),
      ]),
    );
  }
}
