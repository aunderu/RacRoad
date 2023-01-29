import 'package:flutter/material.dart';

class Timelines {
  Timelines(
    this.timestamp,
    this.title,
    this.body,
    this.profile,
    this.name,
    this.isSentByMe,
  );

  Widget body;
  String isSentByMe;
  String name;
  String profile;
  DateTime timestamp;
  String? title;
}
