import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'package:rac_road/colors.dart';
import 'package:rac_road/models/all_car_models.dart';

import '../../../services/remote_service.dart';

class FindCarPage extends StatefulWidget {
  const FindCarPage({super.key, required this.getToken});

  final String getToken;

  @override
  State<FindCarPage> createState() => _FindCarPageState();
}

class _FindCarPageState extends State<FindCarPage> {
  AllCarModel? allCar;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<CarDatum>? foundCars;
  bool haveCar = false;

  bool isLoaded = false;
  TextEditingController? searchController;

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    getCarData();
  }

  getCarData() async {
    setState(() {
      isLoaded = true;
    });
    allCar = await RemoteService().getAllCar();
    if (allCar != null) {
      final bool haveData = allCar!.data.carData.isNotEmpty;
      if (haveData == true) {
        if (mounted) {
          setState(() {
            haveCar = true;
            foundCars = allCar!.data.carData.toList();
            isLoaded = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            haveCar = false;
            isLoaded = false;
          });
        }
      }
    }
  }

  void _runFilter(String enterdKeyword) {
    List<CarDatum> result;
    if (enterdKeyword.isEmpty) {
      result = allCar!.data.carData;
    } else {
      result = allCar!.data.carData
          .where((car) =>
              car.model.toLowerCase().contains(enterdKeyword.toLowerCase()) ||
              car.brand.toLowerCase().contains(enterdKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundCars = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: formKey,
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
          title: Text(
            'เพิ่มรถของคุณ',
            style: GoogleFonts.sarabun(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainGreen,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/imgs/logos/car.png',
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รถของคุณ',
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            height: 0.8,
                          ),
                        ),
                        Text(
                          'เพิ่มรถสุดโปรดของคุณเพื่อให้คุณรู้เวลาเปลี่ยนอะไหล่ตอนไหน !',
                          style: GoogleFonts.sarabun(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: searchController,
                obscureText: false,
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  labelText: 'ค้นหารุ่นรถของคุณ',
                  labelStyle: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF757575),
                    size: 22,
                  ),
                ),
                style: GoogleFonts.sarabun(),
              ),
              const SizedBox(height: 20),
              isLoaded
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : haveCar
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: foundCars!.length,
                            itemBuilder: (context, index) => Card(
                              key: ValueKey(foundCars![index].carId),
                              color: whiteGrey,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 7),
                              child: ListTile(
                                title: Text(
                                  foundCars![index].brand,
                                  style: GoogleFonts.sarabun(),
                                ),
                                subtitle: Text(
                                  "${foundCars![index].model}, ${foundCars![index].makeover}, ${foundCars![index].subversion}, ${foundCars![index].fuel}",
                                  style: GoogleFonts.sarabun(),
                                ),
                                onTap: () {
                                  Get.defaultDialog(
                                    title: 'เลือกรถ ${foundCars![index].brand}',
                                    middleText:
                                        'รุ่น ${foundCars![index].model} โฉม ${foundCars![index].makeover}, รุ่นย่อย ${foundCars![index].subversion} เชื้อเพลิง ${foundCars![index].fuel} หรือไม่?',
                                    titleStyle: GoogleFonts.sarabun(),
                                    middleTextStyle: GoogleFonts.sarabun(),
                                    textConfirm: "ยืนยัน",
                                    textCancel: "ยกเลิก",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      // showImageDialog(
                                      //     allCar!.data.carData[index].carId);

                                      showFormBottomSheet(
                                        context,
                                        foundCars![index].brand,
                                        foundCars![index].model,
                                        foundCars![index].makeover,
                                        widget.getToken,
                                        foundCars![index].carId,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text('ดูเหมือนยังไม่มีข้อมูลรถในขณะนี้'),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

void showFormBottomSheet(context, String brand, String model, String makeOver,
    String getToken, String carId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) => FormBottomSheet(
      brand: brand,
      model: model,
      makeOver: makeOver,
      getToken: getToken,
      carId: carId,
    ),
  );
}

class FormBottomSheet extends StatefulWidget {
  final String brand;
  final String model;
  final String makeOver;
  final String getToken;
  final String carId;
  const FormBottomSheet({
    super.key,
    required this.brand,
    required this.model,
    required this.makeOver,
    required this.getToken,
    required this.carId,
  });

  @override
  State<FormBottomSheet> createState() => _FormBottomSheetState();
}

class _FormBottomSheetState extends State<FormBottomSheet> {
  TextEditingController? licensePlateController;
  File? imageFile;

  @override
  void initState() {
    super.initState();

    licensePlateController = TextEditingController();
  }

  void showImageDialog(String carId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('กรุณาเลือกรูปรถของคุณ', textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.sarabun(
            color: Colors.black,
            fontSize: 20,
          ),
          alignment: Alignment.center,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  getFromCamera(carId);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'กล้อง',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  getFromGallery(carId);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.black,
                        size: 65,
                      ),
                    ),
                    Text(
                      'รูปภาพ',
                      style: GoogleFonts.sarabun(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getFromGallery(String carId) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      // carSend(imageFile!.path, carId).then((value) => value == true
      //     ? Get.offNamedUntil('/profile', (route) => false)
      //     : null);
    } else {
      Fluttertoast.showToast(
        msg: 'คุณยังไม่ได้เลือกรูป',
        backgroundColor: Colors.yellow[100],
        textColor: Colors.black,
        fontSize: 15,
        gravity: ToastGravity.SNACKBAR,
      );
    }
    Get.back();
  }

  void getFromCamera(String carId) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      // carSend(imageFile!.path, carId).then((value) => value == true
      //     ? Get.offNamedUntil('/profile', (route) => false)
      //     : null);
    } else {
      Fluttertoast.showToast(
        msg: 'คุณยังไม่ได้เลือกรูป',
        backgroundColor: Colors.yellow[100],
        textColor: Colors.black,
        fontSize: 15,
        gravity: ToastGravity.SNACKBAR,
      );
    }
    Get.back();
  }

  Future<bool> carSend(String filePath, String carId, String carPlate) async {
    Map<String, String> headers = {"Context-Type": "multipart/formdata"};
    var requset = http.MultipartRequest(
        "POST", Uri.parse("https://api.racroad.com/api/mycar/store"))
      ..fields.addAll({
        "user_id": widget.getToken,
        "car_id": carId,
        "car_no": carPlate,
      })
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('profile_car', filePath));
    var response = await requset.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'รถ ${widget.brand} รุ่น ${widget.model} โฉม ${widget.makeOver}',
                style: GoogleFonts.sarabun(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              imageFile == null
                  ? Tooltip(
                      message: "โปรไฟล์รถ",
                      verticalOffset: -55,
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 16),
                          child: InkWell(
                            onTap: () async {
                              PermissionStatus cameraStatus =
                                  await Permission.camera.request();
                              if (cameraStatus == PermissionStatus.granted) {
                                showImageDialog(widget.carId);
                              }
                              if (cameraStatus == PermissionStatus.denied) {
                                Fluttertoast.showToast(
                                    msg: "This permission is recommended");
                              }
                              if (cameraStatus ==
                                  PermissionStatus.permanentlyDenied) {
                                openAppSettings();
                              }

                              setState(() {});
                            },
                            child: Ink(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFEFEF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF9D9D9D),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            showImageDialog(widget.carId);

                            setState(() {});
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              Text(
                'เลือกรูปโปรไฟล์รถของคุณ',
                style: GoogleFonts.sarabun(
                  fontSize: 17,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            offset: const Offset(12, 26),
                            blurRadius: 50,
                            spreadRadius: 0,
                            color: Colors.grey.withOpacity(.1)),
                      ]),
                      child: TextField(
                        controller: licensePlateController,
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        decoration: const InputDecoration(
                          label: Text("ป้ายทะเบียนรถยนต์"),
                          labelStyle: TextStyle(
                            color: mainGreen,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(
                            Icons.car_crash,
                            color: mainGreen,
                          ),
                          filled: true,
                          fillColor: Color(0xffffffff),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: lightGreen, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainGreen, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffEF4444), width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: whiteGreen, width: 1.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.007,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '* ใช้สำหรับตั้งเป็นชื่อรถของคุณ ผู้ใช้งานอื่น ๆ จะไม่เห็นข้อมูลส่วนนี้',
                          style: GoogleFonts.sarabun(
                            color: gray,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (imageFile != null) {
                        carSend(
                          imageFile!.path,
                          widget.carId,
                          licensePlateController!.text,
                        );

                        Get.offAndToNamed('/profile');

                        // Get.offAll(
                        //   ScreensPage(
                        //     getToken: widget.getToken,
                        //     pageIndex: 2,
                        //     current: 0,
                        //   ),
                        // );
                      } else {
                        Fluttertoast.showToast(
                          msg: "กรุณาแนบรูปภาพมาด้วย",
                          backgroundColor: Colors.yellowAccent,
                          textColor: Colors.black,
                        );
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
                      'ยืนยัน',
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailInputFb2 extends StatelessWidget {
  final TextEditingController inputController;
  const EmailInputFb2({Key? key, required this.inputController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);
    const backgroundColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white.withOpacity(.9)),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)),
          ]),
          child: TextField(
            controller: inputController,
            onChanged: (value) {
              //Do something wi
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              label: const Text("Email"),
              labelStyle: const TextStyle(color: primaryColor),
              // prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: accentColor,
              hintText: 'support@flutterbricks.com',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: errorColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
