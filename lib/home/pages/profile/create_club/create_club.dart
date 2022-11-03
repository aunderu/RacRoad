import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:rac_road/colors.dart';

import '../../../../models/category.dart';
import 'items.dart';
import 'picked_interests.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({super.key});

  @override
  State<CreateClubPage> createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  TextEditingController? clubNameController;
  TextEditingController? clubDescriptionController;

  @override
  void initState() {
    super.initState();
    clubNameController = TextEditingController();
    clubDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    clubNameController?.dispose();
    clubDescriptionController?.dispose();
    super.dispose();
  }

  int activeIndex = 0;
  int totalIndex = 3;
  List<Category> pickInterest = [];
  int _itemTotal = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (activeIndex != 0) {
          activeIndex--;
          setState(() {});
          return true;
        }
        return true;
      },
      child: Scaffold(
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
        body: bodyBuilder(size),
      ),
    );
  }

  Widget bodyBuilder(Size size) {
    switch (activeIndex) {
      case 0:
        return formClubName();
      case 1:
        return formClubDescription();
      case 2:
        return formClubTags(size);
      default:
        return formClubName();
    }
  }

  Widget formClubName() {
    return Form(
      key: basicFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotStepper(
                  activeStep: activeIndex,
                  dotCount: totalIndex,
                  dotRadius: 20.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                ),
                SizedBox(height: 10),
                Text(
                  'ตั้งชื่อคลับของคุณ',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'คุณอาจใช้ชื่อรถที่คุณรัก เพื่อดึงดูดคนที่มีความสนใจเดียวกับคุณและร่วมพูดคุยแลกเปลี่ยนร่วมกัน',
                  style: GoogleFonts.sarabun(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: clubNameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อคลับ',
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
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(
                    errorText: "กรุณากรอกชื่อคลับด้วย",
                  ),
                  MinLengthValidator(
                    4,
                    errorText: "ชื่อคลับห้ามต่ำกว่า 3 ตัวอักษร",
                  )
                ]),
                style: GoogleFonts.sarabun(),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (basicFormKey.currentState?.validate() ?? false) {
                  // next
                  setState(() {
                    activeIndex++;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainGreen,
                minimumSize: const Size(
                  300,
                  40,
                ),
              ),
              child: Text(
                'ถัดไป',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formClubDescription() {
    return Form(
      key: basicFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotStepper(
                  activeStep: activeIndex,
                  dotCount: totalIndex,
                  dotRadius: 20.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                ),
                SizedBox(height: 10),
                Text(
                  'อธิบายคลับของคุณสักหน่อย',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'คำอธิบายคลับเป็นสิ่งที่ทำให้ผู้ที่สนใจคลับของคุณรู้ว่าคลับของคุณเกี่ยวกับสิ่งใด',
                  style: GoogleFonts.sarabun(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: clubDescriptionController,
                decoration: InputDecoration(
                  labelText: 'คำอธิบายคลับ',
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
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(
                    errorText: "กรุณากรอกชื่อคลับด้วย",
                  ),
                  MinLengthValidator(
                    4,
                    errorText: "ชื่อคลับห้ามต่ำกว่า 3 ตัวอักษร",
                  )
                ]),
                style: GoogleFonts.sarabun(),
                
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (basicFormKey.currentState?.validate() ?? false) {
                  // next
                  setState(() {
                    activeIndex++;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainGreen,
                minimumSize: const Size(
                  300,
                  40,
                ),
              ),
              child: Text(
                'ถัดไป',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formClubTags(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotStepper(
                  activeStep: activeIndex,
                  dotCount: 3,
                  dotRadius: 20.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                ),
                SizedBox(height: 10),
                Text(
                  'คุณคิดว่าคลับ ${clubNameController!.text} ของคุณอยู่หมวดหมู่อะไร',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'หมวดหมู่จะช่วยให้คนที่มีความสนใจเดียวกันหาเจอได้ง่ายขึ้น คุณสามารถเลือกได้สูงสุด 3 หมวดหมู่',
                  style: GoogleFonts.sarabun(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (basicFormKey.currentState?.validate() ?? false) {
                  // next
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainGreen,
                minimumSize: const Size(
                  300,
                  40,
                ),
              ),
              child: Text(
                'ถัดไป',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
