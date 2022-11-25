import 'package:flutter/material.dart';
import 'package:rac_road/colors.dart';

class ClubSettings extends StatefulWidget {
  const ClubSettings({super.key});

  @override
  State<ClubSettings> createState() => _ClubSettingsState();
}

class _ClubSettingsState extends State<ClubSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่าคลับ'),
        centerTitle: true,
        backgroundColor: mainGreen,
      ),
    );
  }
}
