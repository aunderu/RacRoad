import 'package:flutter/material.dart';

// TAF = Technician application form
class TAFpage extends StatefulWidget {
  TAFpage({Key? key}) : super(key: key);

  @override
  State<TAFpage> createState() => _TAFpageState();
}

class _TAFpageState extends State<TAFpage> {
  TextEditingController? addressController;
  TextEditingController? serviceTimeController;
  TextEditingController? serviceTypeController;
  TextEditingController? workHistoryController;
  TextEditingController? tel1Controller;
  TextEditingController? tel2Controller;
  TextEditingController? serviceZoneController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    serviceTimeController = TextEditingController();
    serviceTypeController = TextEditingController();
    workHistoryController = TextEditingController();
    tel1Controller = TextEditingController();
    tel2Controller = TextEditingController();
    serviceZoneController = TextEditingController();
  }

  @override
  void dispose() {
    addressController?.dispose();
    serviceTimeController?.dispose();
    serviceTypeController?.dispose();
    workHistoryController?.dispose();
    tel1Controller?.dispose();
    tel2Controller?.dispose();
    serviceZoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(),
    );
  }
}
