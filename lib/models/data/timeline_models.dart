import 'package:flutter/material.dart';

class Timelines {
  DateTime timestamp;
  String? title;
  Widget body;
  String profile;
  String name;
  String isSentByMe;

  Timelines(
    this.timestamp,
    this.title,
    this.body,
    this.profile,
    this.name,
    this.isSentByMe,
  );
}
