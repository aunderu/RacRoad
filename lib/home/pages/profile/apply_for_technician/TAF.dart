import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rac_road/colors.dart';
import 'package:rac_road/home/screens.dart';

// TAF = Technician application form
class TAFpage extends StatefulWidget {
  const TAFpage({Key? key}) : super(key: key);

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
  TextEditingController? stdHistoryController;
  TextEditingController? tncNameController;
  final formKeys = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int currentStep = 0;
  bool isCompleted = false;

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
    stdHistoryController = TextEditingController();
    tncNameController = TextEditingController();
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
    stdHistoryController?.dispose();
    tncNameController?.dispose();
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
      body: isCompleted
          ? formCompleted()
          : Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKeys,
              child: Stepper(
                type: StepperType.vertical,
                steps: getSteps(),
                currentStep: currentStep,
                onStepContinue: () {
                  final isLastStep = currentStep == getSteps().length - 1;

                  if (isLastStep) {
                    setState(() {
                      isCompleted = true;
                    });
                    print('Completed');
                  } else {
                    // if (_formKeys[currentStep].currentState!.validate()) {
                    //   setState(
                    //     () => currentStep += 1,
                    //   );
                    // }
                    setState(
                      () => currentStep += 1,
                    );
                  }
                },
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(
                          () => currentStep -= 1,
                        ),
              ),
            ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('ประสบการณ์การทำงาน'),
          content: Column(
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
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('ข้อมูลการติดต่อ'),
          content: Column(
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
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "กรุณากรอกข้อมูลด้วย";
                      //   } else {
                      //     return null;
                      //   }
                      // },
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
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "กรุณากรอกข้อมูลด้วย";
                      //   } else {
                      //     return null;
                      //   }
                      // },
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
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "กรุณากรอกข้อมูลด้วย";
                      //   } else {
                      //     return null;
                      //   }
                      // },
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
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('ข้อมูลการให้บริการ'),
          content: Column(
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
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "กรุณากรอกข้อมูลด้วย";
                      //   } else {
                      //     return null;
                      //   }
                      // },
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
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "กรุณากรอกข้อมูลด้วย";
                        //   } else {
                        //     return null;
                        //   }
                        // },
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
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "กรุณากรอกข้อมูลด้วย";
                      //   } else {
                      //     return null;
                      //   }
                      // },
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
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text('เสร็จสิ้น'),
          content: Column(
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
      ];
}

Widget formCompleted() {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 200),
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
            Get.to(() => const ScreensPage());
          },
          style: ElevatedButton.styleFrom(backgroundColor: mainGreen),
          child: const Text('กลับหน้าแรก'),
        ),
      ],
    ),
  );
}
