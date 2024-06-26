import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../utils/api_url.dart';
import '../../../utils/colors.dart';

// TAF = Technician application form
class TAFpage extends StatefulWidget {
  const TAFpage({Key? key, required this.getToken}) : super(key: key);

  final String getToken;

  @override
  State<TAFpage> createState() => _TAFpageState();
}

class _TAFpageState extends State<TAFpage> {
  TextEditingController? addressController;
  int currentStep = 0;
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  bool isCompleted = false;
  TextEditingController? serviceTimeController;
  TextEditingController? serviceTypeController;
  TextEditingController? serviceZoneController;
  TextEditingController? stdHistoryController;
  TextEditingController? tel1Controller;
  TextEditingController? tel2Controller;
  TextEditingController? tncNameController;
  TextEditingController? workHistoryController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    addressController?.dispose();
    serviceTimeController?.dispose();
    serviceTypeController?.dispose();
    workHistoryController?.dispose();
    tel1Controller?.dispose();
    tel2Controller?.dispose();
    serviceZoneController?.dispose();
    stdHistoryController?.dispose();
    tncNameController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    addressController = TextEditingController();
    serviceTimeController = TextEditingController();
    serviceTypeController = TextEditingController();
    workHistoryController = TextEditingController();
    tel1Controller = TextEditingController();
    tel2Controller = TextEditingController();
    serviceZoneController = TextEditingController();
    stdHistoryController = TextEditingController();
    tncNameController = TextEditingController();
    super.initState();
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('ประสบการณ์การทำงาน'),
          content: Form(
            key: formKeys[0],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: workHistoryController,
                        decoration: InputDecoration(
                          labelText: 'คุณมีประสบการณ์ทำงานที่ไหนบ้าง ?',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ตัวอย่าง : เคยทำงานที่ บริษัท *** จังหวัดยะลา 2 ปี',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: stdHistoryController,
                        decoration: InputDecoration(
                          labelText: 'ประวัติการศึกษา',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'เขียนประวัติการศึกษาของคุณ',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('ข้อมูลการติดต่อ'),
          content: Form(
            key: formKeys[1],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: tncNameController,
                        decoration: InputDecoration(
                          labelText: 'ชื่ออู่ หรือ ชื่อช่างของคุณ',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 154, 154),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 231, 208, 208),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "กรุณากรอกข้อมูลด้วย";
                          return null;
                        },
                        style: GoogleFonts.sarabun(),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ตัวอย่าง : ช่างอั๋น การช่าง 24 ช.ม.',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: tel1Controller,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทร',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 154, 154),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 231, 208, 208),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "กรุณากรอกข้อมูลด้วย";
                          return null;
                        },
                        style: GoogleFonts.sarabun(),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'จำเป็นต้องระบุ',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: tel2Controller,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทรสำรอง',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 154, 154),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 231, 208, 208),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ไม่จำเป็นต้องระบุ',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'ที่อยู่ของคุณ',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 154, 154),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 231, 208, 208),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "กรุณากรอกข้อมูลด้วย";
                          return null;
                        },
                        style: GoogleFonts.sarabun(),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ที่อยู่ของร้านของคุณ',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('ข้อมูลการให้บริการ'),
          content: Form(
            key: formKeys[2],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: serviceTypeController,
                        decoration: InputDecoration(
                          labelText: 'คุณทำงานแนวไหน ?',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 154, 154),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 231, 208, 208),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "กรุณากรอกข้อมูลด้วย";
                          return null;
                        },
                        style: GoogleFonts.sarabun(),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ตัวอย่าง : ลากรถ, เปลี่ยนอะไหล่',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          controller: serviceZoneController,
                          decoration: InputDecoration(
                            labelText: 'พื้นที่ให้บริการของคุณ',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 230, 230, 230),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 204, 232, 255),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 239, 154, 154),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 231, 208, 208),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return "กรุณากรอกข้อมูลด้วย";
                            return null;
                          },
                          style: GoogleFonts.sarabun(),
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ตัวอย่าง : อำเภอโคกโพธิ์ จังหวัดปัตตานี',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: serviceTimeController,
                        decoration: InputDecoration(
                          labelText: 'เวลาให้บริการ',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 204, 232, 255),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 154, 154),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 231, 208, 208),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "กรุณากรอกข้อมูลด้วย";
                          return null;
                        },
                        style: GoogleFonts.sarabun(),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ตัวอย่าง : จ. - ศ. เวลา 09.30 น. - 20.00 น.',
                        style: GoogleFonts.sarabun(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text('เสร็จสิ้น'),
          content: Form(
            key: formKeys[3],
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'ข้อมูลของฉัน',
                          style: GoogleFonts.sarabun(fontSize: 17),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          ': ${tncNameController!.text} ,\n ${workHistoryController!.text} ${stdHistoryController!.text}',
                          style: GoogleFonts.sarabun(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'ติดต่อได้ที่',
                          style: GoogleFonts.sarabun(fontSize: 17),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          ': ${tncNameController!.text} ${addressController!.text}\n${tel1Controller!.text} ${tel2Controller!.text}',
                          style: GoogleFonts.sarabun(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'ข้อมูลการให้บริการ',
                          style: GoogleFonts.sarabun(fontSize: 17),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          ': ประเภท ${serviceTypeController!.text} ที่ ${serviceZoneController!.text}\nเวลาทำการ ${serviceTimeController!.text}',
                          style: GoogleFonts.sarabun(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    Future<void> techSubmit() async {
      if (workHistoryController?.text != "" ||
          stdHistoryController?.text != "" ||
          tncNameController?.text != "" ||
          tel1Controller?.text != "" ||
          addressController?.text != "" ||
          serviceTypeController?.text != "" ||
          serviceZoneController?.text != "" ||
          serviceTimeController?.text != "") {
        final response = await http.post(
          Uri.parse("$currentApi/technician/store"),
          body: {
            'user_id': widget.getToken,
            'address': addressController!.text,
            'tel1': tel1Controller!.text,
            'tel2': tel2Controller?.text,
            'service_zone': serviceZoneController!.text,
            'service_time': serviceTimeController!.text,
            'service_type': serviceTypeController!.text,
            'work_history': workHistoryController!.text,
            'tnc_name': tncNameController!.text,
            'std_history': stdHistoryController!.text,
          },
        );
        try {
          if (response.statusCode == 200) {
            Get.back();
          }
        } catch (e) {
          Get.back();
          throw Exception(jsonDecode(response.body));
        }
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: isCompleted
              ? const SizedBox.shrink()
              : IconButton(
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
        body: isCompleted
            ? formCompleted(widget.getToken)
            : Form(
                key: _formKey,
                child: Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: mainGreen,
                        ),
                  ),
                  child: Stepper(
                    type: StepperType.vertical,
                    steps: getSteps(),
                    currentStep: currentStep,
                    onStepContinue: () {
                      if (formKeys[currentStep].currentState!.validate()) {
                        if (currentStep < getSteps().length - 1) {
                          setState(() {
                            currentStep = currentStep + 1;
                          });
                        } else {
                          if (workHistoryController?.text != "" ||
                              stdHistoryController?.text != "" ||
                              tncNameController?.text != "" ||
                              tel1Controller?.text != "" ||
                              addressController?.text != "" ||
                              serviceTypeController?.text != "" ||
                              serviceZoneController?.text != "" ||
                              serviceTimeController?.text != "") {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            techSubmit();
                            setState(() {
                              isCompleted = true;
                            });
                          }
                        }
                      }
                    },
                    onStepCancel: currentStep == 0
                        ? null
                        : () => setState(() => currentStep -= 1),
                  ),
                ),
              ),
      ),
    );
  }
}

Widget formCompleted(String token) {
  return SizedBox(
    width: double.infinity,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: mainGreen,
            size: 100,
          ),
          const SizedBox(height: 15),
          Text(
            "เราได้ข้อมูลของคุณแล้ว !",
            style: GoogleFonts.sarabun(fontSize: 25),
          ),
          Text(
            "เราจะทำการตรวจสอบข้อมูลของคุณ",
            style: GoogleFonts.sarabun(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Fluttertoast.showToast(
                msg: "ส่งแบบฟอร์มสมัครเป็นช่างเรียบร้อย!",
                backgroundColor: mainGreen,
                fontSize: 17,
              );
              Get.toNamed('/profile-myjob');
            },
            style: ElevatedButton.styleFrom(backgroundColor: mainGreen),
            child: const Text('กลับหน้าแรก'),
          ),
        ],
      ),
    ),
  );
}
