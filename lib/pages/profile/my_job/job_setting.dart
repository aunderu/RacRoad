import 'package:flutter/material.dart';
import 'package:rac_road/utils/colors.dart';

class JobSettings extends StatefulWidget {
  const JobSettings({super.key});

  @override
  State<JobSettings> createState() => _JobSettingsState();
}

class _JobSettingsState extends State<JobSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่าอาชีพ'),
        centerTitle: true,
        backgroundColor: mainGreen,
      ),
    );
  }
}
